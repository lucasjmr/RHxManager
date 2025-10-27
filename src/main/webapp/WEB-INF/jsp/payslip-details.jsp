<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Payslip for ${payslip.employe.firstName} ${payslip.employe.lastName}</title>
</head>
<body style="font-family: sans-serif; width: 80%; margin: auto;">
    <div style="text-align: right;">
        <button onclick="window.print()">Print this payslip</button>
        <a href="payslips">Back to list</a>
    </div>
    <hr/>

    <h1 style="text-align: center;">Payslip</h1>

    <h3>Period: ${payslip.month} / ${payslip.year}</h3>

    <fieldset>
        <legend>Employee Information</legend>
        <p><b>Name:</b> <c:out value="${payslip.employe.firstName} ${payslip.employe.lastName}"/></p>
        <p><b>Job Title:</b> <c:out value="${payslip.employe.jobName}"/></p>
        <p><b>Department:</b> <c:out value="${payslip.employe.department.departmentName}"/></p>
    </fieldset>
    <br/>

    <table border="1" style="width:100%; border-collapse: collapse;" cellpadding="8">
        <tr style="background-color:#f2f2f2;">
            <th>Description</th>
            <th>Amount (€)</th>
        </tr>
        <tr>
            <td>Base Salary</td>
            <td style="text-align: right;"><c:out value="${String.format('%.2f', payslip.employe.salary)}"/></td>
        </tr>
        <tr>
            <td>Bonus</td>
            <td style="text-align: right;"><c:out value="${String.format('%.2f', payslip.bonus)}"/></td>
        </tr>
        <tr>
            <td>Deductions</td>
            <td style="text-align: right;">- <c:out value="${String.format('%.2f', payslip.deductions)}"/></td>
        </tr>
        <tr style="font-weight: bold; background-color:#e8e8e8;">
            <td>NET TO PAY</td>
            <td style="text-align: right;"><c:out value="${String.format('%.2f', payslip.net)}"/></td>
        </tr>
    </table>
</body>
</html>