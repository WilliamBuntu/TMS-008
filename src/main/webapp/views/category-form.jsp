<%@ page import="org.novaTech.tms.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (request.getAttribute("category") != null ? "Edit Category" : "Add New Category") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Consistent with login/register/add-edit-task pages */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            color: #343a40;
        }
        .category-form-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2); /* Deeper shadow for prominence */
            width: 100%;
            max-width: 450px; /* Consistent width with other forms */
            animation: fadeIn 0.8s ease-out; /* Fade-in animation */
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-header {
            text-align: center;
            margin-bottom: 30px;
            color: #667eea; /* Primary color */
            font-weight: 700;
            font-size: 2.2em;
        }
        .form-header i {
            font-size: 1.2em;
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
        textarea.form-control {
            min-height: 100px; /* Taller textarea */
            resize: vertical;
        }
        .btn-submit {
            width: 100%;
            padding: 14px;
            background-color: #28a745; /* Success green for category actions (consistent with add new task) */
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            margin-top: 20px;
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.2);
        }
        .btn-submit:hover {
            background-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(40, 167, 69, 0.3);
        }
        .alert {
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        .back-link {
            text-align: center;
            margin-top: 25px;
            font-size: 0.95em;
        }
        .back-link a {
            color: #667eea; /* Primary color for link */
            text-decoration: none;
            font-weight: 600;
        }
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="category-form-container">
    <%
        Category category = (Category) request.getAttribute("category");
        String formAction = (category != null) ? (request.getContextPath() + "/categories/edit") : (request.getContextPath() + "/categories/add");
    %>

    <h2 class="form-header">
        <i class="fas <%= (category != null ? "fa-edit" : "fa-plus-circle") %>"></i>
        <%= (category != null ? "Edit Category" : "Add New Category") %>
    </h2>

    <%-- Display Error Message --%>
    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i> <%= errorMessage %>
    </div>
    <% } %>

    <form action="<%= formAction %>" method="post">
        <% if (category != null) { %>
        <input type="hidden" name="categoryId" value="<%= category.getCategoryId() %>">
        <% } %>

        <div class="mb-3">
            <label for="name" class="form-label">Category Name:</label>
            <input type="text" class="form-control" id="name" name="name" value="<%= (category != null ? category.getName() : "") %>" required>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description:</label>
            <textarea class="form-control" id="description" name="description"><%= (category != null && category.getDescription() != null ? category.getDescription() : "") %></textarea>
        </div>

        <button type="submit" class="btn btn-submit">
            <i class="fas <%= (category != null ? "fa-save" : "fa-plus") %> me-2"></i>
            <%= (category != null ? "Update Category" : "Add Category") %>
        </button>
    </form>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/categories">
            <i class="fas fa-arrow-alt-circle-left me-2"></i> Back to Category List
        </a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>