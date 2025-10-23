package com.rhxmanager.servlets;

import com.rhxmanager.dao.DepartmentDao;
import com.rhxmanager.dao.EmployeDao;
import com.rhxmanager.dao.ProjectDao;
import com.rhxmanager.model.Employe;
import com.rhxmanager.model.ProjectState;

import com.rhxmanager.util.SessionUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // false = not creating session if it doesnt exist

        if (SessionUtil.ifNotLoggedInRedirects(request, response, "/auth")) {
            return;
        }

        Employe loggedInUser = (Employe) session.getAttribute("user");

        EmployeDao employeDao = new EmployeDao();
        DepartmentDao departmentDao = new DepartmentDao();
        ProjectDao projectDao = new ProjectDao();

        int totalEmployees = employeDao.findAll().size();
        int totalDepartments = departmentDao.findAll().size();
        long totalProjects = projectDao.findAll().size();
        long activeProjects = projectDao.countByState(ProjectState.WORKED_ON);

        request.setAttribute("user", loggedInUser);
        request.setAttribute("totalEmployees", totalEmployees);
        request.setAttribute("totalDepartments", totalDepartments);
        request.setAttribute("totalProjects", totalProjects);
        request.setAttribute("activeProjects", activeProjects);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}