<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Department</title>
</head>
<body>
    <a href="departments">Back to Department List</a> | <a href="dashboard">Dashboard</a>
    <hr/>
    <h1>Editing: <c:out value="${department.departmentName}"/></h1>

    <form action="departments" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="${department.id_department}">

        <fieldset>
            <legend>Department Details</legend>
            Department Name:<br/>
            <input type="text" name="departmentName" value="<c:out value="${department.departmentName}"/>" required><br/><br/>
            Manager:<br/>
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
        <br/>

        <fieldset>
            <legend>Assign Members</legend>
            <div style="height: 150px; overflow-y: scroll; border: 1px solid #ccc; padding: 5px;">
                <c:forEach var="employee" items="${allEmployees}">
                    <%-- Un employé ne peut être que dans un département. On coche s'il est dans CE département. --%>
                    <c:set var="isChecked" value=""/>
                    <c:if test="${not empty employee.department && employee.department.id_department == department.id_department}">
                        <c:set var="isChecked" value="checked"/>
                    </c:if>

                    <input type="checkbox" name="employees" value="${employee.id_employe}" id="emp-${employee.id_employe}" ${isChecked}
                        <%-- On désactive la checkbox si l'employé est déjà dans un AUTRE département --%>
                        <c:if test="${not empty employee.department && employee.department.id_department != department.id_department}">disabled</c:if>
                    >
                    <label for="emp-${employee.id_employe}">
                        <c:out value="${employee.firstName} ${employee.lastName}"/>
                        <c:if test="${not empty employee.department && employee.department.id_department != department.id_department}">
                            <i>(in <c:out value="${employee.department.departmentName}"/>)</i>
                        </c:if>
                    </label>
                    <br/>
                </c:forEach>
            </div>
        </fieldset>
        <br/>
        <button type="submit">Save Changes</button>
    </form>
</body>
</html>