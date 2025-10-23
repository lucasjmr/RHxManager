package com.rhxmanager.servlets;

import com.rhxmanager.dao.EmployeDao;
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

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("signup".equals(action)) {
            handleSignup(request, response);
        } else {
            request.setAttribute("error", "Invalid action.");
            request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputUsername = request.getParameter("username");
        String inputPassword = request.getParameter("password");

        EmployeDao employeDao = new EmployeDao();
        Optional<Employe> employeOptional = employeDao.findByUsername(inputUsername);

        boolean loginSuccess = false;
        Employe user = null;

        if (employeOptional.isPresent()) {
            user = employeOptional.get();
            if (PasswordUtil.verifyPassword(inputPassword, user.getPassword())) {
                loginSuccess = true;
            }
        }

        if (loginSuccess) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        EmployeDao employeDao = new EmployeDao();

        if (employeDao.findByUsername(username).isPresent()) {
            request.setAttribute("signupError", "This username is already taken.");
            request.setAttribute("showSignup", true);
            request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 8) {
            request.setAttribute("signupError", "Password must be at least 8 characters long.");
            request.setAttribute("showSignup", true);
            request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
            return;
        }

        Employe newUser = new Employe();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setUsername(username);
        newUser.setPassword(PasswordUtil.hashPassword(password));

        employeDao.save(newUser);

        request.setAttribute("signupSuccess", "Account created successfully! Please log in.");
        request.getRequestDispatcher("/WEB-INF/jsp/auth.jsp").forward(request, response);
    }
}