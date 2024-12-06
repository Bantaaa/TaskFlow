package com.devsync.controller;

import java.io.*;
import java.util.List;
import java.util.Map;

import com.devsync.domain.entity.Tag;
import com.devsync.domain.entity.Task;
import com.devsync.domain.entity.Token;
import com.devsync.domain.entity.User;
import com.devsync.repository.Implementations.*;
import com.devsync.service.TagService;
import com.devsync.service.TaskService;
import com.devsync.service.TokenService;
import com.devsync.service.UserService;
import com.devsync.util.UserUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    private TaskService taskService;
    private TagService tagService;
    private UserService userService;
    private TokenService tokenService;

    public void init() {
        TaskRepository taskRepository = new TaskRepository();
        TagRepository tagRepository = new TagRepository();
        UserRepository userRepository = new UserRepository();
        TokenRepository tokenRepository = new TokenRepository();
        TaskRequestRepository taskRequestRepository = new TaskRequestRepository();
        this.taskService = new TaskService(taskRepository,userRepository,tokenRepository,taskRequestRepository);
        this.tagService = new TagService(tagRepository);
        this.userService = new UserService(userRepository, tokenRepository);
        this.tokenService = new TokenService(tokenRepository);

    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();

        User authUser = UserUtils.getCurrentUser(request);
        if (authUser == null) {
            response.sendRedirect("auth?form=login");
            return;
        }
        User AuthUser = (User) session.getAttribute("user");
        List<Task> tasks = taskService.getTasks(AuthUser);
        List<Task> unassignedTasks = taskService.getUnassignedTasks();
        List<Tag> tags = tagService.getTags();
        List<User> allUsers = userService.getAllUsers();
        Token userToken = tokenService.getTokenByUser(AuthUser);
        Map<Task, Long> taskRemainingDaysMap = taskService.getTasksWithRemainingDays();
        request.setAttribute("taskRemainingDays", taskRemainingDaysMap);
        request.setAttribute("tasks", tasks);
        request.setAttribute("unassignedTasks", unassignedTasks);
        request.setAttribute("tags", tags);
        request.setAttribute("users", allUsers);
        request.setAttribute("userToken", userToken);
        this.getServletContext().getRequestDispatcher("/WEB-INF/views/Home.jsp").forward(request,response);
    }

    public void destroy() {

    }
}