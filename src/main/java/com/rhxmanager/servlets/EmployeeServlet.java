package com.rhxmanager.servlets;

import com.rhxmanager.dao.DepartmentDao;
import com.rhxmanager.dao.EmployeDao;
import com.rhxmanager.dao.ProjectDao;
import com.rhxmanager.dao.RoleDao;
import com.rhxmanager.model.Department;
import com.rhxmanager.model.Employe;
import com.rhxmanager.model.Project;
import com.rhxmanager.model.Role;
import com.rhxmanager.util.PasswordUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    private final EmployeDao employeDao = new EmployeDao();
    private final RoleDao roleDao = new RoleDao();
    private final ProjectDao projectDao = new ProjectDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else {
            listEmployees(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                createEmployee(request, response);
                break;
            case "update":
                updateEmployee(request, response);
                break;
            case "delete":
                deleteEmployee(request, response);
                break;
            case "search":
                searchEmployees(request, response);
                break;
            default:
                listEmployees(request, response);
                break;
        }
    }

    private void listEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("employees", employeDao.findAllWithRoles());
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/employees.jsp");
        dispatcher.forward(request, response);
    }

    private void searchEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("employees", employeDao.search(keyword));
        request.setAttribute("searchKeyword", keyword);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/employees.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employe employee = employeDao.findForEdit(id).orElseThrow(() -> new ServletException("Employee not found"));

        request.setAttribute("employee", employee);
        request.setAttribute("allRoles", roleDao.findAll());
        request.setAttribute("allProjects", projectDao.findAll());

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/edit-employee.jsp");
        dispatcher.forward(request, response);
    }

    private void createEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");

        if (employeDao.findByUsername(username).isPresent()) {
            request.setAttribute("error", "Username '" + username + "' is already taken.");
            listEmployees(request, response);
            return;
        }

        Employe newEmployee = new Employe();
        newEmployee.setFirstName(request.getParameter("firstName"));
        newEmployee.setLastName(request.getParameter("lastName"));
        newEmployee.setUsername(username);
        newEmployee.setGrade(request.getParameter("grade"));
        newEmployee.setJobName(request.getParameter("jobName"));
        newEmployee.setSalary(Double.parseDouble(request.getParameter("salary")));

        String password = request.getParameter("password");
        newEmployee.setPassword(PasswordUtil.hashPassword(password));

        Role defaultRole = roleDao.findByName("EMPLOYE")
                .orElseThrow(() -> new ServletException("Default role 'EMPLOYE' not found. Please initialize it in the database."));

        Set<Role> roles = new HashSet<>();
        roles.add(defaultRole);
        newEmployee.setRoles(roles);

        employeDao.save(newEmployee);

        response.sendRedirect(request.getContextPath() + "/employees?success=create");
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        Employe employee = employeDao.findById(id).orElseThrow(() -> new ServletException("Employee not found"));

        employee.setFirstName(request.getParameter("firstName"));
        employee.setLastName(request.getParameter("lastName"));
        employee.setGrade(request.getParameter("grade"));
        employee.setJobName(request.getParameter("jobName"));
        employee.setSalary(Double.parseDouble(request.getParameter("salary")));
        // todo : other fields

        String newPassword = request.getParameter("password");
        if (newPassword != null && !newPassword.isEmpty()) {
            employee.setPassword(PasswordUtil.hashPassword(newPassword));
        }

        String[] roleIds = request.getParameterValues("roles");
        Set<Role> assignedRoles = new HashSet<>();
        if (roleIds != null) {
            for (String roleId : roleIds) {
                roleDao.findById(Integer.parseInt(roleId)).ifPresent(assignedRoles::add);
            }
        }
        employee.setRoles(assignedRoles);

        String[] projectIds = request.getParameterValues("projects");
        Set<Project> assignedProjects = new HashSet<>();
        if (projectIds != null) {
            for (String projectId : projectIds) {
                projectDao.findById(Integer.parseInt(projectId)).ifPresent(assignedProjects::add);
            }
        }
        employee.setProjects(assignedProjects);

        employeDao.update(employee);
        response.sendRedirect(request.getContextPath() + "/employees?success=update");
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));

        Employe employeeToDelete = employeDao.findById(id)
                .orElseThrow(() -> new ServletException("Employee not found"));

        ProjectDao projectDao = new ProjectDao();
        DepartmentDao departmentDao = new DepartmentDao();

        List<Project> ledProjects = projectDao.findProjectsLedBy(employeeToDelete);
        for (Project project : ledProjects) {
            project.setProjectLead(null);
            projectDao.update(project);
        }

        List<Department> managedDepartments = departmentDao.findDepartmentsManagedBy(employeeToDelete);
        for (Department department : managedDepartments) {
            department.setManager(null);
            departmentDao.update(department);
        }

        Employe loggedInUser = (Employe) request.getSession().getAttribute("user");
        if (loggedInUser != null && loggedInUser.getId_employe() == id) {
            request.getSession().invalidate();
        }

        employeDao.delete(employeeToDelete);

        if (loggedInUser != null && loggedInUser.getId_employe() == id) {
            response.sendRedirect(request.getContextPath() + "/auth");
        } else {
            response.sendRedirect(request.getContextPath() + "/employees?success=delete");
        }
    }
}