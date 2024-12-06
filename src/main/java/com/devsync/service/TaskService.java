package com.devsync.service;


import com.devsync.domain.entity.*;
import com.devsync.domain.enums.Role;
import com.devsync.domain.enums.TaskStatus;
import com.devsync.repository.Implementations.*;
import com.devsync.util.DateUtils;
import com.devsync.util.UserUtils;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;




public class TaskService {


    private TaskRepository taskRepository;
    private UserRepository userRepository;
    private TokenRepository tokenRepository;
    private TaskRequestRepository taskRequestRepository;

    public TaskService(TaskRepository taskRepository, UserRepository userRepository, TokenRepository tokenRepository, TaskRequestRepository taskRequestRepository) {
        this.taskRepository = taskRepository;
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
        this.taskRequestRepository = taskRequestRepository;
    }

    public boolean addTask(Task task) {
        if(taskRepository.save(task)){
            return true;
        }
        return false;
    }

    public List<Task> getTasks(User user) {
        List<Task> allTasks =  taskRepository.findAll();

        if(user.getRole() == Role.INDIVIDUAL) {
            return allTasks.stream()
                .filter(t -> (t.getAssignee() != null && Objects.equals(t.getAssignee().getId(), user.getId()))
                    || Objects.equals(t.getCreatedBy().getId(), user.getId()))
                .collect(Collectors.toList());

        }
        else {
            return allTasks;
        }


    }

    public List<Task> getAllTasks () {
        return  taskRepository.findAll();
    }

    public List<Task> getUnassignedTasks() {
        LocalDateTime now = LocalDateTime.now();
        List<Task> allTasks =  taskRepository.findAll();
        List<Task> unassignedTasks = allTasks.stream()
            .filter(t -> t.getAssignee() == null)
            .filter(t -> ChronoUnit.DAYS.between(now, t.getDueDate()) > 3)
            .collect(Collectors.toList());

        return unassignedTasks;
    }

    public Task getTaskById(Long taskId) {
        return taskRepository.findById(taskId);
    }

    public boolean updateTaskAssignee(Task task, HttpSession session) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime dueDate = task.getDueDate();

        long daysBetween = ChronoUnit.DAYS.between(now, dueDate);
        if (daysBetween < 3) {
            session.setAttribute("error", "Cannot plan a task less than 3 days from now.");
            return false;
        }
        try {
            taskRepository.update(task);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTask(Task task, HttpSession session) {
        try {
            if (task.getDueDate().isBefore(LocalDateTime.now()) && task.getStatus() == TaskStatus.COMPLETED) {
                session.setAttribute("error", "Can't mark a task as completed if it's overdue.");
                return false;
            }

            taskRepository.update(task);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTask(Long taskId, HttpSession session) {
        User user = (User) session.getAttribute("user");

        Task task = taskRepository.findById(taskId);

        Token userToken = tokenRepository.findByUser(user);

        System.out.println(userToken);

        if(Objects.equals(task.getCreatedBy().getId(), user.getId())) {
            return taskRepository.delete(taskId);
        }
        else if(userToken.getMonthlyDeletionTokens() > 0) {
/*
            System.out.println(3);
*/          if(task.isRefused()) {
                session.setAttribute("error", "You are not allowed to delete this task.");
                return false;
            }
            taskRepository.delete(taskId);
            userToken.setMonthlyDeletionTokens(userToken.getMonthlyDeletionTokens() - 1);

            tokenRepository.update(userToken);

            return true;
        } else {
            session.setAttribute("error", "Not enough Tokens to Delete.");
            return false;

        }


    }

    public boolean changeTask(Long taskId,Long oldTaskId,Long userId, HttpSession session) {
        Task task = taskRepository.findById(taskId);
        Task oldTask = taskRepository.findById(oldTaskId);

        if(oldTask.isRefused()) {
            session.setAttribute("error", "Task already refused!");
            return false;
        }

        User user = userRepository.findById(userId);



        Token userToken = tokenRepository.findByUser(user);

        if(userToken.getDailyModificationTokens() > 0)
        {
            TaskRequest taskrequest = new TaskRequest();

            taskrequest.setType("modification");
            taskrequest.setOldtask(oldTask);
            taskrequest.setNewtask(task);
            taskrequest.setRequestedBy(user);
            taskrequest.setApproved(false);
            taskrequest.setExpired(false);

            if(taskRequestRepository.save(taskrequest)) {
                session.setAttribute("taskRequestSuccess", "Request to change task sent. Wait for Approval");
            }

            return true;
        }
        else {
            session.setAttribute("error", "No Modification Tokens Left.");
            return false;
        }


    }

    public Map<Task, Long> getTasksWithRemainingDays() {
        List<Task> tasks = taskRepository.findAll();
        Map<Task, Long> taskRemainingDaysMap = new HashMap<>();

        for (Task task : tasks) {
            long remainingDays = DateUtils.calculateRemainingDays(task);
            taskRemainingDaysMap.put(task, remainingDays);
        }

        return taskRemainingDaysMap;
    }

    public List<TaskRequest> getAllUnapprovedRequests() {
        List<TaskRequest> allRequests =  taskRequestRepository.findAll();

        List<TaskRequest> unApprovedRequests = allRequests.stream()
            .filter(r -> !r.isApproved())
            .collect(Collectors.toList());


        for (TaskRequest rqust : unApprovedRequests) {
            LocalDateTime createdAt = rqust.getCreatedAt();
            LocalDateTime now = LocalDateTime.now();
            long hoursDiff = ChronoUnit.HOURS.between(createdAt, now);
            rqust.setHoursDiff(hoursDiff);
        }

        return unApprovedRequests;
    }

    public boolean approveRequest(Long requId, Long newUserId , HttpSession session) {

        TaskRequest taskRequest = taskRequestRepository.findById(requId);

        if(taskRequest != null) {

            User user  = taskRequest.getRequestedBy();
            User newUser = userRepository.findById(newUserId);

            Token userToken = tokenRepository.findByUser(user);
            Task task = taskRequest.getNewtask();
            Task oldTask = taskRequest.getOldtask();

            task.setAssignee(user);
            oldTask.setAssignee(newUser);
            oldTask.setRefused(true);
            oldTask.setChangeDate(LocalDateTime.now());

            if(!updateTaskAssignee(oldTask, session)) {
                return false;
            }
            updateTaskAssignee(task, session);


//            taskRepository.update(task);
//            taskRepository.update(oldTask);

            taskRequest.setApproved(true);
            taskRequest.setRespondedAt(LocalDateTime.now());

            LocalDateTime createdAt = taskRequest.getCreatedAt();
            LocalDateTime now = LocalDateTime.now();
            long hoursDiff = ChronoUnit.HOURS.between(createdAt, now);

            taskRequestRepository.update(taskRequest);

            userToken.setDailyModificationTokens(userToken.getDailyModificationTokens() - 1);

            if(hoursDiff > 12) {
                userToken.setDailyModificationTokens(userToken.getDailyModificationTokens() * 2);
            }

            Token updatedToken = tokenRepository.update(userToken);
            if(updatedToken != null) {
                return true;
            }
        }
        return false;






    }

    public boolean updateTaskDeadline(Long taskId, LocalDateTime dueDate , HttpSession session) {
        Task task = taskRepository.findById(taskId);

        task.setDueDate(dueDate);
        if(taskRepository.update(task)) {
            return true;
        }
        return false;
    }

    public Map<Tag, Double> calculateCompletePercentageByTag(List<Task> tasks, List<Tag> tags) {
       Map<Tag, Double> completePercentageMap = new HashMap<>();
        for(Tag tag : tags) {


        List<Task> tasksWithTag = tasks.stream()
            .filter(task -> task.getTags().contains(tag))
            .collect(Collectors.toList());

        long completedTasks = tasksWithTag.stream()
            .filter(task -> task.getStatus() == TaskStatus.COMPLETED)
            .count();

       double percentage=  tasksWithTag.isEmpty() ? 0 : (double) completedTasks / tasksWithTag.size() * 100;

       completePercentageMap.put(tag, percentage);

        }

        return completePercentageMap;
    }









}
