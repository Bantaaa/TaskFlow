package com.devsync.controller;

import com.devsync.domain.entity.Tag;
import com.devsync.domain.entity.Task;
import com.devsync.domain.entity.Token;
import com.devsync.domain.entity.User;
import com.devsync.domain.enums.Role;
import com.devsync.repository.Implementations.*;
import com.devsync.service.TagService;
import com.devsync.service.TaskService;
import com.devsync.service.TokenService;
import com.devsync.service.UserService;
import com.devsync.util.UserUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StatsServlet", value = "/stats")
public class StatsServlet extends HttpServlet {
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

        User AuthUser = (User) session.getAttribute("user");

        List<Task> tasks = taskService.getTasks(AuthUser);
        List<Tag> tags = tagService.getTags();
        Long modificationsTokens = tokenService.getModificationsSum();


        Map<Tag, Double> CompletPerTag = taskService.calculateCompletePercentageByTag(tasks, tags);
        request.setAttribute("CompletPerTag", CompletPerTag);
        request.setAttribute("tags", tags);
        request.setAttribute("user", AuthUser);
        request.setAttribute("modificationsTokens", modificationsTokens);
        this.getServletContext().getRequestDispatcher("/WEB-INF/views/Stats.jsp").forward(request,response);
    }

    public void destroy() {

    }
}