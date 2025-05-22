<%@ page import="java.util.List" %>
<%@ page import="org.example.tms.model.Task" %>
<%@ page import="org.example.tms.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa; /* Light gray background */
            color: #343a40;
            min-height: 100vh; /* Ensure body takes full viewport height */
            display: flex;
            flex-direction: column; /* Allows content to push footer down */
            overflow: hidden; /* Prevent scrolling on body level */
        }
        .navbar {
            background-color: #667eea; /* Consistent with landing page */
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); /* Subtle shadow for nav */
        }
        .main-content-wrapper {
            flex-grow: 1; /* Allows this div to expand and fill available height */
            padding-top: 20px; /* Space from navbar */
            padding-bottom: 20px; /* Space before links section */
            display: flex; /* For centering content vertically */
            align-items: center; /* Center content vertically */
            justify-content: center; /* Center content horizontally */
            /* Add min-height to ensure it takes up significant portion */
            min-height: calc(100vh - var(--navbar-height) - var(--footer-height, 0px) - 40px); /* Adjust based on navbar/footer height */
            box-sizing: border-box; /* Include padding in height */
        }
        .container-dashboard {
            max-width: 960px; /* Max width for consistency */
            width: 100%; /* Ensure it takes full width up to max-width */
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            box-sizing: border-box;
            display: flex; /* Make dashboard container a flex container */
            flex-direction: column; /* Arrange children vertically */
            /* Crucial: Set a max-height relative to viewport to enable internal scrolling */
            max-height: calc(100vh - 120px); /* Adjust this value (100vh - navbar_height - top_padding - bottom_padding - some_margin) */
            overflow-y: auto; /* Enable vertical scrolling *inside* this container if content overflows */
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
        }
        /* Hide scrollbar for Chrome, Safari and Opera */
        .container-dashboard::-webkit-scrollbar {
            display: none;
        }

        .welcome-message {
            font-size: 1.4em; /* Slightly smaller for compactness */
            font-weight: 600;
            color: #667eea; /* Primary color */
            text-align: center;
            margin-bottom: 20px; /* Reduced margin */
        }
        h2 {
            text-align: center;
            color: #495057; /* Darker gray for section titles */
            font-size: 1.8em; /* Slightly smaller for compactness */
            margin-bottom: 30px; /* Reduced margin */
            position: relative;
        }
        h2::after {
            content: '';
            display: block;
            width: 70px;
            height: 3px;
            background-color: #667eea; /* Primary color underline */
            margin: 10px auto 0; /* Reduced margin */
            border-radius: 2px;
        }
        .task-summary-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            height: 100%; /* Make card take full height of its column */
            display: flex;
            flex-direction: column;
            flex-grow: 1; /* Allow cards to grow and fill available space */
        }
        .task-summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }
        .task-summary-card .card-header {
            background-color: #f0f8ff; /* Light blue header */
            color: #667eea; /* Primary color for header text */
            font-weight: 700;
            font-size: 1.2em; /* Slightly smaller */
            border-bottom: 1px solid #d0e0ff;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            padding: 12px 20px; /* Reduced padding */
        }
        .task-summary-card .card-body {
            flex-grow: 1; /* Allows card body to fill remaining space */
            display: flex;
            flex-direction: column;
            padding-bottom: 0; /* Adjust padding for list to fit */
            overflow-y: auto; /* Allow scrolling *inside* card body if list is too long */
        }
        .task-list {
            list-style-type: none;
            padding: 0;
            margin: 10px 0 0; /* Reduced margin */
            flex-grow: 1;
        }
        .task-list li {
            background-color: #e9f5ff; /* Lighter blue for items */
            margin-bottom: 8px; /* Reduced margin */
            padding: 10px 15px; /* Reduced padding */
            border-radius: 6px; /* Slightly smaller radius */
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9em; /* Slightly smaller font */
            border-left: 5px solid #667eea; /* Primary color border */
        }
        .task-list li:last-child {
            margin-bottom: 0; /* No margin for the last item */
        }
        .no-tasks {
            color: #6c757d;
            font-style: italic;
            text-align: center;
            padding: 15px; /* Reduced padding */
            background-color: #f2f2f2;
            border-radius: 8px;
            margin-top: auto;
            margin-bottom: auto;
            width: 100%;
            box-sizing: border-box;
            font-size: 0.95em; /* Slightly smaller font */
        }
        .dashboard-links {
            text-align: center;
            margin-top: 30px; /* Adjusted margin */
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 15px; /* Reduced gap */
        }
        .dashboard-links .btn {
            font-weight: 600;
            padding: 10px 20px; /* Reduced padding */
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            font-size: 0.95em; /* Slightly smaller font */
        }
        .dashboard-links .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .dashboard-links .btn-primary:hover {
            background-color: #5664d2;
            border-color: #5664d2;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.2);
        }
        .dashboard-links .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .dashboard-links .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 3px 6px; /* Smaller padding */
            border-radius: 3px; /* Smaller radius */
            font-weight: bold;
            font-size: 0.7em; /* Even smaller font for compactness */
            color: white;
            text-transform: uppercase;
            margin-left: 8px; /* Reduced margin */
        }
        .status-badge.PENDING { background-color: #ffc107; color: #333; }
        .status-badge.IN_PROGRESS { background-color: #17a2b8; }
        .status-badge.COMPLETED { background-color: #28a745; }
        .status-badge.CANCELED { background-color: #dc3545; }

        /* Responsive adjustments for overall layout */
        @media (max-width: 992px) { /* Adjust for smaller laptops/larger tablets */
            .main-content-wrapper {
                padding-top: 15px;
                padding-bottom: 15px;
            }
            .container-dashboard {
                max-height: calc(100vh - 100px); /* Adjust for smaller screens */
                padding: 25px;
            }
        }
        @media (max-width: 768px) { /* Adjust for typical tablets/phones */
            .main-content-wrapper {
                padding-top: 10px;
                padding-bottom: 10px;
            }
            .container-dashboard {
                margin: 15px; /* Smaller margin on smaller screens */
                padding: 20px; /* Smaller padding on smaller screens */
                max-height: calc(100vh - 80px); /* Adjust more for mobile */
            }
            .welcome-message {
                font-size: 1.2em;
                margin-bottom: 15px;
            }
            h2 {
                font-size: 1.6em;
                margin-bottom: 25px;
            }
            .dashboard-links {
                margin-top: 20px;
                gap: 10px;
            }
            .dashboard-links .btn {
                padding: 8px 15px;
                font-size: 0.85em;
            }
            .task-summary-card .card-header {
                font-size: 1em;
                padding: 10px 15px;
            }
            .task-list li {
                padding: 8px 12px;
                font-size: 0.85em;
                margin-bottom: 6px;
            }
            .status-badge {
                font-size: 0.65em;
            }
            .no-tasks {
                font-size: 0.9em;
                padding: 12px;
            }
        }
        @media (max-width: 576px) { /* Even smaller phones */
            .container-dashboard {
                padding: 15px;
                max-height: calc(100vh - 60px);
            }
            .dashboard-links {
                flex-direction: column; /* Stack buttons vertically on very small screens */
                align-items: stretch; /* Stretch buttons to full width */
            }
            .dashboard-links .btn {
                width: 100%; /* Full width buttons */
            }
        }
    </style>
</head>
<body class="d-flex flex-column">

<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/dashboard">
            <i class="fas fa-tasks me-2"></i>
            Task Manager
        </a>
        <div class="d-flex">
            <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-outline-light">Logout</a>
        </div>
    </div>
</nav>

<div class="main-content-wrapper">
    <div class="container-dashboard">
        <%
            User currentUser = (User) session.getAttribute("user");
            List<Task> todayTasks = (List<Task>) request.getAttribute("todayTasks");
            List<Task> pendingTasks = (List<Task>) request.getAttribute("pendingTasks");
        %>

        <% if (currentUser != null) { %>
        <p class="welcome-message">Hello, <%= currentUser.getUsername() %>! Here's your task overview.</p>
        <% } else { %>
        <p class="welcome-message">Hello! Welcome to your Task Dashboard.</p>
        <% } %>

        <h2>Your Task Snapshot</h2>

        <div class="row g-4 mb-4 flex-grow-1"> <div class="col-md-6 d-flex"> <div class="card h-100 task-summary-card">
            <div class="card-header">
                <i class="far fa-calendar-alt me-2"></i> Tasks Due Today
            </div>
            <div class="card-body">
                <% if (todayTasks != null && !todayTasks.isEmpty()) { %>
                <ul class="task-list">
                    <% for (Task task : todayTasks) { %>
                    <li>
                        <strong><%= task.getTitle() %></strong>
                        <span class="status-badge <%= task.getStatus().name() %>"><%= task.getStatus().name().replace("_", " ") %></span>
                    </li>
                    <% } %>
                </ul>
                <% } else { %>
                <p class="no-tasks d-flex align-items-center justify-content-center">
                    <i class="fas fa-check-circle me-2"></i> No tasks due today. Good job!
                </p>
                <% } %>
            </div>
        </div>
        </div>

            <div class="col-md-6 d-flex"> <div class="card h-80  task-summary-card">
                <div class="card-header">
                    <i class="fas fa-hourglass-half me-2"></i> All Pending Tasks
                </div>
                <div class="card-body">
                    <% if (pendingTasks != null && !pendingTasks.isEmpty()) { %>
                    <ul class="task-list">
                        <% for (Task task : pendingTasks) { %>
                        <li>
                            <strong><%= task.getTitle() %></strong>
                            <span>(Due: <%= task.getDueDate() != null ? task.getDueDate() : "No due date" %>)</span>
                        </li>
                        <% } %>
                    </ul>
                    <% } else { %>
                    <p class="no-tasks d-flex align-items-center justify-content-center">
                        <i class="fas fa-mug-hot me-2"></i> You're all caught up! No pending tasks.
                    </p>
                    <% } %>
                </div>
            </div>
            </div>
        </div>

        <div class="dashboard-links text-center d-flex justify-content-center flex-wrap gap-3">
            <a href="<%= request.getContextPath() %>/tasks" class="btn btn-primary">
                <i class="fas fa-list-ul me-2"></i> View All Tasks
            </a>
            <a href="<%= request.getContextPath() %>/tasks/add" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i> Add New Task
            </a>
            <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-secondary">
                <i class="fas fa-tags me-2"></i> Manage Categories
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>