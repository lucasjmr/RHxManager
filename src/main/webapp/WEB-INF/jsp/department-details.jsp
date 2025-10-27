<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Department Details</title>
</head>
<body>
    <a href="departments">Back to Department List</a> | <a href="dashboard">Dashboard</a>
    <hr/>
    <h1>Details for: <c:out value="${department.departmentName}"/></h1>

    <p>
        <b>Current Manager:</b>
        <c:if test="${not empty department.manager}">
            <c:out value="${department.manager.firstName} ${department.manager.lastName}"/>
        </c:if>
        <c:if test="${empty department.manager}">N/A</c:if>
    </p>
    <hr/>

    <fieldset>
        <legend>Assign/Change Manager</legend>
        <form action="departments" method="post">
            <input type="hidden" name="action" value="assignChief">
            <input type="hidden" name="departmentId" value="${department.id_department}">
            <select name="managerId">
                <option value="">-- No Manager --</option>
                <c:forEach var="emp" items="${availableEmployees}"> <%-- Note: on peut réutiliser cette liste ou passer allEmployees --%>
                    <option value="${emp.id_employe}"
                        <c:if test="${not empty department.manager && department.manager.id_employe == emp.id_employe}">selected</c:if>>
                        <c:out value="${emp.firstName} ${emp.lastName}"/>
                    </option>
                </c:forEach>
            </select>
            <button type="submit">Set as Manager</button>
        </form>
    </fieldset>
    <br/>

    <fieldset>
        <legend>Assign an Employee</legend>
        <form action="departments" method="post">
            <input type="hidden" name="action" value="assignEmployee">
            <input type="hidden" name="departmentId" value="${department.id_department}">

            <select name="employeeId">
                <c:forEach var="emp" items="${availableEmployees}">
                    <option value="${emp.id_employe}">
                        <c:out value="${emp.firstName} ${emp.lastName} (ID: ${emp.id_employe})"/>
                    </option>
                </c:forEach>
            </select>
            <button type="submit" <c:if test="${empty availableEmployees}">disabled</c:if>>Assign to Department</button>
            <c:if test="${empty availableEmployees}"><p>No employees available to assign.</p></c:if>
        </form>
    </fieldset>
    <br/>

    <fieldset>
        <legend>Current Members (${department.employees.size()})</legend>
        <table border="1" style="width:100%">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Job Title</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="member" items="${department.employees}">
                    <tr>
                        <td>${member.id_employe}</td>
                        <td><c:out value="${member.firstName} ${member.lastName}"/></td>
                        <td><c:out value="${member.jobName}"/></td>
                        <td>
                            <form action="departments" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="removeEmployee">
                                <input type="hidden" name="departmentId" value="${department.id_department}">
                                <input type="hidden" name="employeeId" value="${member.id_employe}">
                                <button type="submit">Remove from Department</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty department.employees}">
                    <tr><td colspan="4">This department has no members.</td></tr>
                </c:if>
            </tbody>
        </table>
    </fieldset>
</body>
</html>