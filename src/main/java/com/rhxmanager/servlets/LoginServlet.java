package com.rhxmanager.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.http.HttpSession;

import com.rhxmanager.util.sessionUtils;
import com.rhxmanager.dao.EmployeDAO;
import com.rhxmanager.model.*;
import com.rhxmanager.util.passwordUtils;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (sessionUtils.ifLoggedInRedirects(request, response, "/dashboard")) {
            return; // stops method if redirect happens
        }

        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inputUsername = request.getParameter("username");
        String inputPassword = request.getParameter("password");

        EmployeDAO employeDAO = new EmployeDAO();
        Optional<Employe> employeOptional = employeDAO.findByUsername(inputUsername);

        boolean loginSuccess = false;
        Employe user = null;

        if (employeOptional.isPresent()) {
            user = employeOptional.get();
            if (passwordUtils.verifyPassword(inputPassword, user.getPassword())) {
                loginSuccess = true;
            }
        }

        if (loginSuccess) {
            // create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // saves Employe user in session
            session.setMaxInactiveInterval(30 * 60); // kills sessions after 30min

            // redirect to the dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            request.setAttribute("error", "Invalid username or password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}