<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Department Management</title>
</head>
<body>
    <a href="dashboard">Back to Dashboard</a> | <a href="logout">Logout</a>
    <hr/>
    <h1>Manage Departments</h1>

    <h2>Add New Department</h2>
    <c:if test="${not empty error}"><p style="color:red;"><c:out value="${error}"/></p></c:if>
    <c:if test="${not empty success}"><p style="color:green;"><c:out value="${success}"/></p></c:if>
    <form action="departments" method="post">
        <input type="hidden" name="action" value="create">
        <input type="text" name="departmentName" placeholder="New department name" required>
        <button type="submit">Create Department</button>
    </form>
    <hr/>

    <h2>Department List</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Department Name</th>
                <th>Member Count</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="department" items="${departments}">
                <tr>
                    <td>${department.id_department}</td>
                    <td><c:out value="${department.departmentName}"/></td>
                    <td>${department.employees.size()}</td>
                    <td>
                        <a href="departments?action=view&id=${department.id_department}">View Members / Assign</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>