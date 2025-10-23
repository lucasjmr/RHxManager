package com.rhxmanager.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class SessionUtil {
    public static boolean ifLoggedInRedirects(HttpServletRequest request, HttpServletResponse response, String url)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + url);
            return true;
        }
        return false;
    }

    public static boolean ifNotLoggedInRedirects(HttpServletRequest request, HttpServletResponse response, String url)
            throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + url);
            return true;
        }
        return false;
    }
}
