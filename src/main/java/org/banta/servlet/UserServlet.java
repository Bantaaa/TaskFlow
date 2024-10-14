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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.io.IOException;
import org.apache.commons.validator.routines.EmailValidator;
import java.util.Optional;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

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
        if (!currentUser.getRole().equals("MANAGER")) {
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
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            return;
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Input validation
        if (username == null || username.isEmpty() || email == null || email.isEmpty()
                || password == null || password.isEmpty() || role == null || role.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        // Check input lengths
        if (username.length() > 255 || email.length() > 255 || password.length() > 255 || role.length() > 255) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Input length exceeds maximum allowed.");
            return;
        }

        // Validate email format
        if (!EmailValidator.getInstance().isValid(email)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid email format.");
            return;
        }

        // Validate role
        if (!userService.isValidRole(role)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid role.");
            return;
        }

        // Hash the password
        String hashedPassword;
        try {
            hashedPassword = hashPassword(password);
        } catch (NoSuchAlgorithmException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing password.");
            return;
        }

        User newUser = new User(username, hashedPassword, email, role.toUpperCase());

        try {
            userService.createUser(newUser);
        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) { // PostgreSQL unique violation error code
                response.sendError(HttpServletResponse.SC_CONFLICT, "Username or email already exists.");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating user.");
            }
            return;
        }

        response.setStatus(HttpServletResponse.SC_CREATED);
        response.getWriter().write("User created successfully");
    }

    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
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
            String role = request.getParameter("role");

            if (username == null || username.isEmpty() || email == null || email.isEmpty() || role == null || role.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username, email, and role cannot be empty.");
                return;
            }

            if (!userService.isValidRole(role)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid role.");
                return;
            }

            Optional<User> userOptional = userService.getUserById(id);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                user.setUsername(username);
                user.setEmail(email);
                user.setRole(role.toUpperCase());
                if (password != null && !password.isEmpty()) {
                    user.setPassword(hashPassword(password));
                }
                userService.updateUser(user);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("User updated successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        } catch (NoSuchAlgorithmException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing password.");
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
            if (userService.getUserById(id).isPresent()) {
                userService.deleteUser(id);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("User deleted successfully");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        }
    }
}