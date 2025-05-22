<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif; /* Applied Poppins to the whole body */
            color: #343a40; /* Consistent text color */
        }
        /* Navigation (already good, but explicit Poppins) */
        .navbar {
            background-color: #667eea;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Slight shadow for consistency */
            font-weight: 600;
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        .navbar .btn {
            border-radius: 8px; /* Consistent button border-radius */
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .navbar .btn-outline-light:hover {
            background-color: rgba(255, 255, 255, 0.2); /* Softer hover for outline light */
        }
        .navbar .btn-light:hover {
            background-color: #e2e6ea; /* Lighter hover for solid light */
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Your existing gradient */
            color: white;
            padding: 120px 0; /* Slightly more vertical padding */
            box-shadow: 0 5px 15px rgba(0,0,0,0.15); /* Adds a subtle shadow */
        }
        .hero-section h1 {
            font-weight: 700; /* Bolder hero heading */
            font-size: 3.8em; /* Slightly larger */
        }
        .hero-section p.lead {
            font-weight: 300; /* Lighter lead text */
            font-size: 1.3em;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero-section .btn {
            padding: 15px 30px; /* Larger buttons */
            border-radius: 8px; /* Consistent button border-radius */
            font-size: 1.1em;
            font-weight: 600;
            transition: all 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .hero-section .btn-light {
            color: #667eea; /* Primary color for light button text */
        }
        .hero-section .btn-light:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
            background-color: #f0f0f0;
        }
        .hero-section .btn-outline-light:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
            background-color: rgba(255, 255, 255, 0.15); /* More subtle hover */
            border-color: rgba(255, 255, 255, 0.15);
        }

        /* Features Section */
        #features {
            background-color: #ffffff; /* White background for features section */
            padding-top: 80px;
            padding-bottom: 80px;
        }
        #features h2 {
            font-weight: 700;
            color: #495057; /* Darker gray for section titles */
            font-size: 2.5em;
            margin-bottom: 50px;
            position: relative;
        }
        #features h2::after {
            content: '';
            display: block;
            width: 100px;
            height: 4px;
            background-color: #667eea; /* Primary color underline */
            margin: 15px auto 0;
            border-radius: 2px;
        }
        .feature-card {
            border-radius: 12px; /* Consistent card border-radius */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); /* Consistent shadow */
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            background-color: #ffffff; /* Ensure white background */
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); /* More pronounced shadow on hover */
        }
        .feature-card .card-body {
            padding: 30px; /* Slightly more padding inside cards */
        }
        .icon-circle {
            width: 80px; /* Slightly larger icon circle */
            height: 80px;
            background: #e9f5ff; /* Lighter primary-themed background for consistency */
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px; /* More margin below icon */
            box-shadow: 0 2px 8px rgba(0,0,0,0.05); /* Subtle shadow on circle */
        }
        .icon-circle i {
            font-size: 35px; /* Slightly larger icon */
            color: #667eea; /* Primary color for icons */
        }
        .feature-card h4 {
            font-weight: 600; /* Bolder feature titles */
            color: #495057; /* Darker gray for titles */
            margin-bottom: 15px;
        }
        .feature-card p {
            color: #6c757d; /* Consistent muted text color */
            font-size: 0.95em;
        }

        /* Footer */
        footer {
            background-color: #e9ecef; /* Lighter gray background */
            padding: 30px 0; /* Consistent padding */
            color: #6c757d; /* Muted text color */
            font-size: 0.9em;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-tasks me-2"></i>
            Task Manager
        </a>
        <div class="d-flex">
            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-light me-2">
                <i class="fas fa-sign-in-alt me-1"></i> Login
            </a>
            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-light">
                <i class="fas fa-user-plus me-1"></i> Sign Up
            </a>
        </div>
    </div>
</nav>

<section class="hero-section">
    <div class="container text-center">
        <h1 class="display-4 mb-4">Manage Your Tasks Efficiently</h1>
        <p class="lead mb-5">Stay organized, meet deadlines, and achieve your goals with our powerful task management system.</p>
        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-light btn-lg px-4 me-3">
            <i class="fas fa-arrow-right me-2"></i> Get Started
        </a>
        <a href="#features" class="btn btn-outline-light btn-lg px-4">
            <i class="fas fa-info-circle me-2"></i> Learn More
        </a>
    </div>
</section>

<section id="features" class="py-5">
    <div class="container">
        <h2 class="text-center mb-5">Key Features</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card h-100 feature-card border-0">
                    <div class="card-body text-center">
                        <div class="icon-circle">
                            <i class="fas fa-list-check"></i>
                        </div>
                        <h4>Task Organization</h4>
                        <p class="text-muted">Create, organize, and prioritize your tasks with ease.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 feature-card border-0">
                    <div class="card-body text-center">
                        <div class="icon-circle">
                            <i class="fas fa-users"></i>
                        </div>
                        <h4>Team Collaboration</h4>
                        <p class="text-muted">Work together efficiently with team members on shared tasks.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 feature-card border-0">
                    <div class="card-body text-center">
                        <div class="icon-circle">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h4>Progress Tracking</h4>
                        <p class="text-muted">Monitor task progress and meet your deadlines.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer class="bg-light py-4 mt-5">
    <div class="container text-center">
        <p class="mb-0 text-muted">&copy; 2025 Task Management System. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>