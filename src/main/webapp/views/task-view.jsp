<%@ page import="org.example.tms.model.Task" %>
<%@ page import="org.example.tms.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Task</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa; /* Light gray background consistent with dashboard */
            color: #343a40;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0;
            overflow: hidden; /* Crucial: Prevents body-level scrolling */
        }
        .view-task-container {
            background-color: #ffffff;
            padding: 25px; /* Reduced padding */
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); /* Deeper shadow for prominence */
            width: 100%;
            max-width: 600px;
            animation: fadeIn 0.8s ease-out; /* Fade-in animation */
            box-sizing: border-box; /* Include padding in width/height */
            /* Crucial: Set max-height and enable internal scrolling if content overflows */
            max-height: 90vh; /* Adjust this value as needed to fit content */
            overflow-y: auto; /* Enable vertical scrolling *inside* this container if content overflows */
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
        }
        /* Hide scrollbar for Chrome, Safari and Opera */
        .view-task-container::-webkit-scrollbar {
            display: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .view-task-header {
            text-align: center;
            margin-bottom: 25px; /* Reduced margin */
            color: #495057; /* Darker gray for section titles */
            font-weight: 700;
            font-size: 2em; /* Slightly smaller font size */
            position: relative;
        }
        .view-task-header::after {
            content: '';
            display: block;
            width: 70px;
            height: 3px; /* Reduced height */
            background-color: #667eea; /* Primary color underline */
            margin: 10px auto 0; /* Reduced margin */
            border-radius: 2px;
        }
        .detail-item {
            margin-bottom: 15px; /* Reduced margin */
        }
        .detail-item label {
            font-weight: 600;
            color: #667eea; /* Primary color for labels */
            display: block;
            margin-bottom: 5px; /* Reduced margin */
            font-size: 1em; /* Slightly smaller font size */
        }
        .detail-item p {
            margin: 0;
            padding: 12px; /* Reduced padding */
            border: 1px solid #e0e0e0;
            background-color: #f9f9f9;
            border-radius: 8px;
            font-size: 0.95em; /* Slightly smaller font size */
            color: #343a40;
            line-height: 1.5; /* Slightly adjusted line height */
        }
        .actions {
            text-align: center;
            margin-top: 25px; /* Reduced margin */
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 10px; /* Reduced space between buttons */
        }
        .actions .btn {
            font-weight: 600;
            padding: 8px 16px; /* Reduced padding */
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            font-size: 0.9em; /* Slightly smaller font size */
        }
        .actions .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .actions .btn-primary:hover {
            background-color: #5664d2;
            border-color: #5664d2;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .actions .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .actions .btn-danger:hover {
            background-color: #c82333;
            border-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .actions .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .actions .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        /* Status Badge (consistent with dashboard & tasks list) */
        .status-badge {
            display: inline-block;
            padding: 4px 10px; /* Reduced padding */
            border-radius: 5px; /* Reduced radius */
            font-weight: 700;
            color: white;
            text-transform: uppercase;
            font-size: 0.8em; /* Slightly smaller font size */
            letter-spacing: 0.5px;
        }
        .status-badge.PENDING { background-color: #ffc107; color: #333; }
        .status-badge.IN_PROGRESS { background-color: #17a2b8; }
        .status-badge.COMPLETED { background-color: #28a745; }
        .status-badge.CANCELED { background-color: #dc3545; }

        .task-not-found {
            text-align: center;
            color: #dc3545;
            margin-top: 15px; /* Reduced margin */
            font-size: 1.1em; /* Slightly smaller font size */
            font-weight: 500;
            padding: 15px; /* Reduced padding */
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
        }

        /* Responsive adjustments */
        @media (max-height: 750px) { /* For smaller screens (e.g., small laptops) */
            .view-task-container {
                max-height: 95vh; /* Allow more height usage */
                padding: 20px; /* Further reduce padding */
            }
            .view-task-header {
                font-size: 1.8em;
                margin-bottom: 20px;
            }
            .detail-item {
                margin-bottom: 12px;
            }
            .detail-item label {
                font-size: 0.95em;
            }
            .detail-item p {
                padding: 10px;
                font-size: 0.9em;
            }
            .actions {
                margin-top: 20px;
                gap: 8px;
            }
            .actions .btn {
                padding: 6px 12px;
                font-size: 0.8em;
            }
            .status-badge {
                font-size: 0.75em;
            }
            .task-not-found {
                font-size: 1em;
                padding: 12px;
            }
        }
        @media (max-width: 576px) { /* For mobile devices */
            .view-task-container {
                margin: 15px; /* Add some side margin */
                padding: 20px;
                max-height: 90vh;
            }
            .actions {
                flex-direction: column; /* Stack buttons vertically on very small screens */
                align-items: stretch; /* Stretch buttons to full width */
            }
            .actions .btn {
                width: 100%; /* Full width buttons */
            }
        }
    </style>
</head>
<body>
<div class="view-task-container">
    <%
        Task task = (Task) request.getAttribute("task");
        Category category = (Category) request.getAttribute("category");
    %>

    <% if (task != null) { %>
    <h2 class="view-task-header">
        <i class="fas fa-eye me-2"></i> Task Details: <%= task.getTitle() %>
    </h2>

    <div class="detail-item">
        <label><i class="fas fa-align-left me-2"></i> Description:</label>
        <p><%= task.getDescription() != null && !task.getDescription().isEmpty() ? task.getDescription() : "No description provided." %></p>
    </div>

    <div class="detail-item">
        <label><i class="fas fa-tag me-2"></i> Category:</label>
        <p><%= (category != null ? category.getName() : "N/A") %></p>
    </div>

    <div class="detail-item">
        <label><i class="fas fa-calendar-alt me-2"></i> Due Date:</label>
        <p><%= task.getDueDate() != null ? task.getDueDate() : "No due date." %></p>
    </div>

    <div class="detail-item">
        <label><i class="fas fa-info-circle me-2"></i> Status:</label>
        <p><span class="status-badge <%= task.getStatus().name() %>"><%= task.getStatus().name().replace("_", " ") %></span></p>
    </div>

    <div class="actions">
        <a href="<%= request.getContextPath() %>/tasks/edit?id=<%= task.getTaskId() %>" class="btn btn-primary">
            <i class="fas fa-edit me-2"></i> Edit Task
        </a>
        <a href="<%= request.getContextPath() %>/tasks/delete?id=<%= task.getTaskId() %>" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this task?');">
            <i class="fas fa-trash-alt me-2"></i> Delete Task
        </a>
        <a href="<%= request.getContextPath() %>/tasks" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-alt-circle-left me-2"></i> Back to List
        </a>
    </div>

    <% } else { %>
    <h2 class="view-task-header">Task Not Found</h2>
    <p class="task-not-found">
        <i class="fas fa-exclamation-triangle me-2"></i> The task you are looking for does not exist or has been deleted.
    </p>
    <div class="actions">
        <a href="<%= request.getContextPath() %>/tasks" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-alt-circle-left me-2"></i> Back to List
        </a>
    </div>
    <% } %>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>