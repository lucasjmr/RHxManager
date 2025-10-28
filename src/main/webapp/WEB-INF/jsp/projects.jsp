<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Project Management</title>
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
            margin-left: 1rem;
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
            margin-left: 1rem;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: #b81414;
        }

        main {
            max-width: 1000px;
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

        input[type="text"],
        select {
            width: 48%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-right: 1rem;
            transition: all 0.3s ease;
            font-size: 1rem;
            box-sizing: border-box;
        }

        input:focus, select:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        th {
            background: #0078ff;
            color: white;
            text-align: left;
            padding: 0.8rem;
            font-weight: 500;
        }

        td {
            padding: 0.8rem;
            border-bottom: 1px solid #eee;
        }

        tr:hover {
            background: #f9fbff;
        }

        .action-btn,
        .delete-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 100px;
            height: 35px;
            box-sizing: border-box;
            font-family: "Segoe UI", sans-serif;
            font-size: 0.9rem;
            font-weight: 500;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s ease;
            padding: 0;
        }


        .action-btn {
            background: #0078ff;
            color: white;
        }

        .action-btn:hover {
            background: #005fcc;
        }

        .delete-btn {
            background: red;
            color: white;
            border: none;
            cursor: pointer;
        }

        .delete-btn:hover {
            background: #b81414;
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
        <h1>Manage Projects</h1>
    </div>
    <div class="nav-links">
        <a href="dashboard" class="back-btn">Dashboard</a>
        <a href="logout" class="logout-btn">Logout</a>
    </div>
</header>

<main>

    <section>
        <h2>Add New Project</h2>
        <form action="projects" method="post" style="display:flex; gap:0.5rem; align-items:center;">
            <input type="hidden" name="action" value="create">
            <input type="text" name="projectName" placeholder="Project name..." required>
            <select name="state">
                <c:forEach var="state" items="${allStates}">
                    <option value="${state}">${state}</option>
                </c:forEach>
            </select>
            <button type="submit">Create</button>
        </form>
    </section>

    <section>
        <h2>Project List</h2>
        <table>
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
                            <a href="projects?action=edit&id=${project.id_project}" class="action-btn">Edit</a>
                            <form action="projects" method="post" style="display:inline;" onsubmit="return confirm('Delete this project?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${project.id_project}">
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </section>

</main>

<footer>
    © 2025 RHxManager — All rights reserved
</footer>

</body>
</html>
