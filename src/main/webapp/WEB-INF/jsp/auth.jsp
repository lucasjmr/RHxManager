<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        body {
          font-family: "Segoe UI", sans-serif;
          background-color: #f5f7fa;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
          margin: 0;
        }

        .login-container {
          background: white;
          padding: 2rem;
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
          width: 380px;
          text-align: center;
          box-sizing: border-box;
        }

        h2 {
          color: #333;
          margin-bottom: 1.5rem;
          font-size: 1.4rem;
        }

        label {
          display: block;
          text-align: left;
          font-weight: 500;
          margin-bottom: 0.5rem;
          color: #333;
          font-size: 0.9rem;
        }

        input,
        button {
          width: 100%;
          padding: 0.7rem;
          border-radius: 8px;
          box-sizing: border-box;
          font-size: 0.95rem;
          transition: all 0.3s ease;
        }

        input {
          border: 1px solid #ccc;
          margin-bottom: 1rem;
        }

        input:focus {
          border-color: #0078ff;
          box-shadow: 0 0 4px rgba(0, 120, 255, 0.3);
          outline: none;
        }

        button {
          background: #0078ff;
          color: white;
          border: none;
          cursor: pointer;
          margin-top: 0.3rem;
        }

        button:hover {
          background: #005fcc;
        }
        </style>
</head>
<body>

    <div class="login-container">
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