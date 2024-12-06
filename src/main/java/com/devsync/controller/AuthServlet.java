package com.devsync.controller;

import com.devsync.domain.entity.User;
import com.devsync.repository.Implementations.TokenRepository;
import com.devsync.repository.Implementations.UserRepository;
import com.devsync.service.UserService;
import com.devsync.util.UserUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "AuthServlet", value = "/auth")
public class AuthServlet extends HttpServlet {
    private UserService userService;



    public void init() {
        UserRepository userRepository = new UserRepository();
        TokenRepository tokenRepository = new TokenRepository();
        this.userService = new UserService(userRepository , tokenRepository);
        UserUtils.init(this.userService);

    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String authForm = request.getParameter("form");
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
        else {
            if(authForm.equals("login")) {
                request.getRequestDispatcher("/WEB-INF/views/AuthViews/login.jsp").forward(request, response);

            }
            else if(authForm.equals("register")) {
                request.getRequestDispatcher("/WEB-INF/views/AuthViews/register.jsp").forward(request, response);
            }

        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String authForm = request.getParameter("form");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");


        if(authForm.equals("login")) {
            Optional<User> user = userService.loginUser(email, password);
            if(user.isPresent()) {
                HttpSession session = request.getSession(false);
                session.setAttribute("user", user.get());
                response.sendRedirect(request.getContextPath() + "/home");
            }
            else {
                request.setAttribute("errorUser", "No User Found");
                request.getRequestDispatcher("/WEB-INF/views/AuthViews/login.jsp").forward(request, response);
            }
        }
        else if(authForm.equals("register")) {


            boolean userSaved = userService.registerUser(firstName, lastName, email, password);
            if (userSaved) {
                request.setAttribute("success", "Registration created successfully.");
                response.sendRedirect(request.getContextPath() + "/auth?form=login");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/AuthViews/register.jsp").forward(request, response);
            }

        }
        else if(authForm.equals("logout")) {
            request.getSession().removeAttribute("user");
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/auth?form=login");
        }
    }



        public void destroy() {
    }
}