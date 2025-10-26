<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Edit Employee</title>
        </head>

        <body>
            <a href="employees">Back to Employee List</a> | <a href="dashboard">Dashboard</a>
            <hr />
            <h1>Editing:
                <c:out value="${employee.firstName} ${employee.lastName}" />
            </h1>

            <form action="employees" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${employee.id_employe}">

                <fieldset>
                    <legend>Personal Information</legend>
                    First Name: <br /> <input type="text" name="firstName" value="<c:out value="
                        ${employee.firstName}" />" required><br />
                    Last Name: <br /> <input type="text" name="lastName" value="<c:out value=" ${employee.lastName}" />"
                    required><br />
                    Grade: <br /> <input type="text" name="grade" value="<c:out value=" ${employee.grade}" />"><br />
                    Job Title: <br /> <input type="text" name="jobName" value="<c:out value="
                        ${employee.jobName}" />"><br />
                    Salary: <br /> <input type="number" name="salary" step="0.01" value="${employee.salary}"
                        required><br />
                </fieldset>

                <fieldset>
                    <legend>Account Information</legend>
                    Username: <br /> <b>
                        <c:out value="${employee.username}" />
                    </b> (cannot be changed)<br />
                    New Password: <br /> <input type="password" name="password"
                        placeholder="Leave blank to keep current password"><br />
                </fieldset>

                <fieldset>
                    <legend>Assign Roles</legend>
                    <c:forEach var="role" items="${allRoles}">
                        <input type="checkbox" name="roles" value="${role.id_role}" <c:forEach var="userRole"
                            items="${employee.roles}">
                        <c:if test="${userRole.id_role == role.id_role}">checked</c:if>
                    </c:forEach>
                    >
                    <c:out value="${role.roleName}" /><br />
                    </c:forEach>
                </fieldset>

                <fieldset>
                    <legend>Assign Projects</legend>
                    <div style="height: 150px; overflow-y: scroll; border: 1px solid #ccc; padding: 5px;">
                        <c:forEach var="project" items="${allProjects}">
                            <c:set var="isChecked" value="" />
                            <c:forEach var="assignedProject" items="${employee.projects}">
                                <c:if test="${assignedProject.id_project == project.id_project}">
                                    <c:set var="isChecked" value="checked" />
                                </c:if>
                            </c:forEach>

                            <input type="checkbox" name="projects" value="${project.id_project}"
                                id="proj-${project.id_project}" ${isChecked}>
                            <label for="proj-${project.id_project}">
                                <c:out value="${project.projectName}" />
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