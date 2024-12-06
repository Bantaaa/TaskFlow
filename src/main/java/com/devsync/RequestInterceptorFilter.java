package com.devsync;

import com.devsync.domain.entity.User;
import com.devsync.util.TokenUtils;
import com.devsync.util.UserUtils;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;

@WebFilter("/*")
public class RequestInterceptorFilter implements Filter {

    TokenUtils tokenUtils = new TokenUtils();
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {


    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);
        if (session != null) {

            User AuthUser = (User) session.getAttribute("user");

            if (AuthUser != null) {
                checkDailytokens(AuthUser);
                checkMonthlytokens(AuthUser);

            }

        }


        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private void interceptRequest(ServletRequest request) {
        // Custom logic, for example, logging
        System.out.println("Request intercepted from: " + request.getRemoteAddr());


    }

    private void checkDailytokens(User user) {
        LocalDate lastReset = user.getToken().getLastDailyReset();

        LocalDate currentDate = LocalDate.now();

        if (currentDate.isAfter(lastReset)) {
            tokenUtils.resetDailyTokens(user.getToken());
        }

    }

    private void checkMonthlytokens(User user) {
        LocalDate lastReset = user.getToken().getLastMonthlyReset();

        LocalDate currentDate = LocalDate.now();

        if (currentDate.isAfter(lastReset.plusMonths(1))) {
            tokenUtils.resetMonthlyTokens(user.getToken());
        }
    }
}
