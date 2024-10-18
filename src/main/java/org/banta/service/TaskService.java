package org.banta.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.banta.dao.TaskDAO;
import org.banta.model.Task;
import org.banta.model.User;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Stateless
public class TaskService {

    @Inject
    private TaskDAO taskDAO;

    @Inject
    private UserService userService;

    public void createTask(Task task, User creator) {
        validateTaskCreation(task, creator);
        taskDAO.create(task);
    }

    public Optional<Task> getTaskById(Long id) {
        return Optional.ofNullable(taskDAO.findById(id));
    }

    public List<Task> getAllTasks() {
        return taskDAO.findAll();
    }

    public void updateTask(Task task, User updater) {
        validateTaskUpdate(task, updater);
        taskDAO.update(task);
    }

    public void deleteTask(Long id, User deleter) {
        Optional<Task> taskOptional = getTaskById(id);
        taskOptional.ifPresent(task -> {
            validateTaskDeletion(task, deleter);
            taskDAO.delete(task);
        });
    }

    public List<Task> getTasksByUser(User user) {
        return taskDAO.findByUser(user);
    }

    public void markOverdueTasks() {
        List<Task> overdueTasks = taskDAO.findOverdueTasks();
        for (Task task : overdueTasks) {
            task.setStatus(Task.Status.TODO);
            taskDAO.update(task);
        }
    }

    public void assignAdditionalTask(Task task, User assignee, User assigner) {
        if (!assigner.getRole().equals("MANAGER") && !assigner.equals(assignee)) {
            throw new IllegalArgumentException("Only managers can assign tasks to other users");
        }
        task.setAssignedUser(assignee);
        taskDAO.update(task);
    }

    public boolean canUseModificationToken(User user) {
        // Implement logic to check if the user has available modification tokens
        // This might involve checking a separate token tracking system
        return true; // Placeholder implementation
    }

    public boolean canUseDeletionToken(User user) {
        // Implement logic to check if the user has available deletion tokens
        // This might involve checking a separate token tracking system
        return true; // Placeholder implementation
    }

    private void validateTaskCreation(Task task, User creator) {
        LocalDate currentDate = LocalDate.now();
        if (task.getDueDate().isBefore(currentDate)) {
            throw new IllegalArgumentException("Task cannot be created in the past");
        }
        if (task.getDueDate().isBefore(currentDate.plusDays(3))) {
            throw new IllegalArgumentException("Task should be scheduled more than 3 days in advance");
        }
        if (task.getTags().size() < 2) {
            throw new IllegalArgumentException("Task must have at least two tags");
        }
        if (!creator.getRole().equals("MANAGER") && !task.getAssignedUser().equals(creator)) {
            throw new IllegalArgumentException("Users can only assign tasks to themselves");
        }
    }

    private void validateTaskUpdate(Task task, User updater) {
        if (task.getStatus() == Task.Status.DONE && task.getDueDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Task cannot be marked as done after the due date");
        }
        if (!updater.getRole().equals("MANAGER") && !task.getAssignedUser().equals(updater)) {
            if (!canUseModificationToken(updater)) {
                throw new IllegalArgumentException("No modification tokens available");
            }
            // Implement logic to use a modification token
        }
    }

    private void validateTaskDeletion(Task task, User deleter) {
        if (!deleter.getRole().equals("MANAGER") && !task.getAssignedUser().equals(deleter)) {
            if (!canUseDeletionToken(deleter)) {
                throw new IllegalArgumentException("No deletion tokens available");
            }
            // Implement logic to use a deletion token
        }
    }
    @Transactional
    public void reassignOrDeleteTasksForUser(User user) {
        List<Task> userTasks = taskDAO.findByUser(user);
        for (Task task : userTasks) {
            // Option 1: Delete the task
            taskDAO.delete(task);

            // Option 2: Reassign the task to a default user or admin
            // User defaultUser = userDAO.findDefaultUser();
            // task.setAssignedUser(defaultUser);
            // taskDAO.update(task);
        }
    }
}