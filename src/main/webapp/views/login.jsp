<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login to Task Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Consistent with landing page hero */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #343a40;
        }
        .login-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2); /* Deeper shadow for prominence */
            width: 100%;
            max-width: 400px; /* Max width for better form presentation */
            animation: fadeIn 0.8s ease-out; /* Fade-in animation */
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
            color: #667eea; /* Primary color */
            font-weight: 700;
            font-size: 2.2em;
        }
        .login-header i {
            font-size: 1.2em; /* Adjust icon size */
            margin-right: 10px;
        }
        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #ced4da;
            font-size: 16px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea; /* Primary color on focus */
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25); /* Light primary color shadow */
            outline: none;
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background-color: #667eea; /* Primary button color */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 4px 10px rgba(102, 126, 234, 0.2);
        }
        .btn-login:hover {
            background-color: #5664d2; /* Slightly darker on hover */
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(102, 126, 234, 0.3);
        }
        .alert {
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        .register-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.95em;
        }
        .register-link a {
            color: #667eea; /* Primary color for link */
            text-decoration: none;
            font-weight: 600;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="login-container">
    <h2 class="login-header">
        <i class="fas fa-sign-in-alt"></i> Login
    </h2>

    <%-- Display Error Message --%>
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <div class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
    </div>
    <%
        }
    %>

    <%-- Display Success Message (from successful registration) --%>
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null) {
    %>
    <div class="alert alert-success" role="alert">
        <i class="fas fa-check-circle me-2"></i> <%= successMessage %>
    </div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/auth/login" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Username:</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password:</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-login">Login</button>
    </form>

    <div class="register-link">
        Don't have an account? <a href="<%= request.getContextPath() %>/auth/register">Register here</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>