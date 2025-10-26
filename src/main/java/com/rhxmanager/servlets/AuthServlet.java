package com.rhxmanager.servlets;

import com.rhxmanager.dao.EmployeDao; // Utilisez votre nom de DAO
import com.rhxmanager.model.Employe;
import com.rhxmanager.util.PasswordUtil;
import com.rhxmanager.util.SessionUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (SessionUtil.ifLoggedInRedirects(request, response, "/dashboard")) {
            return;
        }
        request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputUsername = request.getParameter("username");
        String inputPassword = request.getParameter("password");

        EmployeDao employeDao = new EmployeDao();
        Optional<Employe> employeOptional = employeDao.findByUsername(inputUsername);

        if (employeOptional.isPresent()) {
            Employe user = employeOptional.get();
            if (PasswordUtil.verifyPassword(inputPassword, user.getPassword())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }

        request.setAttribute("error", "Invalid username or password.");
        request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
    }
}