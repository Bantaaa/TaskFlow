package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.banta.model.Task;
import org.banta.model.User;
import org.banta.service.TaskService;
import org.banta.service.UserService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Optional;

@WebServlet("/task/*")
public class TaskServlet extends HttpServlet {

    @Inject
    private TaskService taskService;

    @Inject
    private UserService userService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String action = request.getPathInfo();

        try {
            switch (action) {
                case "/create":
                    createTask(request, response, currentUser);
                    break;
                case "/update":
                    updateTask(request, response, currentUser);
                    break;
                case "/delete":
                    deleteTask(request, response, currentUser);
                    break;
                case "/updateStatus":
                    updateTaskStatus(request, response, currentUser);
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

    private void createTask(HttpServletRequest request, HttpServletResponse response, User currentUser) throws IOException {
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

            if (currentUser.getRole().equals("MANAGER") && assignedUserIdStr != null && !assignedUserIdStr.isEmpty()) {
                Long assignedUserId = Long.parseLong(assignedUserIdStr);
                Optional<User> assignedUserOptional = userService.getUserById(assignedUserId);
                assignedUserOptional.ifPresent(newTask::setAssignedUser);
            } else {
                newTask.setAssignedUser(currentUser);
            }

            taskService.createTask(newTask, currentUser);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("Task created successfully");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response, User currentUser) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Optional<Task> taskOptional = taskService.getTaskById(id);
            if (taskOptional.isPresent()) {
                Task task = taskOptional.get();
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

                if (currentUser.getRole().equals("MANAGER") && assignedUserIdStr != null && !assignedUserIdStr.isEmpty()) {
                    Long assignedUserId = Long.parseLong(assignedUserIdStr);
                    Optional<User> assignedUserOptional = userService.getUserById(assignedUserId);
                    assignedUserOptional.ifPresent(task::setAssignedUser);
                }

                taskService.updateTask(task, currentUser);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Task updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (IllegalArgumentException e) {
            if (e.getMessage().contains("No modification tokens available")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No modification tokens available");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
            }
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response, User currentUser) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required.");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            taskService.deleteTask(id, currentUser);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Task deleted successfully");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (IllegalArgumentException e) {
            if (e.getMessage().contains("No deletion tokens available")) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "No deletion tokens available");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input: " + e.getMessage());
            }
        }
    }

    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response, User currentUser) throws IOException {
        String idParam = request.getParameter("id");
        String statusParam = request.getParameter("status");
        String assignedUserIdParam = request.getParameter("assignedUserId");

        if (idParam == null || statusParam == null || assignedUserIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID, status, and assigned user ID are required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            Task.Status status = Task.Status.valueOf(statusParam);
            Long assignedUserId = Long.parseLong(assignedUserIdParam);

            Optional<Task> taskOptional = taskService.getTaskById(id);
            if (taskOptional.isPresent()) {
                Task task = taskOptional.get();
                task.setStatus(status);
                Optional<User> assignedUserOptional = userService.getUserById(assignedUserId);
                assignedUserOptional.ifPresent(task::setAssignedUser);
                taskService.updateTask(task, currentUser);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Task status updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID or Assigned User ID format.");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid status or " + e.getMessage());
        }
    }
}