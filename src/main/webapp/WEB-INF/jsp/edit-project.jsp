<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Edit Project</title>
        </head>

        <body>
            <a href="projects">Back to Project List</a> | <a href="dashboard">Dashboard</a>
            <hr />
            <h1>Editing Project:
                <c:out value="${project.projectName}" />
            </h1>

            <form action="projects" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${project.id_project}">

                <fieldset>
                    <legend>Project Details</legend>
                    Project Name: <br />
                    <input type="text" name="projectName" value="<c:out value="${project.projectName}" />"
                    required><br />
                    Project State: <br />
                    <select name="state">
                        <c:forEach var="s" items="${allStates}">
                            <option value="${s}" <c:if test="${project.state == s}">selected</c:if>>${s}</option>
                        </c:forEach>
                    </select>
                </fieldset>
                <br />

                <fieldset>
                    <legend>Project Lead</legend>
                    <select name="projectLeadId">
                        <option value="">-- No Lead Assigned --</option>
                        <c:forEach var="emp" items="${allEmployees}">
                            <option value="${emp.id_employe}"
                                <c:if test="${not empty project.projectLead && project.projectLead.id_employe == emp.id_employe}">selected</c:if>>
                                <c:out value="${emp.firstName} ${emp.lastName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </fieldset>
                <br/>

                <fieldset>
                    <legend>Assign Employees</legend>
                    <div style="height: 150px; overflow-y: scroll; border: 1px solid #ccc; padding: 5px;">
                        <c:forEach var="employee" items="${allEmployees}">
                                <c:set var="isChecked" value="" />
                                <c:forEach var="assignedEmployee" items="${project.employees}">
                                    <c:if test="${assignedEmployee.id_employe == employee.id_employe}">
                                        <c:set var="isChecked" value="checked" />
                                    </c:if>
                                </c:forEach>

                                <input type="checkbox" name="employees" value="${employee.id_employe}"
                                    id="emp-${employee.id_employe}" ${isChecked}>
                                <label for="emp-${employee.id_employe}">
                                    <c:out value="${employee.firstName} ${employee.lastName}" />
                                </label>
                                <br />
                        </c:forEach>
                    </div>
                </fieldset>
                <br />
                <button type="submit">Save Changes</button>
            </form>
        </body>

        </html>