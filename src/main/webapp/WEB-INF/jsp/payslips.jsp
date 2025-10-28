<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payslip Management</title>
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

        fieldset {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            background: #f9fbff;
        }

        legend {
            font-weight: 600;
            color: #0078ff;
            padding: 0 0.5rem;
        }

        label {
            font-weight: 500;
            margin-right: 0.5rem;
        }

        select,
        input[type="number"],
        input[type="text"] {
            width: 180px;
            padding: 0.6rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        select:focus,
        input:focus {
            border-color: #0078ff;
            box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
            outline: none;
        }

        button,
        a.action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            min-width: 100px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background 0.3s ease;
            box-sizing: border-box;
        }

        button {
            background: #0078ff;
            color: white;
        }

        button:hover {
            background: #005fcc;
        }

        a.action-btn {
            background: #ccc;
            color: #333;
        }

        a.action-btn:hover {
            background: #b3b3b3;
        }

        form {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.8rem;
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

        .view-btn {
            background: #0078ff;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: background 0.3s ease;
        }

        .view-btn:hover {
            background: #005fcc;
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
        form {
            display: flex;
            flex-wrap: nowrap;
            align-items: center;
            gap: 0.8rem;
            flex-wrap: nowrap;
        }

        form label {
            white-space: nowrap;
        }

        form select,
        form input[type="number"],
        form input[type="text"] {
            flex: 0 0 auto;
        }

        form button,
        form a.action-btn {
            flex: 0 0 auto;
        }

    </style>
</head>

<body>

<header>
    <div class="header-left">
        <h1>Manage Payslips</h1>
    </div>
    <div class="nav-links">
        <a href="dashboard" class="back-btn">Dashboard</a>
        <a href="logout" class="logout-btn">Logout</a>
    </div>
</header>

<main>

    <section>
        <h2>Filter Payslips</h2>
        <form action="payslips" method="get">
            <label>Employee:</label>
            <select name="employeeId">
                <option value="0">-- All Employees --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <option value="${emp.id_employe}" ${emp.id_employe == selectedEmployeeId ? 'selected' : ''}>
                        <c:out value="${emp.firstName} ${emp.lastName}"/>
                    </option>
                </c:forEach>
            </select>

            <label>Month:</label>
            <select name="month">
                <option value="0">-- All Months --</option>
                <c:forEach var="i" begin="1" end="12">
                    <option value="${i}" ${i == selectedMonth ? 'selected' : ''}>${i}</option>
                </c:forEach>
            </select>

            <label>Year:</label>
            <input type="number" name="year" placeholder="Year" value="${selectedYear > 0 ? selectedYear : ''}">

            <button type="submit">Filter</button>
            <a href="payslips" class="action-btn">Clear</a>
        </form>
    </section>

    <section>
        <h2>Generate New Payslip</h2>
        <c:if test="${not empty error}">
            <p class="error"><c:out value="${error}"/></p>
        </c:if>
        <form action="payslips" method="post">
            <label>Employee:</label>
            <select name="employeeId" required>
                <option value="" disabled selected>-- Select Employee --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <option value="${emp.id_employe}"><c:out value="${emp.firstName} ${emp.lastName}"/></option>
                </c:forEach>
            </select>

            <label>Month:</label>
            <select name="month">
                <c:forEach var="i" begin="1" end="12">
                    <option value="${i}">${i}</option>
                </c:forEach>
            </select>

            <label>Year:</label>
            <input type="number" name="year" value="2024" min="2000" max="2100" required>

            <button type="submit">Generate</button>
        </form>
    </section>

    <section>
        <h2>Payslip List</h2>
        <table>
            <thead>
                <tr>
                    <th>Period (M/Y)</th>
                    <th>Employee</th>
                    <th>Net to Pay (€)</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty payslips}">
                        <c:forEach var="p" items="${payslips}">
                            <tr>
                                <td>${p.month}/${p.year}</td>
                                <td><c:out value="${p.employe.firstName} ${p.employe.lastName}"/></td>
                                <td><c:out value="${String.format('%.2f', p.net)}"/></td>
                                <td><a href="payslips?action=view&id=${p.id_payslip}" class="view-btn">View / Print</a></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4">No payslips found matching the criteria.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </section>

</main>

<footer>
    © 2025 RHxManager — All rights reserved
</footer>

</body>
</html>
