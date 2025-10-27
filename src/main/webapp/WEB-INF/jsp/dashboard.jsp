<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>

    <table width="100%" style="border-collapse: collapse;">
        <tr>
            <td style="vertical-align: top;">
                <h1>Dashboard</h1>
                <p>Welcome, <b>${user.firstName} ${user.lastName}</b>!</p>
            </td>
            <td style="text-align: right; vertical-align: top;">
                <a href="logout">Logout</a>
            </td>
        </tr>
    </table>

    <hr/>

    <h2>Overview</h2>
    <ul>
        <li>Total Employees: <b>${totalEmployees}</b></li>
        <li>Total Departments: <b>${totalDepartments}</b></li>
        <li>Total Projects: <b>${totalProjects}</b></li>
        <li>Active Projects: <b>${activeProjects}</b></li>
    </ul>

    <hr/>

    <h2>Navigation Menu</h2>
    <nav>
        <ul>
            <li><a href="employees">Manage Employees</a></li>
            <li><a href="payslips">Manage Payslips</a></li>
            <li><a href="departments">Manage Departments</a></li>
            <li><a href="projects">Manage Projects</a></li>
        </ul>
    </nav>

</body>
</html>