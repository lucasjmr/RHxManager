package com.rhxmanager.servlets;

import com.rhxmanager.dao.EmployeDao;
import com.rhxmanager.dao.ProjectDao;
import com.rhxmanager.model.Employe;
import com.rhxmanager.model.Project;
import com.rhxmanager.model.ProjectState;

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

@WebServlet("/projects")
public class ProjectServlet extends HttpServlet {

    private final ProjectDao projectDao = new ProjectDao();
    private final EmployeDao employeDao = new EmployeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            showEditForm(request, response);
        } else {
            listProjects(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "create":
                createProject(request, response);
                break;
            case "update":
                updateProject(request, response);
                break;
            case "delete":
                deleteProject(request, response);
                break;
            default:
                listProjects(request, response);
                break;
        }
    }

    private void listProjects(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("projects", projectDao.findAllWithEmployees());
        request.setAttribute("allStates", ProjectState.values());
        request.getRequestDispatcher("/WEB-INF/jsp/projects.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        com.rhxmanager.model.Project project = projectDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Project not found"));

        request.setAttribute("project", project);
        request.setAttribute("allEmployees", employeDao.findAll());
        request.setAttribute("allStates", ProjectState.values());

        request.getRequestDispatcher("/WEB-INF/jsp/edit-project.jsp").forward(request, response);
    }

    private void createProject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        com.rhxmanager.model.Project project = new com.rhxmanager.model.Project();
        project.setProjectName(request.getParameter("projectName"));
        project.setState(ProjectState.valueOf(request.getParameter("state")));
        projectDao.save(project);
        response.sendRedirect(request.getContextPath() + "/projects");
    }

    private void updateProject(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        Project project = projectDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Project not found"));

        project.setProjectName(request.getParameter("projectName"));
        project.setState(ProjectState.valueOf(request.getParameter("state")));

        String chiefIdParam = request.getParameter("projectLeadId");
        if (chiefIdParam != null && !chiefIdParam.isEmpty()) {
            int chiefId = Integer.parseInt(chiefIdParam);
            Employe projectLead = employeDao.findById(chiefId)
                    .orElseThrow(() -> new ServletException("Project lead not found"));
            project.setProjectLead(projectLead);
        } else {
            project.setProjectLead(null);
        }

        String[] employeeIdsFromForm = request.getParameterValues("employees");
        Set<Integer> newEmployeeIds = new HashSet<>();
        if (employeeIdsFromForm != null) {
            newEmployeeIds = Arrays.stream(employeeIdsFromForm)
                    .map(Integer::parseInt)
                    .collect(Collectors.toSet());
        }

        Set<Employe> currentEmployees = new HashSet<>(project.getEmployees());

        for (Employe currentEmployee : currentEmployees) {
            if (!newEmployeeIds.contains(currentEmployee.getId_employe())) {
                Employe employeeToRemove = employeDao.findByIdWithProjects(currentEmployee.getId_employe())
                        .orElseThrow(() -> new ServletException("Employee to remove not found"));
                project.removeEmployee(employeeToRemove);
                employeDao.update(employeeToRemove);
            }
        }

        for (Integer newEmployeeId : newEmployeeIds) {
            boolean alreadyAssigned = project.getEmployees().stream()
                    .anyMatch(e -> e.getId_employe() == newEmployeeId);
            if (!alreadyAssigned) {
                Employe employeeToAdd = employeDao.findByIdWithProjects(newEmployeeId)
                        .orElseThrow(() -> new ServletException("Employee to assign not found"));
                project.addEmployee(employeeToAdd);
            }
        }

        projectDao.update(project);

        response.sendRedirect(request.getContextPath() + "/projects?action=edit&id=" + id);
    }

    private void deleteProject(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));

        Project project = projectDao.findByIdWithEmployees(id)
                .orElseThrow(() -> new ServletException("Project not found"));

        for (Employe employee : new HashSet<>(project.getEmployees())) {
            project.removeEmployee(employee);
            employeDao.update(employee);
        }

        projectDao.delete(project);

        response.sendRedirect(request.getContextPath() + "/projects");
    }
}