<%@ page import="java.util.List" %>
<%@ page import="org.novaTech.tms.model.Task" %>
<%@ page import="org.novaTech.tms.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (request.getAttribute("task") != null ? "Edit Task" : "Add New Task") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Consistent with login/register pages */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #343a40;
            overflow: hidden; /* Crucial: Prevents body-level scrolling */
        }
        .task-form-container {
            background-color: #ffffff;
            padding: 25px; /* Reduced padding */
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 500px;
            animation: fadeIn 0.8s ease-out;
            box-sizing: border-box; /* Include padding in width/height */
            /* Crucial: Set max-height and enable internal scrolling if content overflows */
            max-height: 95vh; /* Adjust this value as needed to fit content + header/footer */
            overflow-y: auto; /* Enable vertical scrolling *inside* this container if content overflows */
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
        }
        /* Hide scrollbar for Chrome, Safari and Opera */
        .task-form-container::-webkit-scrollbar {
            display: none;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-header {
            text-align: center;
            margin-bottom: 25px; /* Reduced margin */
            color: #667eea;
            font-weight: 700;
            font-size: 2em; /* Slightly smaller font size */
        }
        .form-header i {
            font-size: 1.1em; /* Slightly smaller icon size */
            margin-right: 8px; /* Reduced margin */
        }
        .form-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 5px; /* Reduced margin */
            font-size: 0.95em; /* Slightly smaller font */
        }
        .form-control, .form-select {
            padding: 10px; /* Reduced padding */
            border-radius: 8px;
            border: 1px solid #ced4da;
            font-size: 15px; /* Slightly smaller font size */
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        textarea.form-control {
            min-height: 80px; /* Slightly shorter textarea */
            resize: vertical;
        }
        .mb-3 {
            margin-bottom: 15px !important; /* Ensure consistent spacing, reduced from Bootstrap default */
        }
        .btn-submit {
            width: 100%;
            padding: 12px; /* Reduced padding */
            background-color: #28a745; /* Changed to success green for Add/Update task */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1em; /* Slightly smaller font size */
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            margin-top: 15px; /* Reduced margin */
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2); /* Adjusted shadow for green button */
        }
        .btn-submit:hover {
            background-color: #218838; /* Darker green on hover */
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
        .back-link {
            text-align: center;
            margin-top: 20px; /* Reduced margin */
            font-size: 0.9em; /* Slightly smaller font size */
        }
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link a:hover {
            text-decoration: underline;
        }

        /* Responsive adjustments */
        @media (max-height: 780px) { /* For smaller screens (e.g., small laptops) */
            .task-form-container {
                max-height: 98vh; /* Allow more height usage, as it's a long form */
                padding: 20px; /* Further reduce padding */
            }
            .form-header {
                font-size: 1.8em;
                margin-bottom: 20px;
            }
            .form-control, .form-select, .btn-submit {
                padding: 8px;
                font-size: 0.9em;
            }
            .form-label, .back-link {
                font-size: 0.85em;
            }
            textarea.form-control {
                min-height: 70px; /* Further reduce textarea height */
            }
        }
        @media (max-width: 576px) { /* For mobile devices */
            .task-form-container {
                margin: 15px; /* Add some side margin */
                padding: 20px;
                max-height: 90vh; /* Adjust for mobile view */
            }
        }
    </style>
</head>
<body>
<div class="task-form-container">
    <%
        Task task = (Task) request.getAttribute("task");
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        String formAction = (task != null) ? (request.getContextPath() + "/tasks/edit") : (request.getContextPath() + "/tasks/add");
    %>

    <h2 class="form-header">
        <i class="fas <%= (task != null ? "fa-edit" : "fa-plus-circle") %>"></i>
        <%= (task != null ? "Edit Task" : "Add New Task") %>
    </h2>

    <%-- Display Error Message --%>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
    </div>
    <% } %>

    <form action="<%= formAction %>" method="post">
        <% if (task != null) { %>
        <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
        <% } %>

        <div class="mb-3">
            <label for="title" class="form-label">Title:</label>
            <input type="text" class="form-control" id="title" name="title" value="<%= (task != null ? task.getTitle() : "") %>" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description:</label>
            <textarea class="form-control" id="description" name="description"><%= (task != null && task.getDescription() != null ? task.getDescription() : "") %></textarea>
        </div>

        <div class="mb-3">
            <label for="categoryId" class="form-label">Category:</label>
            <select class="form-select" id="categoryId" name="categoryId" required>
                <% if (categories != null && !categories.isEmpty()) { %>
                <option value="">-- Select a Category --</option> <% for (Category category : categories) { %>
                <option value="<%= category.getCategoryId() %>"
                        <%= (task != null && task.getCategoryId() == category.getCategoryId() ? "selected" : "") %>>
                    <%= category.getName() %>
                </option>
                <% } %>
                <% } else { %>
                <option value="">No categories available - Add one first!</option>
                <% } %>
            </select>
        </div>

        <div class="mb-3">
            <label for="dueDate" class="form-label">Due Date:</label>
            <input type="date" class="form-control" id="dueDate" name="dueDate" value="<%= (task != null && task.getDueDate() != null ? task.getDueDate() : "") %>">
        </div>

        <% if (task != null) { %> <%-- Only show status for editing existing tasks --%>
        <div class="mb-3">
            <label for="status" class="form-label">Status:</label>
            <select class="form-select" id="status" name="status">
                <% for (Task.TaskStatus status : Task.TaskStatus.values()) { %>
                <option value="<%= status %>" <%= (task.getStatus() == status ? "selected" : "") %>>
                    <%= status.name().replace("_", " ") %>
                </option>
                <% } %>
            </select>
        </div>
        <% } %>

        <button type="submit" class="btn btn-submit">
            <i class="fas <%= (task != null ? "fa-save" : "fa-plus") %> me-2"></i>
            <%= (task != null ? "Update Task" : "Add Task") %>
        </button>
    </form>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/tasks">
            <i class="fas fa-arrow-alt-circle-left me-2"></i> Back to Task List
        </a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>