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
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private final DepartmentDao departmentDao = new DepartmentDao();
    private final EmployeDao employeDao = new EmployeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            showEditForm(request, response);
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
            case "update":
                updateDepartment(request, response);
                break;
            case "delete":
                deleteDepartment(request, response);
                break;
            default:
                listDepartments(request, response);
                break;
        }
    }

    private void listDepartments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("departments", departmentDao.findAllWithEmployees());
        request.getRequestDispatcher("/WEB-INF/jsp/departments.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Department not found"));

        request.setAttribute("department", department);
        request.setAttribute("allEmployees", employeDao.findAllWithDepartment());

        request.getRequestDispatcher("/WEB-INF/jsp/edit-department.jsp").forward(request, response);
    }

    private void createDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("departmentName");
        if (departmentDao.findByName(name).isPresent()) {
            request.setAttribute("error", "A department with this name already exists.");
            listDepartments(request, response);
        } else {
            Department newDepartment = new Department();
            newDepartment.setDepartmentName(name);
            departmentDao.save(newDepartment);
            response.sendRedirect(request.getContextPath() + "/departments");
        }
    }

    private void updateDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Department not found"));

        department.setDepartmentName(request.getParameter("departmentName"));

        String managerIdParam = request.getParameter("managerId");
        if (managerIdParam != null && !managerIdParam.isEmpty()) {
            department.setManager(employeDao.findById(Integer.parseInt(managerIdParam)).orElse(null));
        } else {
            department.setManager(null);
        }
        departmentDao.update(department);

        String[] employeeIdsFromForm = request.getParameterValues("employees");
        Set<Integer> newMemberIds = new HashSet<>();
        if (employeeIdsFromForm != null) {
            newMemberIds = Arrays.stream(employeeIdsFromForm).map(Integer::parseInt).collect(Collectors.toSet());
        }

        for (Employe currentMember : new HashSet<>(department.getEmployees())) {
            if (!newMemberIds.contains(currentMember.getId_employe())) {
                currentMember.setDepartment(null);
                employeDao.update(currentMember);
            }
        }

        for (Integer newMemberId : newMemberIds) {
            Employe employee = employeDao.findById(newMemberId).orElseThrow(() -> new ServletException("Employee not found"));
            if (department.getId_department() != (employee.getDepartment() != null ? employee.getDepartment().getId_department() : 0)) {
                employee.setDepartment(department);
                employeDao.update(employee);
            }
        }

        response.sendRedirect(request.getContextPath() + "/departments");
    }

    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        Department department = departmentDao.findByIdWithEmployees(id).orElseThrow(() -> new ServletException("Department not found"));

        for (Employe employee : department.getEmployees()) {
            employee.setDepartment(null);
            employeDao.update(employee);
        }

        departmentDao.delete(department);
        response.sendRedirect(request.getContextPath() + "/departments");
    }
}