<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee Management</title>
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
        input[type="number"],
        input[type="password"] {
            width: 90%;
            padding: 0.6rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-bottom: 0.8rem;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        input:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
        }

        /* === BOUTONS UNIFORMES === */
        button,
        .action-btn,
        .delete-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 100px;
            height: 42px;
            border: none;
            border-radius: 6px;
            font-size: 0.95rem;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        /* Boutons bleus (Search, Clear, Edit, Create) */
        button,
        .action-btn {
            background: #0078ff;
            color: white;
        }

        button:hover,
        .action-btn:hover {
            background: #005fcc;
        }

        /* Boutons rouges (Delete, Logout) */
        .delete-btn {
            background: red;
            color: white;
        }

        .delete-btn:hover {
            background: #b81414;
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

        .success {
            color: green;
            font-weight: 500;
        }

        .error {
            color: red;
            font-weight: 500;
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
        <h1>Manage Employees</h1>
    </div>
    <div class="nav-links">
        <a href="dashboard" class="back-btn">Dashboard</a>
        <a class="logout-btn" href="logout">Logout</a>
    </div>
</header>

<main>
    <section>
        <h2>Search Employees</h2>
        <form action="employees" method="post" style="display:flex; gap:0.5rem; align-items:stretch;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Enter name, ID, job..." value="${searchKeyword}" style="flex:1;">
            <button type="submit">Search</button>
            <a href="employees" class="action-btn">Clear</a>
        </form>
    </section>

    <section>
        <h2>Add New Employee</h2>
        <c:if test="${param.success == 'create'}"><p class="success">Employee created successfully!</p></c:if>
        <c:if test="${param.success == 'update'}"><p class="success">Employee updated successfully!</p></c:if>
        <c:if test="${param.success == 'delete'}"><p class="success">Employee deleted successfully!</p></c:if>
        <c:if test="${not empty error}"><p class="error"><c:out value="${error}"/></p></c:if>

        <form action="employees" method="post">
            <input type="hidden" name="action" value="create">

            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:1rem;">
                <div>
                    <label>First Name:</label>
                    <input type="text" name="firstName" required>

                    <label>Grade:</label>
                    <input type="text" name="grade">

                    <label>Username:</label>
                    <input type="text" name="username" required>
                </div>

                <div>
                    <label>Last Name:</label>
                    <input type="text" name="lastName" required>

                    <label>Job Title:</label>
                    <input type="text" name="jobName">

                    <label>Password:</label>
                    <input type="password" name="password" required>
                </div>
            </div>

            <label>Salary:</label><br/>
            <input type="number" name="salary" step="0.01" required style="width:95%;">

            <button type="submit" style="margin-top:1rem;">Create Employee</button>
        </form>
    </section>

    <section>
        <h2>Employee List</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Job Title</th>
                    <th>Roles</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="employee" items="${employees}">
                    <tr>
                        <td>${employee.id_employe}</td>
                        <td><c:out value="${employee.firstName} ${employee.lastName}"/></td>
                        <td><c:out value="${employee.username}"/></td>
                        <td><c:out value="${employee.jobName}"/></td>
                        <td>
                            <c:forEach var="role" items="${employee.roles}" varStatus="loop">
                                <c:out value="${role.roleName}"/><c:if test="${not loop.last}">, </c:if>
                            </c:forEach>
                        </td>
                        <td>
                            <a href="employees?action=edit&id=${employee.id_employe}" class="action-btn">Edit</a>
                            <form action="employees" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this employee?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${employee.id_employe}">
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
