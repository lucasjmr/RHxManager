<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payslip Management</title>
</head>
<body>
    <a href="dashboard">Back to Dashboard</a> | <a href="logout">Logout</a>
    <hr/>
    <h1>Manage Payslips</h1>

    <fieldset>
        <legend>Filter Payslips</legend>
        <form action="payslips" method="get">
            Employee:
            <select name="employeeId">
                <option value="0">-- All Employees --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <%-- L'attribut 'selected' est ajouté si l'ID de l'employé correspond à celui du filtre précédent --%>
                    <option value="${emp.id_employe}" ${emp.id_employe == selectedEmployeeId ? 'selected' : ''}>
                        <c:out value="${emp.firstName} ${emp.lastName}"/>
                    </option>
                </c:forEach>
            </select>

            Month:
            <select name="month">
                <option value="0">-- All Months --</option>
                <c:forEach var="i" begin="1" end="12">
                    <option value="${i}" ${i == selectedMonth ? 'selected' : ''}>${i}</option>
                </c:forEach>
            </select>

            Year:
            <input type="number" name="year" placeholder="Any year" value="${selectedYear > 0 ? selectedYear : ''}">

            <button type="submit">Filter</button>
            <a href="payslips">Clear Filter</a>
        </form>
    </fieldset>
    <br/>

    <fieldset>
        <legend>Generate New Payslip</legend>
        <c:if test="${not empty error}"><p style="color:red;"><c:out value="${error}"/></p></c:if>
        <form action="payslips" method="post">
            Employee:
            <select name="employeeId" required>
                <option value="" disabled selected>-- Select an Employee --</option>
                <c:forEach var="emp" items="${allEmployees}">
                    <option value="${emp.id_employe}"><c:out value="${emp.firstName} ${emp.lastName}"/></option>
                </c:forEach>
            </select>

            Month:
            <select name="month">
                <c:forEach var="i" begin="1" end="12">
                    <option value="${i}">${i}</option>
                </c:forEach>
            </select>

            Year:
            <input type="number" name="year" value="2024" min="2000" max="2100" required>

            <button type="submit">Generate</button>
        </form>
    </fieldset>
    <hr/>

    <h2>Payslip List</h2>
    <table border="1" cellpadding="5" cellspacing="0">
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
                            <td><a href="payslips?action=view&id=${p.id_payslip}">View / Print</a></td>
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
</body>
</html>