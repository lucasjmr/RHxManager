package com.rhxmanager.servlets;

import com.rhxmanager.dao.EmployeDao;
import com.rhxmanager.dao.PayslipDao;
import com.rhxmanager.model.Employe;
import com.rhxmanager.model.Payslip;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Random;

@WebServlet("/payslips")
public class PayslipServlet extends HttpServlet {

    private final PayslipDao payslipDao = new PayslipDao();
    private final EmployeDao employeDao = new EmployeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("view".equals(action)) {
            viewPayslip(request, response);
        } else {
            listPayslips(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        createPayslip(request, response);
    }

    private void listPayslips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String employeeIdStr = request.getParameter("employeeId");
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        int employeeId = 0;
        int month = 0;
        int year = 0;
        try {
            if (employeeIdStr != null && !employeeIdStr.isEmpty()) employeeId = Integer.parseInt(employeeIdStr);
            if (monthStr != null && !monthStr.isEmpty()) month = Integer.parseInt(monthStr);
            if (yearStr != null && !yearStr.isEmpty()) year = Integer.parseInt(yearStr);
        } catch (NumberFormatException e) {
            // ignore invalid parameters
        }

        request.setAttribute("payslips", payslipDao.findByCriteria(employeeId, month, year));

        request.setAttribute("selectedEmployeeId", employeeId);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);

        request.setAttribute("allEmployees", employeDao.findAll());

        request.getRequestDispatcher("/WEB-INF/jsp/payslips.jsp").forward(request, response);
    }

    private void viewPayslip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Payslip payslip = payslipDao.findByIdWithEmployee(id)
                .orElseThrow(() -> new ServletException("Payslip not found"));
        request.setAttribute("payslip", payslip);
        request.getRequestDispatcher("/WEB-INF/jsp/payslip-details.jsp").forward(request, response);
    }

    private void createPayslip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int employeeId = Integer.parseInt(request.getParameter("employeeId"));
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));

            if (payslipDao.exists(employeeId, month, year)) {
                request.setAttribute("error", "A payslip already exists for this employee and period.");
                listPayslips(request, response);
                return;
            }

            Employe employee = employeDao.findById(employeeId)
                    .orElseThrow(() -> new ServletException("Employee not found"));

            Random random = new Random();
            double bonus = 50 + (450 * random.nextDouble());
            double deductions = 20 + (280 * random.nextDouble());

            double netToPay = employee.getSalary() + bonus - deductions;

            Payslip payslip = new Payslip();
            payslip.setEmploye(employee);
            payslip.setMonth(month);
            payslip.setYear(year);
            payslip.setBonus(bonus);
            payslip.setDeductions(deductions);
            payslip.setNet(netToPay);

            payslipDao.save(payslip);
            response.sendRedirect(request.getContextPath() + "/payslips");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input. Please check the fields.");
            listPayslips(request, response);
        }
    }
}