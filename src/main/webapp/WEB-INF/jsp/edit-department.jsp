<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Department</title>
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

        input[type="text"], select {
            width: 100%;
            padding: 0.7rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            margin-top: 0.4rem;
            transition: all 0.3s ease;
            font-size: 1rem;
            box-sizing: border-box;
        }

        input[type="text"]:focus, select:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
        }

        .member-list {
            height: 180px;
            overflow-y: auto;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 0.7rem 1rem;
            background-color: #f9fbff;
        }

        .member-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .member-item label {
            font-size: 0.95rem;
        }

        .member-item i {
            color: #888;
            font-size: 0.85rem;
            margin-left: 0.3rem;
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
        <h1>Edit Department</h1>
    </div>
    <div class="nav-links">
        <a href="departments">Back to Departments</a>
        <a href="dashboard">Dashboard</a>
    </div>
</header>

<main>
    <h2>Editing: <c:out value="${department.departmentName}"/></h2>

    <form action="departments" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${department.id_department}">

        <fieldset>
            <legend>Department Details</legend>
            <label>Department Name:</label>
            <input type="text" name="departmentName" value="<c:out value='${department.departmentName}'/>" required>

            <label style="margin-top:1rem;">Manager:</label>
            <select name="managerId">
                <option value="">-- No Manager --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <option value="${emp.id_employe}"
                        <c:if test="${not empty department.manager && department.manager.id_employe == emp.id_employe}">selected</c:if>>
                        <c:out value="${emp.firstName} ${emp.lastName}"/>
                    </option>
                </c:forEach>
            </select>
        </fieldset>

        <fieldset>
            <legend>Assign Members</legend>
            <div class="member-list">
                <c:forEach var="employee" items="${allEmployees}">
                    <c:set var="isChecked" value=""/>
                    <c:if test="${not empty employee.department && employee.department.id_department == department.id_department}">
                        <c:set var="isChecked" value="checked"/>
                    </c:if>

                    <div class="member-item">
                        <input type="checkbox" name="employees" value="${employee.id_employe}"
                               id="emp-${employee.id_employe}" ${isChecked}
                               <c:if test="${not empty employee.department && employee.department.id_department != department.id_department}">disabled</c:if>>
                        <label for="emp-${employee.id_employe}">
                            <c:out value="${employee.firstName} ${employee.lastName}"/>
                            <c:if test="${not empty employee.department && employee.department.id_department != department.id_department}">
                                <i>(in <c:out value="${employee.department.departmentName}"/>)</i>
                            </c:if>
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
