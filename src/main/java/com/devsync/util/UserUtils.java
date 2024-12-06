package com.devsync.util;

import com.devsync.domain.entity.User;
import com.devsync.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class UserUtils {
    private static UserService userService;

    public static void init(UserService userService) {
        UserUtils.userService = userService;
    }

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User sessionUser = (User) session.getAttribute("user");

            User updatedUser = userService.getUserById(sessionUser.getId());
            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);
                return updatedUser;
            }
        }
        return null;
    }

    public static void updateUserInSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("user", user);
        }
    }


    public static void refreshUserInSession(HttpServletRequest request) {
        User currentUser = getCurrentUser(request);
        if (currentUser != null) {
            User refreshedUser = userService.getUserById(currentUser.getId());
            updateUserInSession(request, refreshedUser);
        }
    }
}