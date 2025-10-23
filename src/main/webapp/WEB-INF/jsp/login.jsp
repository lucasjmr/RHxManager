<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="UTF-8">
		<title>Login</title>
	</head>

	<body>

		<div class="login-container">
			<h2>Application Login</h2>
			<% String errorMessage=(String) request.getAttribute("error"); if (errorMessage !=null) { %>
				<div class="error-message">
					<%= errorMessage %>
				</div>
				<% } %>
					<form action="login" method="POST">
						<div class="form-group">
							<label for="username">Username</label>
							<input type="text" id="username" name="username" required>
						</div>
						<div class="form-group">
							<label for="password">Password</label>
							<input type="password" id="password" name="password" required>
						</div>
						<button type="submit" class="login-button">Login</button>
					</form>
		</div>

	</body>

	</html>