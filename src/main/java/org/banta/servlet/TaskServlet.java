package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.banta.model.Task;
import org.banta.model.User;
import org.banta.service.TaskService;
import org.banta.service.UserService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;

@WebServlet("/task/*")
public class TaskServlet extends HttpServlet {

    @Inject
    private TaskService taskService;

    @Inject
    private UserService userService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        try {
            switch (action) {
                case "/create":
                    createTask(request, response);
                    break;
                case "/update":
                    updateTask(request, response);
                    break;
                case "/delete":
                    deleteTask(request, response);
                    break;
                case "/updateStatus":
                    updateTaskStatus(request, response);
                    return; // Return here to avoid redirect for AJAX calls
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            return;
        }
        response.sendRedirect(request.getContextPath() + "/");
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String statusStr = request.getParameter("status");
        String tagsStr = request.getParameter("tags");
        String assignedUserIdStr = request.getParameter("assignedUserId");

        if (title == null || title.isEmpty() || dueDateStr == null || dueDateStr.isEmpty() || statusStr == null || statusStr.isEmpty() || tagsStr == null || tagsStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Title, due date, status, and tags are required.");
            return;
        }

        try {
            LocalDate dueDate = LocalDate.parse(dueDateStr);
            Task.Status status = Task.Status.valueOf(statusStr);
            String[] tagArray = tagsStr.split(",");
            if (tagArray.length < 2) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "At least two tags are required.");
                return;
            }

            Task newTask = new Task(title, description, dueDate, status);
            newTask.setTags(new HashSet<>(Arrays.asList(tagArray)));

            if (assignedUserIdStr != null && !assignedUserIdStr.isEmpty()) {
                Long assignedUserId = Long.parseLong(assignedUserIdStr);
                User assignedUser = userService.getUserById(assignedUserId);
                if (assignedUser != null) {
                    newTask.setAssignedUser(assignedUser);
                }
            }

            taskService.createTask(newTask);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDateStr = request.getParameter("dueDate");
            String statusStr = request.getParameter("status");
            String tagsStr = request.getParameter("tags");
            String assignedUserIdStr = request.getParameter("assignedUserId");

            if (title == null || title.isEmpty() || dueDateStr == null || dueDateStr.isEmpty() || statusStr == null || statusStr.isEmpty() || tagsStr == null || tagsStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Title, due date, status, and tags are required.");
                return;
            }

            Task task = taskService.getTaskById(id);
            if (task != null) {
                LocalDate dueDate = LocalDate.parse(dueDateStr);
                Task.Status status = Task.Status.valueOf(statusStr);
                String[] tagArray = tagsStr.split(",");
                if (tagArray.length < 2) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "At least two tags are required.");
                    return;
                }

                task.setTitle(title);
                task.setDescription(description);
                task.setDueDate(dueDate);
                task.setStatus(status);
                task.setTags(new HashSet<>(Arrays.asList(tagArray)));

                if (assignedUserIdStr != null && !assignedUserIdStr.isEmpty()) {
                    Long assignedUserId = Long.parseLong(assignedUserIdStr);
                    User assignedUser = userService.getUserById(assignedUserId);
                    if (assignedUser != null) {
                        task.setAssignedUser(assignedUser);
                    }
                } else {
                    task.setAssignedUser(null);
                }

                taskService.updateTask(task);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required.");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            taskService.deleteTask(id);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        }
    }

    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");

        if (idParam == null || statusParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID and status are required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Task.Status status = Task.Status.valueOf(statusParam);

            Task task = taskService.getTaskById(id);
            if (task != null) {
                task.setStatus(status);
                taskService.updateTask(task);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Task status updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status.");
        }
    }
}