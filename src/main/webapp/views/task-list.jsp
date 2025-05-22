<%@ page import="java.util.List" %>
<%@ page import="org.novaTech.tms.model.Task" %>
<%@ page import="org.novaTech.tms.model.Category" %>
<%@ page import="org.novaTech.tms.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tasks</title>
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
            flex-direction: column;
        }
        /* Navigation Bar (consistent with dashboard) */
        .navbar {
            background-color: #667eea; /* Consistent primary color */
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .main-content-wrapper {
            flex-grow: 1;
            padding-top: 30px;
            padding-bottom: 50px;
        }

        .container-tasks {
            width: 100%;
            max-width: 100%;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        h1 {
            text-align: center;
            color: #495057; /* Darker gray for section titles */
            font-size: 2.2em;
            margin-bottom: 40px;
            position: relative;
            font-weight: 700;
        }
        h1::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background-color: #667eea; /* Primary color underline */
            margin: 15px auto 0;
            border-radius: 2px;
        }
        .welcome-message {
            text-align: center;
            margin-bottom: 30px;
            font-size: 1.3em;
            color: #667eea; /* Primary color */
            font-weight: 600;
        }
        .header-links {
            text-align: center;
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            gap: 20px; /* Spacing between buttons */
            flex-wrap: wrap; /* Allow wrapping on small screens */
        }
        .header-links .btn {
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-links .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .header-links .btn-primary:hover {
            background-color: #5664d2;
            border-color: #5664d2;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .header-links .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .header-links .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Filter Section */
        .filter-section {
            background-color: #e9f5ff; /* Light blue background */
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .filter-section label {
            font-weight: 600;
            color: #667eea; /* Primary color for labels */
        }
        .filter-section select.form-select { /* Use Bootstrap's form-select */
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid #cceeff; /* Lighter border */
            background-color: #ffffff;
            color: #343a40;
            min-width: 150px; /* Ensure select boxes are readable */
        }
        .filter-section .btn {
            padding: 10px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .filter-section .btn-primary {
            background-color: #667eea;
            border-color: #667eea;
        }
        .filter-section .btn-primary:hover {
            background-color: #5664d2;
            border-color: #5664d2;
            transform: translateY(-1px);
        }
        .filter-section .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .filter-section .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-1px);
        }

        /* Task Table */
        .task-table {
            width: 100%;
            border-collapse: separate; /* Use separate for rounded corners */
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 10px; /* Rounded corners for table */
            overflow: hidden; /* Hide overflowing content on rounded corners */
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .task-table thead th {
            background-color: #667eea; /* Primary color for header */
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border: none; /* Remove individual cell borders in header */
        }
        .task-table tbody td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0; /* Lighter border */
            background-color: #ffffff;
            vertical-align: middle; /* Align content vertically */
        }
        .task-table tbody tr:nth-child(even) td {
            background-color: #f5faff; /* Very light blue for even rows */
        }
        .task-table tbody tr:hover td {
            background-color: #eaf2fa; /* Light blue on hover */
            cursor: pointer;
        }
        .task-table tbody tr:last-child td {
            border-bottom: none; /* No border for last row */
        }

        /* Status Select (aligned with dashboard badges) */
        .status-select {
            padding: 6px 10px;
            border-radius: 5px;
            border: 1px solid rgba(0,0,0,0.1);
            font-weight: 600;
            font-size: 0.9em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s ease;
            -webkit-appearance: none; /* Remove default arrow on select */
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23333' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E"); /* Custom arrow */
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 16px 12px;
        }
        /* Specific status colors */
        .status-select.PENDING { background-color: #ffc107; color: #333; } /* Warning yellow */
        .status-select.IN_PROGRESS { background-color: #17a2b8; color: white; } /* Info cyan */
        .status-select.COMPLETED { background-color: #28a745; color: white; } /* Success green */
        .status-select.CANCELED { background-color: #dc3545; color: white; } /* Danger red */

        /* Actions */
        .actions a {
            margin-right: 12px;
            text-decoration: none;
            color: #667eea; /* Primary color for actions */
            font-weight: 500;
            transition: color 0.2s ease;
        }
        .actions a:hover {
            color: #5664d2;
            text-decoration: underline;
        }
        .actions .delete-btn {
            color: #dc3545; /* Red for delete */
        }
        .actions .delete-btn:hover {
            color: #c82333;
        }

        .no-tasks {
            text-align: center;
            color: #6c757d;
            margin-top: 40px;
            font-size: 1.2em;
            padding: 20px;
            background-color: #f2f2f2;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .no-tasks a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .no-tasks a:hover {
            text-decoration: underline;
        }

        /* Error Message Alert */
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .alert-danger i {
            margin-right: 8px;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm">
    <div class="container-fluid">
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
    <div class="container-tasks">
        <% User currentUser = (User) session.getAttribute("user"); %>
        <% if (currentUser != null) { %>
        <p class="welcome-message">Welcome, <%= currentUser.getUsername() %>! Here are all your tasks.</p>
        <% } %>

        <div class="header-links">
            <a href="<%= request.getContextPath() %>/tasks/add" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i> Add New Task
            </a>
            <a href="<%= request.getContextPath() %>/categories" class="btn btn-outline-secondary">
                <i class="fas fa-tags me-2"></i> Manage Categories
            </a>
        </div>

        <h1>Your Tasks</h1>

        <%-- Display Error Message --%>
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null) { %>
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
        </div>
        <% } %>

        <div class="filter-section">
            <form action="<%= request.getContextPath() %>/tasks/filter" method="get" class="d-flex flex-wrap gap-3 align-items-center">
                <label for="statusFilter" class="form-label mb-0">Filter by Status:</label>
                <select id="statusFilter" name="status" class="form-select w-auto">
                    <option value="">All</option>
                    <% String selectedStatus = (String) request.getAttribute("selectedStatus"); %>
                    <% for (Task.TaskStatus status : Task.TaskStatus.values()) { %>
                    <option value="<%= status %>" <%= (status.toString().equals(selectedStatus) ? "selected" : "") %>><%= status.name().replace("_", " ") %></option>
                    <% } %>
                </select>

                <label for="categoryFilter" class="form-label mb-0">Filter by Category:</label>
                <select id="categoryFilter" name="categoryId" class="form-select w-auto">
                    <option value="">All</option>
                    <%
                        List<Category> categories = (List<Category>) request.getAttribute("categories");
                        String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
                        if (categories != null) {
                            for (Category category : categories) {
                    %>
                    <option value="<%= category.getCategoryId() %>" <%= (String.valueOf(category.getCategoryId()).equals(selectedCategoryId) ? "selected" : "") %>><%= category.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
                <button type="submit" class="btn btn-primary"><i class="fas fa-filter me-2"></i> Apply Filter</button>
            </form>
            <form action="<%= request.getContextPath() %>/tasks" method="get">
                <button type="submit" class="btn btn-outline-secondary"><i class="fas fa-undo me-2"></i> Clear Filters</button>
            </form>
        </div>

        <%
            List<Task> tasks = (List<Task>) request.getAttribute("tasks");
            if (tasks != null && !tasks.isEmpty()) {
        %>
        <div class="table-responsive">
            <table class="task-table">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Category</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Task task : tasks) { %>
                <tr>
                    <td><%= task.getTitle() %></td>
                    <td><%= task.getDescription() != null && !task.getDescription().isEmpty() ? task.getDescription() : "N/A" %></td>
                    <td>
                        <%
                            String categoryName = "N/A";
                            if (categories != null) {
                                for (Category category : categories) {
                                    if (category.getCategoryId() == task.getCategoryId()) {
                                        categoryName = category.getName();
                                        break;
                                    }
                                }
                            }
                            out.print(categoryName);
                        %>
                    </td>
                    <td><%= task.getDueDate() != null ? task.getDueDate() : "N/A" %></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/tasks/status" method="post" class="d-inline">
                            <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                            <select name="status" class="status-select <%= task.getStatus().name() %>" onchange="this.form.submit()">
                                <% for (Task.TaskStatus status : Task.TaskStatus.values()) { %>
                                <option value="<%= status %>" <%= (task.getStatus() == status ? "selected" : "") %>>
                                    <%= status.name().replace("_", " ") %>
                                </option>
                                <% } %>
                            </select>
                        </form>
                    </td>
                    <td class="actions text-nowrap">
                        <a href="<%= request.getContextPath() %>/tasks/view?id=<%= task.getTaskId() %>" title="View Task"><i class="fas fa-eye"></i></a>
                        <a href="<%= request.getContextPath() %>/tasks/edit?id=<%= task.getTaskId() %>" title="Edit Task"><i class="fas fa-edit"></i></a>
                        <a href="<%= request.getContextPath() %>/tasks/delete?id=<%= task.getTaskId() %>" class="delete-btn" title="Delete Task" onclick="return confirm('Are you sure you want to delete this task?');"><i class="fas fa-trash-alt"></i></a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <p class="no-tasks">
            <i class="fas fa-info-circle me-2"></i> No tasks found. Why not <a href="<%= request.getContextPath() %>/tasks/add">add a new one</a>?
        </p>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>