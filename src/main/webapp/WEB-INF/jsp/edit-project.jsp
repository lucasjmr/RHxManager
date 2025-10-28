<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Project</title>
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

        .back-btn {
            color: white;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.25);
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: background 0.3s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.4);
        }

        .logout-btn {
            background: red;
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: #b81414;
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
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }

        legend {
            font-weight: 600;
            color: #0078ff;
        }

        input[type="text"]{
            width: 97%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-top: 0.5rem;
            margin-bottom: 1rem;
            transition: border 0.3s ease;
            font-size: 1rem;
        }
        select {
            width: 100%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-top: 0.5rem;
            margin-bottom: 1rem;
            transition: border 0.3s ease;
            font-size: 1rem;

        }

        input:focus,
        select:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
        }

        .checkbox-list {
            height: 150px;
            overflow-y: auto;
            border: 1px solid #ccc;
            border-radius: 6px;
            padding: 10px;
        }

        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.4rem;
        }

        button {
            background: #0078ff;
            color: white;
            border: none;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.3s ease;
        }

        button:hover {
            background: #005fcc;
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
        <h1>Edit Project</h1>
    </div>
    <div>
        <a href="projects" class="back-btn">Back to projects</a>
        <a href="logout" class="logout-btn">Logout</a>
    </div>
</header>

<main>
    <h2>Editing Project: <c:out value="${project.projectName}" /></h2>

    <form action="projects" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${project.id_project}">

        <fieldset>
            <legend>Project Details</legend>
            <label>Project Name:</label>
            <input type="text" name="projectName" value="<c:out value='${project.projectName}'/>" required>

            <label>Project State:</label>
            <select name="state">
                <c:forEach var="s" items="${allStates}">
                    <option value="${s}" <c:if test="${project.state == s}">selected</c:if>>${s}</option>
                </c:forEach>
            </select>
        </fieldset>

        <fieldset>
            <legend>Project Lead</legend>
            <select name="projectLeadId">
                <option value="">-- No Lead Assigned --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <option value="${emp.id_employe}" <c:if test="${not empty project.projectLead && project.projectLead.id_employe == emp.id_employe}">selected</c:if>>
                        <c:out value="${emp.firstName} ${emp.lastName}"/>
                    </option>
                </c:forEach>
            </select>
        </fieldset>

        <fieldset>
            <legend>Assign Employees</legend>
            <div class="checkbox-list">
                <c:forEach var="employee" items="${allEmployees}">
                    <c:set var="isChecked" value=""/>
                    <c:forEach var="assignedEmployee" items="${project.employees}">
                        <c:if test="${assignedEmployee.id_employe == employee.id_employe}">
                            <c:set var="isChecked" value="checked"/>
                        </c:if>
                    </c:forEach>

                    <div class="checkbox-item">
                        <input type="checkbox" name="employees" value="${employee.id_employe}" id="emp-${employee.id_employe}" ${isChecked}>
                        <label for="emp-${employee.id_employe}">
                            <c:out value="${employee.firstName} ${employee.lastName}"/>
                        </label>
                    </div>
                </c:forEach>
            </div>
        </fieldset>

        <button type="submit">Save Changes</button>
    </form>
</main>

<footer>
    © 2025 RHxManager — All rights reserved
</footer>

</body>
</html>
