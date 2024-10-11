package org.banta.servlet;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.banta.service.TaskService;
import org.banta.service.UserService;

import java.io.IOException;

@WebServlet("/")
public class MainServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Inject
    private TaskService taskService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", userService.getAllUsers());
        request.setAttribute("tasks", taskService.getAllTasks());
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}