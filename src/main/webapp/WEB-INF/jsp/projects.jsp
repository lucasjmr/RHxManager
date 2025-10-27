<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Project Management</title>
</head>
<body>
    <a href="dashboard">Back to Dashboard</a> | <a href="logout">Logout</a>
    <hr/>
    <h1>Manage Projects</h1>

    <h2>Add New Project</h2>
    <form action="projects" method="post">
        <input type="hidden" name="action" value="create">
        Project Name: <input type="text" name="projectName" required>
        Initial State:
        <select name="state">
            <c:forEach var="state" items="${allStates}">
                 <option value="${state}">${state}</option>
            </c:forEach>
        </select>
        <button type="submit">Create Project</button>
    </form>
    <hr/>

    <h2>Project List</h2>
    <table border="1" cellpadding="5">
        <thead>
            <tr>
                <th>ID</th>
                <th>Project Name</th>
                <th>State</th>
                <th>Project Lead</th>
                <th>Assigned Employees</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="project" items="${projects}">
                <tr>
                    <td>${project.id_project}</td>
                    <td><c:out value="${project.projectName}"/></td>
                    <td>${project.state}</td>
                    <td>
                        <c:if test="${not empty project.projectLead}">
                            <c:out value="${project.projectLead.firstName} ${project.projectLead.lastName}"/>
                        </c:if>
                        <c:if test="${empty project.projectLead}">N/A</c:if>
                    </td>
                    <td>${project.employees.size()}</td>
                    <td>
                        <a href="projects?action=edit&id=${project.id_project}">Edit / Assign</a>
                        <form action="projects" method="post" style="display:inline;" onsubmit="return confirm('Delete this project?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${project.id_project}">
                            <button type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>