package org.banta.service;

import org.banta.dao.TaskDAO;
import org.banta.model.Task;
import org.banta.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

class TaskServiceTest {

    private TaskService taskService;

    @Mock
    private TaskDAO taskDAO;

    @Mock
    private UserService userService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        taskService = new TaskService(taskDAO);
    }

    @Test
    void testCreateTask() {
        // Arrange
        Task task = new Task("Test Task", "Description", LocalDate.now().plusDays(4), Task.Status.TODO);
        task.setTags(new HashSet<>(Arrays.asList("Tag1", "Tag2")));
        User creator = new User();
        creator.setRole("MANAGER");
        task.setAssignedUser(creator);

        // Act
        taskService.createTask(task, creator);

        // Assert
        verify(taskDAO, times(1)).create(task);
    }


    @Test
    void testGetTaskById() {
        // Arrange
        Long taskId = 1L;
        Task task = new Task("Test Task", "Description", LocalDate.now(), Task.Status.TODO);
        when(taskDAO.findById(taskId)).thenReturn(task);

        // Act
        Optional<Task> result = taskService.getTaskById(taskId);

        // Assert
        assertTrue(result.isPresent());
        assertEquals(task, result.get());
        verify(taskDAO, Mockito.times(1)).findById(taskId);
    }

    @Test
    void testGetAllTasks() {
        // Arrange
        List<Task> tasks = Arrays.asList(
                new Task("Task 1", "Description 1", LocalDate.now(), Task.Status.TODO),
                new Task("Task 2", "Description 2", LocalDate.now(), Task.Status.IN_PROGRESS)
        );
        when(taskDAO.findAll()).thenReturn(tasks);

        // Act
        List<Task> result = taskService.getAllTasks();

        // Assert
        assertEquals(2, result.size());
        assertEquals(tasks, result);
        verify(taskDAO, Mockito.times(1)).findAll();
    }

    @Test
    void testUpdateTask() {
        // Arrange
        Task task = new Task("Updated Task", "New Description", LocalDate.now().plusDays(1), Task.Status.IN_PROGRESS);
        User updater = new User();
        updater.setRole("MANAGER");

        // Act
        taskService.updateTask(task, updater);

        // Assert
        verify(taskDAO, Mockito.times(1)).update(task);
    }

    @Test
    void testDeleteTask() {
        // Arrange
        Long taskId = 1L;
        Task task = new Task("Test Task", "Description", LocalDate.now(), Task.Status.TODO);
        User deleter = new User();
        deleter.setRole("MANAGER");
        when(taskDAO.findById(taskId)).thenReturn(task);

        // Act
        taskService.deleteTask(taskId, deleter);

        // Assert
        verify(taskDAO, Mockito.times(1)).delete(task);
    }

    @Test
    void testGetTasksByUser() {
        // Arrange
        User user = new User();
        List<Task> userTasks = Arrays.asList(
                new Task("User Task 1", "Description 1", LocalDate.now(), Task.Status.TODO),
                new Task("User Task 2", "Description 2", LocalDate.now(), Task.Status.IN_PROGRESS)
        );
        when(taskDAO.findByUser(user)).thenReturn(userTasks);

        // Act
        List<Task> result = taskService.getTasksByUser(user);

        // Assert
        assertEquals(2, result.size());
        assertEquals(userTasks, result);
        verify(taskDAO, Mockito.times(1)).findByUser(user);
    }

    @Test
    void testMarkOverdueTasks() {
        // Arrange
        List<Task> overdueTasks = Arrays.asList(
                new Task("Overdue Task 1", "Description 1", LocalDate.now().minusDays(1), Task.Status.IN_PROGRESS),
                new Task("Overdue Task 2", "Description 2", LocalDate.now().minusDays(2), Task.Status.IN_PROGRESS)
        );
        when(taskDAO.findOverdueTasks()).thenReturn(overdueTasks);

        // Act
        taskService.markOverdueTasks();

        // Assert
        verify(taskDAO, Mockito.times(1)).findOverdueTasks();
        verify(taskDAO, Mockito.times(2)).update(any(Task.class));
        overdueTasks.forEach(task -> assertEquals(Task.Status.TODO, task.getStatus()));
    }

    @Test
    void testAssignAdditionalTask() {
        // Arrange
        Task task = new Task("Assigned Task", "Description", LocalDate.now(), Task.Status.TODO);
        User assignee = new User();
        User assigner = new User();
        assigner.setRole("MANAGER");

        // Act
        taskService.assignAdditionalTask(task, assignee, assigner);

        // Assert
        assertEquals(assignee, task.getAssignedUser());
        verify(taskDAO, Mockito.times(1)).update(task);
    }

    @Test
    void testReassignOrDeleteTasksForUser() {
        // Arrange
        User user = new User();
        List<Task> userTasks = Arrays.asList(
                new Task("User Task 1", "Description 1", LocalDate.now(), Task.Status.TODO),
                new Task("User Task 2", "Description 2", LocalDate.now(), Task.Status.IN_PROGRESS)
        );
        when(taskDAO.findByUser(user)).thenReturn(userTasks);

        // Act
        taskService.reassignOrDeleteTasksForUser(user);

        // Assert
        verify(taskDAO, Mockito.times(1)).findByUser(user);
        verify(taskDAO, Mockito.times(2)).delete(any(Task.class));
    }
}