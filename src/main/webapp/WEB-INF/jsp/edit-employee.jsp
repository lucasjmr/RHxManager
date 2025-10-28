<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Employee</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            color: #333;
        }

        header {
            background: linear-gradient(90deg, #0078ff 0%, #005fcc 100%);
            color: white;
            padding: 1.2rem 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .header-left h1 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 1rem;
            background: rgba(255, 255, 255, 0.25);
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.4);
        }

        main {
            max-width: 900px;
            margin: 2.5rem auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 2rem 3rem;
        }

        h2 {
            color: #0078ff;
            border-bottom: 2px solid #e0e6ed;
            padding-bottom: 0.4rem;
            margin-bottom: 1.5rem;
        }

        fieldset {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }

        legend {
            font-weight: 600;
            color: #0078ff;
        }

        input[type="text"],
        input[type="number"],
        input[type="password"] {
            width: 100%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-top: 0.4rem;
            transition: all 0.3s ease;
            font-size: 1rem;
            box-sizing: border-box;
        }

        input:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
        }

        .checkbox-list, .scroll-box {
            height: 180px;
            overflow-y: auto;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 0.7rem 1rem;
            background-color: #f9fbff;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        label {
            font-size: 0.95rem;
        }

        .btn {
            background: #0078ff;
            color: white;
            border: none;
            padding: 0.8rem 1.4rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .btn:hover {
            background: #005fcc;
        }

        .btn-cancel {
            background: #ccc;
            color: #333;
            margin-left: 1rem;
        }

        .btn-cancel:hover {
            background: #b3b3b3;
        }

        footer {
            text-align: center;
            padding: 1.5rem;
            font-size: 0.9rem;
            color: #777;
        }
    </style>
</head>
<body>

<header>
    <div class="header-left">
        <h1>Edit Employee</h1>
    </div>
    <div class="nav-links">
        <a href="employees">Back to Employees</a>
        <a href="dashboard">Dashboard</a>
    </div>
</header>

<main>
    <h2>Editing: <c:out value="${employee.firstName} ${employee.lastName}"/></h2>

    <form action="employees" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${employee.id_employe}">

        <fieldset>
            <legend>Personal Information</legend>
            <label>First Name:</label>
            <input type="text" name="firstName" value="<c:out value='${employee.firstName}'/>" required>

            <label>Last Name:</label>
            <input type="text" name="lastName" value="<c:out value='${employee.lastName}'/>" required>

            <label>Grade:</label>
            <input type="text" name="grade" value="<c:out value='${employee.grade}'/>">

            <label>Job Title:</label>
            <input type="text" name="jobName" value="<c:out value='${employee.jobName}'/>">

            <label>Salary:</label>
            <input type="number" name="salary" step="0.01" value="${employee.salary}" required>
        </fieldset>

        <fieldset>
            <legend>Account Information</legend>
            <p><strong>Username:</strong> <c:out value="${employee.username}"/> (cannot be changed)</p>
            <label>New Password:</label>
            <input type="password" name="password" placeholder="Leave blank to keep current password">
        </fieldset>

        <fieldset>
            <legend>Assign Roles</legend>
            <div class="checkbox-list">
                <c:forEach var="role" items="${allRoles}">
                    <div class="checkbox-item">
                        <input type="checkbox" name="roles" value="${role.id_role}"
                            <c:forEach var="userRole" items="${employee.roles}">
                                <c:if test="${userRole.id_role == role.id_role}">checked</c:if>
                            </c:forEach>>
                        <label><c:out value="${role.roleName}"/></label>
                    </div>
                </c:forEach>
            </div>
        </fieldset>

        <fieldset>
            <legend>Assign Projects</legend>
            <div class="scroll-box">
                <c:forEach var="project" items="${allProjects}">
                    <c:set var="isChecked" value=""/>
                    <c:forEach var="assignedProject" items="${employee.projects}">
                        <c:if test="${assignedProject.id_project == project.id_project}">
                            <c:set var="isChecked" value="checked"/>
                        </c:if>
                    </c:forEach>
                    <div class="checkbox-item">
                        <input type="checkbox" name="projects" value="${project.id_project}" id="proj-${project.id_project}" ${isChecked}>
                        <label for="proj-${project.id_project}">
                            <c:out value="${project.projectName}"/>
                        </label>
                    </div>
                </c:forEach>
            </div>
        </fieldset>

        <button type="submit" class="btn">Save Changes</button>

    </form>
</main>

<footer>
    © 2025 RHxManager — All rights reserved
</footer>

</body>
</html>
