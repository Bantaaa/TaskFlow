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
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Optional;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UserServlet.class.getName());

    @Inject
    private UserService userService;

    @Inject
    private TaskService taskService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        logger.info("Received POST request to /user/create");

        // Log all parameters
        logger.info("All request parameters:");
        request.getParameterMap().forEach((key, value) ->
                logger.info(key + ": " + Arrays.toString(value)));

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        logger.log(Level.INFO, "Parsed parameters - username: {0}, email: {1}, password: {2}",
                new Object[]{username, email, password != null ? "****" : null});

        try {
            validateInput(username, email, password);

            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password); // Note: In a real application, you should hash the password before storing

            userService.createUser(newUser);

            logger.log(Level.INFO, "User created successfully: {0}", username);
            response.setContentType("text/plain");
            response.getWriter().write("User created successfully");
        } catch (IllegalArgumentException e) {
            logger.log(Level.WARNING, "Invalid input for user creation: {0}", e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("text/plain");
            response.getWriter().write("Invalid input: " + e.getMessage());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error occurred while creating user", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/plain");
            response.getWriter().write("An error occurred while creating the user");
        }
    }

    private void validateInput(String username, String email, String password) {
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username cannot be empty");
        }
        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email address");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters long");
        }
        // Add any additional validation rules here
    }

    private boolean isValidEmail(String email) {
        // This is a simple email validation. For production, consider using a more robust method.
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
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