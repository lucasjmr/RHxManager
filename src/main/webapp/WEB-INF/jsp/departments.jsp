<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Department Management</title>
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


        form {
            margin-bottom: 2rem;
        }

        input[type="text"] {
            width: 60%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus {
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

        .action-btn {
            background: #0078ff;
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background 0.3s ease;
        }

        .action-btn:hover {
            background: #005fcc;
        }

        .delete-btn {
            background: red;

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
        <h1>Department Management</h1>
    </div>
    <div class="nav-links">
        <a href="dashboard" class="back-btn">Back to Dashboard</a>
        <a href="logout" class="logout-btn">Logout</a>
    </div>
</header>

<main>
    <section>
        <h2>Add New Department</h2>
        <c:if test="${not empty error}">
            <p style="color:red;"><c:out value="${error}"/></p>
        </c:if>

        <form action="departments" method="post">
            <input type="hidden" name="action" value="create">
            <input type="text" name="departmentName" placeholder="New department name" required>
            <button type="submit">Create Department</button>
        </form>
    </section>

    <section>
        <h2>Department List</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Department Name</th>
                    <th>Manager</th>
                    <th>Member Count</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="department" items="${departments}">
                    <tr>
                        <td>${department.id_department}</td>
                        <td><c:out value="${department.departmentName}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty department.manager}">
                                    <c:out value="${department.manager.firstName} ${department.manager.lastName}"/>
                                </c:when>
                                <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${department.employees.size()}</td>
                        <td>
                            <a href="departments?action=edit&id=${department.id_department}" class="action-btn">Edit</a>
                            <form action="departments" method="post" style="display:inline;"
                                  onsubmit="return confirm('Delete this department? All members will be unassigned.');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${department.id_department}">
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
