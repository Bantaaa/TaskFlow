package com.devsync.listener;

import com.devsync.TaskScheduler;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    private TaskScheduler taskScheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        try {
            taskScheduler = new TaskScheduler();
            taskScheduler.start();
            context.setAttribute("taskScheduler", taskScheduler);
            System.out.println("Task Scheduler started successfully.");
        } catch (Exception e) {
            System.err.println("Error starting Task Scheduler: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        TaskScheduler scheduler = (TaskScheduler) context.getAttribute("taskScheduler");
        if (scheduler != null) {
            try {
                scheduler.shutdown();
                System.out.println("Task Scheduler stopped successfully.");
            } catch (Exception e) {
                System.err.println("Error stopping Task Scheduler: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}