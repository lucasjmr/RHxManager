package com.rhxmanager.servlets;

import com.rhxmanager.dao.DepartmentDao;
import com.rhxmanager.dao.EmployeDao;
import com.rhxmanager.model.Department;
import com.rhxmanager.model.Employe;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private final DepartmentDao departmentDao = new DepartmentDao();
    private final EmployeDao employeDao = new EmployeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            showDepartmentDetails(request, response);
        } else {
            listDepartments(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "create":
                createDepartment(request, response);
                break;
            case "assignEmployee":
                assignEmployee(request, response);
                break;
            case "removeEmployee":
                removeEmployee(request, response);
                break;
            case "assignChief":
                assignChief(request, response);
                break;
            default:
                listDepartments(request, response);
                break;
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDao.findAllWithEmployees());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/departments.jsp");
        dispatcher.forward(request, response);
    }

    private void showDepartmentDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Department not found with ID: " + id));

        request.setAttribute("department", department);
        request.setAttribute("availableEmployees", employeDao.findEmployeesWithoutDepartment());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/department-details.jsp");
        dispatcher.forward(request, response);
    }

    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("departmentName");

        if (departmentDao.findByName(name).isPresent()) {
            request.setAttribute("error", "A department with this name already exists.");
        } else {
            Department newDepartment = new Department();
            newDepartment.setDepartmentName(name);
            departmentDao.save(newDepartment);
            request.setAttribute("success", "Department created successfully.");
        }
        listDepartments(request, response);
    }

    private void assignEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));

        Department department = departmentDao.findById(departmentId).orElseThrow(() -> new ServletException("Department not found"));
        Employe employee = employeDao.findById(employeeId).orElseThrow(() -> new ServletException("Employee not found"));

        employee.setDepartment(department);
        employeDao.update(employee);

        response.sendRedirect(request.getContextPath() + "/departments?action=view&id=" + departmentId);
    }

    private void removeEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));

        Employe employee = employeDao.findById(employeeId).orElseThrow(() -> new ServletException("Employee not found"));

        employee.setDepartment(null);
        employeDao.update(employee);

        response.sendRedirect(request.getContextPath() + "/departments?action=view&id=" + departmentId);
    }

    private void assignChief(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        String chiefIdParam = request.getParameter("managerId");

        Department department = departmentDao.findById(departmentId)
                .orElseThrow(() -> new ServletException("Department not found"));

        if (chiefIdParam != null && !chiefIdParam.isEmpty()) {
            int chiefId = Integer.parseInt(chiefIdParam);
            Employe manager = employeDao.findById(chiefId)
                    .orElseThrow(() -> new ServletException("Manager employee not found"));
            department.setManager(manager);
        } else {
            department.setManager(null);
        }

        departmentDao.update(department);
        response.sendRedirect(request.getContextPath() + "/departments?action=view&id=" + departmentId);
    }
}