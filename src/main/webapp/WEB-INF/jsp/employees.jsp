<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee Management</title>
</head>
<body>
    <a href="dashboard">Back to Dashboard</a> | <a href="logout">Logout</a>
    <hr/>
    <h1>Manage Employees</h1>

    <h2>Search Employees</h2>
    <form action="employees" method="post">
        <input type="hidden" name="action" value="search">
        <input type="text" name="keyword" placeholder="Enter name, ID, job..." value="${searchKeyword}" size="30">
        <button type="submit">Search</button>
        <a href="employees">Clear Search</a>
    </form>
    <hr/>

    <h2>Add New Employee</h2>
    <c:if test="${param.success == 'create'}">
        <p style="color:green;">Employee created successfully!</p>
    </c:if>
    <c:if test="${param.success == 'update'}">
        <p style="color:green;">Employee updated successfully!</p>
    </c:if>
    <c:if test="${param.success == 'delete'}">
        <p style="color:green;">Employee deleted successfully!</p>
    </c:if>
    <c:if test="${not empty error}">
        <p style="color:red;"><c:out value="${error}"/></p>
    </c:if>

    <form action="employees" method="post">
        <input type="hidden" name="action" value="create">

        <table cellpadding="5">
            <tr>
                <td><label for="firstName">First Name:</label></td>
                <td><input type="text" id="firstName" name="firstName" required></td>
            </tr>
            <tr>
                <td><label for="lastName">Last Name:</label></td>
                <td><input type="text" id="lastName" name="lastName" required></td>
            </tr>
             <tr>
                <td><label for="grade">Grade:</label></td>
                <td><input type="text" id="grade" name="grade"></td>
            </tr>
            <tr>
                <td><label for="jobName">Job Title:</label></td>
                <td><input type="text" id="jobName" name="jobName"></td>
            </tr>
            <tr>
                <td><label for="salary">Salary:</label></td>
                <td><input type="number" id="salary" name="salary" step="0.01" required></td>
            </tr>
            <tr>
                <td><label for="username">Username:</label></td>
                <td><input type="text" id="username" name="username" required></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" id="password" name="password" required></td>
            </tr>
            <tr>
                <td colspan="2"><button type="submit">Create Employee</button></td>
            </tr>
        </table>
    </form>
    <hr/>

    <h2>Employee List</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Username</th>
                <th>Job Title</th>
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
                        <a href="employees?action=edit&id=${employee.id_employe}">Edit</a>

                        <form action="employees" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this employee?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${employee.id_employe}">
                            <button type="submit">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>