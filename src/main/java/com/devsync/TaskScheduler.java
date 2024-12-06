package com.devsync;

import com.devsync.domain.entity.Task;
import com.devsync.domain.enums.TaskStatus;
import com.devsync.repository.Implementations.TaskRepository;
import com.devsync.repository.Implementations.TaskRequestRepository;
import com.devsync.repository.Implementations.TokenRepository;
import com.devsync.repository.Implementations.UserRepository;
import com.devsync.service.TaskService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.stream.Collectors;

public class TaskScheduler {

    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private final TaskService taskService;
    private static final Logger logger = LoggerFactory.getLogger(TaskScheduler.class);


    public TaskScheduler() {
        TaskRepository taskRepository = new TaskRepository();
        UserRepository userRepository  = new UserRepository();
        TokenRepository tokenRepository  = new TokenRepository();
        TaskRequestRepository taskRequestRepository = new TaskRequestRepository();
        this.taskService = new TaskService(taskRepository, userRepository, tokenRepository, taskRequestRepository);
    }

    public void start() {
        scheduler.scheduleAtFixedRate(this::checkAndUpdateTasks, 0, 24, TimeUnit.HOURS);
    }

    private void checkAndUpdateTasks() {
        logger.info("AAAAAAAA");
        List<Task> overdueTasks = taskService.getAllTasks().stream()
            .filter(task -> task.getStatus() != TaskStatus.COMPLETED && task.getDueDate().isBefore(LocalDateTime.now()))
            .collect(Collectors.toList());

        for (Task task : overdueTasks) {
            task.setStatus(TaskStatus.UNCOMPLETED);
            taskService.updateTask(task, null);
        }
    }


    public void shutdown() {
        scheduler.shutdown();
        try {
            if (!scheduler.awaitTermination(60, TimeUnit.SECONDS)) {
                scheduler.shutdownNow();
            }
        } catch (InterruptedException e) {
            scheduler.shutdownNow();
        }
        logger.info("Task Scheduler has been shut down.");
    }


}