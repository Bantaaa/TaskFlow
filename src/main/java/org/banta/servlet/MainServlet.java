package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.banta.model.User;
import org.banta.model.Task;
import org.banta.service.UserService;
import org.banta.service.TaskService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/")
public class MainServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Inject
    private TaskService taskService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        List<Task> tasks = taskService.getAllTasks();
        request.setAttribute("users", users);
        request.setAttribute("tasks", tasks);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createUser(request, response);
                    break;
                case "edit":
                    updateUser(request, response);
                    break;
                case "delete":
                    deleteUser(request, response);
                    break;
                case "createTask":
                    createTask(request, response);
                    break;
                case "editTask":
                    updateTask(request, response);
                    break;
                case "deleteTask":
                    deleteTask(request, response);
                    break;
                case "updateTaskStatus":
                    updateTaskStatus(request, response);
                    return; // Return here to avoid redirect for AJAX calls
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
        } catch (Exception e) {
            log("Error processing request: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            return;
        }

        response.sendRedirect(request.getContextPath() + "/");
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (username == null || username.isEmpty() || email == null || email.isEmpty() || password == null || password.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        User newUser = new User(username, password, email);
        userService.createUser(newUser);
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required.");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            if (username == null || username.isEmpty() || email == null || email.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username and email cannot be empty.");
                return;
            }

            User user = userService.getUserById(id);
            if (user != null) {
                user.setUsername(username);
                user.setEmail(email);
                if (password != null && !password.isEmpty()) {
                    user.setPassword(password);
                }
                userService.updateUser(user);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required.");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            userService.deleteUser(id);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        }
    }

    private void createTask(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String statusStr = request.getParameter("status");

        if (title == null || title.isEmpty() || dueDateStr == null || dueDateStr.isEmpty() || statusStr == null || statusStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Title, due date, and status are required.");
            return;
        }

        try {
            LocalDate dueDate = LocalDate.parse(dueDateStr);
            Task.Status status = Task.Status.valueOf(statusStr);
            Task newTask = new Task(title, description, dueDate, status);
            taskService.createTask(newTask);
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format or status.");
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

            if (title == null || title.isEmpty() || dueDateStr == null || dueDateStr.isEmpty() || statusStr == null || statusStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Title, due date, and status are required.");
                return;
            }

            Task task = taskService.getTaskById(id);
            if (task != null) {
                LocalDate dueDate = LocalDate.parse(dueDateStr);
                Task.Status status = Task.Status.valueOf(statusStr);
                task.setTitle(title);
                task.setDescription(description);
                task.setDueDate(dueDate);
                task.setStatus(status);
                taskService.updateTask(task);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format or status.");
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