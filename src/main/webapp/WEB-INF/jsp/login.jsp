<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Login Page</title>
		<style>
			/* Style général de la page */
			body {
				font-family: Arial, sans-serif;
				background-color: #f4f4f4;
				display: flex;
				justify-content: center;
				align-items: center;
				height: 100vh;
				margin: 0;
			}

			/* Conteneur principal du formulaire */
			.login-container {
				background-color: #fff;
				padding: 2em;
				border-radius: 8px;
				box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
				width: 100%;
				max-width: 400px;
			}

			h2 {
				text-align: center;
				color: #333;
				margin-bottom: 1.5em;
			}

			.form-group {
				margin-bottom: 1em;
			}

			label {
				display: block;
				margin-bottom: 0.5em;
				color: #555;
				font-weight: bold;
			}

			input[type="text"],
			input[type="password"] {
				width: 100%;
				padding: 0.8em;
				border: 1px solid #ddd;
				border-radius: 4px;
				box-sizing: border-box;
				/* Empêche le padding de modifier la largeur totale */
			}

			.login-button {
				width: 100%;
				padding: 0.8em;
				border: none;
				border-radius: 4px;
				background-color: #007bff;
				color: white;
				font-size: 1em;
				cursor: pointer;
				transition: background-color 0.3s;
			}

			.login-button:hover {
				background-color: #0056b3;
			}

			/* Style pour le message d'erreur */
			.error-message {
				color: #D8000C;
				background-color: #FFD2D2;
				border: 1px solid #D8000C;
				padding: 0.8em;
				margin-bottom: 1em;
				border-radius: 4px;
				text-align: center;
			}
		</style>
	</head>

	<body>

		<div class="login-container">
			<h2>Application Login</h2>

			<%-- Ce bloc JSP vérifie si un message d'erreur a été envoyé par la servlet. En cas d'échec de connexion, la
				servlet placera un attribut nommé "error" dans la requête avant de la renvoyer vers cette page. --%>
				<% String errorMessage=(String) request.getAttribute("error"); if (errorMessage !=null) { %>
					<div class="error-message">
						<%= errorMessage %>
					</div>
					<% } %>

						<!-- 
            Le formulaire envoie les données en méthode POST vers la servlet de connexion.
            L'URL "login" devra être mappée à votre servlet dans le fichier web.xml
            ou via l'annotation @WebServlet("/login").
        -->
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