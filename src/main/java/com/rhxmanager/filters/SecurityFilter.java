package com.rhxmanager.filters;

import com.rhxmanager.model.Employe;
import com.rhxmanager.model.Role;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

@WebFilter("/*") // filters all requests
public class SecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (path.startsWith("/auth")) {
            chain.doFilter(req, res);
            return;
        }

        Employe user = (session != null) ? (Employe) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        if (path.startsWith("/employees") || path.startsWith("/departments") || path.startsWith("/projects") || path.startsWith("/payslips")) {
            boolean isAdmin = user.getRoles().stream().anyMatch(role -> "ADMIN".equals(role.getRoleName()));

            if (isAdmin) {
                chain.doFilter(req, res);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have permission to access this page.");
            }
        } else {
            chain.doFilter(req, res);
        }
    }
}