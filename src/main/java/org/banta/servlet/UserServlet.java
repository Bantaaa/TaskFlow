package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.banta.model.User;
import org.banta.service.UserService;

import java.io.IOException;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        listUsers(request, response);
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
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            log("Error processing POST request: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error retrieving user list: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Failed to retrieve user list. Please try again later.");
            request.setAttribute("users", List.of());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
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
        response.sendRedirect(request.getContextPath() + "/user");
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
                response.sendRedirect(request.getContextPath() + "/user");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User ID is required.");
            return;
        }
        try {
            Long id = Long.parseLong(idParam);
            userService.deleteUser(id);
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid User ID format.");
        } catch (Exception e) {
            log("Error deleting user: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting user: " + e.getMessage());
        }
    }
}