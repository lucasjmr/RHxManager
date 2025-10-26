<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>

    <div>
        <h2>Login</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p style="color:red;"><%= request.getAttribute("error") %></p>
        <% } %>

        <form action="auth" method="POST">
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

</body>
</html>