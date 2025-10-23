package com.rhxmanager.servlets;

import com.rhxmanager.util.sessionUtils;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public HomeServlet() {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (sessionUtils.ifLoggedInRedirects(request, response, "/dashboard")) {
            return;
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
