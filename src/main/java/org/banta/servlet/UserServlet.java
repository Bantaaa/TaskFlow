package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.banta.model.User;
import org.banta.service.UserService;
import org.banta.service.TaskService;

import java.io.IOException;
import java.util.Optional;
import java.util.logging.Logger;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UserServlet.class.getName());

    @Inject
    private UserService userService;

    @Inject
    private TaskService taskService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"MANAGER".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = request.getPathInfo();
        try {
            switch (action) {
                case "/create":
                    createUser(request, response);
                    break;
                case "/update":
                    updateUser(request, response);
                    break;
                case "/delete":
                    deleteUser(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
        } catch (Exception e) {
            logger.severe("Error processing request: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request");
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (!isValidInput(username, email, password, role)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input");
            return;
        }

        try {
            User newUser = new User(username, password, email, role.toUpperCase());
            userService.createUser(newUser);
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("User created successfully");
        } catch (Exception e) {
            logger.severe("Error creating user: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating user");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }

        try {
            Long id = Long.parseLong(idParam);
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (!isValidInput(username, email, password, role)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input");
                return;
            }

            Optional<User> userOptional = userService.getUserById(id);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                user.setUsername(username);
                user.setEmail(email);
                user.setRole(role.toUpperCase());
                if (password != null && !password.isEmpty()) {
                    user.setPassword(password); // UserService will hash the password
                }
                userService.updateUser(user);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("User updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format");
        } catch (Exception e) {
            logger.severe("Error updating user: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating user");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            Optional<User> userOptional = userService.getUserById(id);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                // First, delete or reassign all tasks associated with this user
                taskService.reassignOrDeleteTasksForUser(user);
                // Then, delete the user
                userService.deleteUser(id);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("User deleted successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format");
        } catch (Exception e) {
            logger.severe("Error deleting user: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting user");
        }
    }

    private boolean isValidInput(String username, String email, String password, String role) {
        return username != null && !username.isEmpty() &&
                email != null && !email.isEmpty() &&
                role != null && !role.isEmpty() && userService.isValidRole(role) &&
                (password == null || password.isEmpty() || password.length() >= 8);
    }
}