<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Authentication</title>
</head>
<body>

    <div>
        <button id="showLoginBtn" onclick="showForm('login')">Login</button>
        <button id="showSignupBtn" onclick="showForm('signup')">Sign Up</button>
    </div>
    <hr/>

    <div id="loginForm">
        <h2>Login</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p style="color:red;"><%= request.getAttribute("error") %></p>
        <% } %>
        <% if (request.getAttribute("signupSuccess") != null) { %>
            <p style="color:green;"><%= request.getAttribute("signupSuccess") %></p>
        <% } %>

        <form action="auth" method="POST">
            <input type="hidden" name="action" value="login">

            <div>
                <label for="username">Username:</label><br/>
                <input type="text" id="username" name="username" required>
            </div>
            <div>
                <label for="password">Password:</label><br/>
                <input type="password" id="password" name="password" required>
            </div>
            <br/>
            <button type="submit">Login</button>
        </form>
    </div>

    <div id="signupForm" style="display:none;">
        <h2>Sign Up</h2>
        <% if (request.getAttribute("signupError") != null) { %>
            <p style="color:red;"><%= request.getAttribute("signupError") %></p>
        <% } %>

        <form action="auth" method="POST">
            <input type="hidden" name="action" value="signup">

            <div>
                <label for="firstName">First Name:</label><br/>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div>
                <label for="lastName">Last Name:</label><br/>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            <div>
                <label for="signupUsername">Username:</label><br/>
                <input type="text" id="signupUsername" name="username" required>
            </div>
            <div>
                <label for="signupPassword">Password:</label><br/>
                <input type="password" id="signupPassword" name="password" required>
            </div>
            <br/>
            <button type="submit">Create Account</button>
        </form>
    </div>

    <script>
        const loginForm = document.getElementById('loginForm');
        const signupForm = document.getElementById('signupForm');

        function showForm(formName) {
            if (formName === 'login') {
                loginForm.style.display = 'block';
                signupForm.style.display = 'none';
            } else {
                loginForm.style.display = 'none';
                signupForm.style.display = 'block';
            }
        }

        <% if (request.getAttribute("showSignup") != null && (Boolean)request.getAttribute("showSignup")) { %>
            showForm('signup');
        <% } %>
    </script>
</body>
</html>