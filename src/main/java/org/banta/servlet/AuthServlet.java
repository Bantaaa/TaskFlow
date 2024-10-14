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

import java.io.IOException;
import java.util.Optional;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if ("/logout".equals(action)) {
            logout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();
        if ("/login".equals(action)) {
            login(request, response);
        } else if ("/register".equals(action)) {
            register(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        Optional<User> userOptional = userService.authenticate(username, password);
        if (userOptional.isPresent()) {
            HttpSession session = request.getSession();
            session.setAttribute("user", userOptional.get());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (role == null || role.isEmpty()) {
            role = "USER"; // Default role
        }

        role = role.toUpperCase();

        if (!userService.isValidRole(role)) {
            request.setAttribute("error", "Invalid role specified");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            User newUser = new User(username, password, email, role);
            userService.createUser(newUser);
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home.jsp");
    }
}