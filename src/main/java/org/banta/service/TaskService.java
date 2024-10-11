package org.banta.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import org.banta.dao.TaskDAO;
import org.banta.model.Task;
import org.banta.model.User;

import java.time.LocalDate;
import java.util.List;

@Stateless
public class TaskService {

    @Inject
    private TaskDAO taskDAO;

    public void createTask(Task task) {
        validateTaskCreation(task);
        taskDAO.create(task);
    }

    public Task getTaskById(Long id) {
        return taskDAO.findById(id);
    }

    public List<Task> getAllTasks() {
        return taskDAO.findAll();
    }

    public void updateTask(Task task) {
        validateTaskUpdate(task);
        taskDAO.update(task);
    }

    public void deleteTask(Long id) {
        Task task = getTaskById(id);
        if (task != null) {
            taskDAO.delete(task);
        }
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

    private void validateTaskCreation(Task task) {
        LocalDate currentDate = LocalDate.now();
        if (task.getDueDate().isBefore(currentDate)) {
            throw new IllegalArgumentException("Task cannot be created in the past");
        }
        if (task.getDueDate().isBefore(currentDate.plusDays(3))) {
            throw new IllegalArgumentException("Task cannot be scheduled more than 3 days in advance");
        }
        if (task.getTags().size() < 2) {
            throw new IllegalArgumentException("Task must have at least two tags");
        }
    }

    private void validateTaskUpdate(Task task) {
        if (task.getStatus() == Task.Status.DONE && task.getDueDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Task cannot be marked as done after the due date");
        }
    }
}