<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register for Task Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Consistent with landing/login page hero */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Ensure body takes full viewport height */
            margin: 0;
            color: #343a40;
            overflow: hidden; /* Crucial: Prevents body-level scrolling */
        }
        .register-container {
            background-color: #ffffff;
            padding: 25px; /* Reduced padding */
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
            animation: fadeIn 0.8s ease-out;
            box-sizing: border-box; /* Include padding in width/height */
            /* Crucial: Set max-height and enable internal scrolling if content overflows */
            max-height: 90vh; /* Adjust this value as needed to fit content + header/footer */
            overflow-y: auto; /* Enable vertical scrolling *inside* this container if content overflows */
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
        }
        /* Hide scrollbar for Chrome, Safari and Opera */
        .register-container::-webkit-scrollbar {
            display: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .register-header {
            text-align: center;
            margin-bottom: 25px; /* Reduced margin */
            color: #667eea;
            font-weight: 700;
            font-size: 2em; /* Slightly smaller font size */
        }
        .register-header i {
            font-size: 1.1em; /* Slightly smaller icon size */
            margin-right: 8px; /* Reduced margin */
        }
        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 5px; /* Reduced margin */
            font-size: 0.95em; /* Slightly smaller font */
        }
        .form-control {
            padding: 10px; /* Reduced padding */
            border-radius: 8px;
            border: 1px solid #ced4da;
            font-size: 15px; /* Slightly smaller font size */
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        .mb-3 {
            margin-bottom: 15px !important; /* Ensure consistent spacing, reduced from Bootstrap default */
        }
        .btn-register {
            width: 100%;
            padding: 12px; /* Reduced padding */
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1em; /* Slightly smaller font size */
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            margin-top: 15px; /* Reduced margin */
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2);
        }
        .btn-register:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.3);
        }
        .alert {
            margin-bottom: 15px; /* Reduced margin */
            border-radius: 8px;
            font-weight: 500;
            padding: 12px; /* Reduced padding */
            font-size: 0.95em; /* Slightly smaller font */
        }
        .login-link {
            text-align: center;
            margin-top: 20px; /* Reduced margin */
            font-size: 0.9em; /* Slightly smaller font size */
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
            text-decoration: underline;
        }

        /* Responsive adjustments */
        @media (max-height: 700px) { /* For smaller screens (e.g., small laptops) */
            .register-container {
                max-height: 95vh; /* Allow more height usage */
                padding: 20px; /* Further reduce padding */
            }
            .register-header {
                font-size: 1.8em;
                margin-bottom: 20px;
            }
            .form-control, .btn-register {
                padding: 8px;
                font-size: 0.9em;
            }
            .form-label, .login-link {
                font-size: 0.85em;
            }
        }
        @media (max-width: 500px) { /* For mobile devices */
            .register-container {
                margin: 20px; /* Add some side margin */
                padding: 20px;
                max-height: 90vh;
            }
        }
    </style>
</head>
<body>
<div class="register-container">
    <h2 class="register-header">
        <i class="fas fa-user-plus"></i> Register
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

    <form action="<%= request.getContextPath() %>/auth/register" method="post">
        <div class="mb-3">
            <label for="username" class="form-label">Username:</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email:</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password:</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <div class="mb-3">
            <label for="confirmPassword" class="form-label">Confirm Password:</label>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
        </div>
        <button type="submit" class="btn btn-register">Register Account</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="<%= request.getContextPath() %>/auth/login">Login here</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>