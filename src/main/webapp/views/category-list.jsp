<%@ page import="java.util.List" %>
<%@ page import="org.novaTech.tms.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories</title>
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

        .container-categories {
            max-width: 900px; /* Adjusted width for categories table */
            margin: 0 auto;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08); /* Consistent shadow */
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
            width: 90px;
            height: 4px;
            background-color: #667eea; /* Primary color underline */
            margin: 15px auto 0;
            border-radius: 2px;
        }
        .header-actions {
            text-align: center;
            margin-bottom: 30px;
            display: flex;
            justify-content: center;
            gap: 20px; /* Spacing between buttons */
            flex-wrap: wrap; /* Allow wrapping on small screens */
        }
        .header-actions .btn {
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-actions .btn-success {
            background-color: #28a745; /* Green for add */
            border-color: #28a745;
        }
        .header-actions .btn-success:hover {
            background-color: #218838;
            border-color: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .header-actions .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
        }
        .header-actions .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Category Table */
        .category-table {
            width: 100%;
            border-collapse: separate; /* Use separate for rounded corners */
            border-spacing: 0;
            margin-top: 20px;
            border-radius: 10px; /* Rounded corners for table */
            overflow: hidden; /* Hide overflowing content on rounded corners */
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .category-table thead th {
            background-color: #667eea; /* Primary color for header */
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border: none; /* Remove individual cell borders in header */
        }
        .category-table tbody td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0; /* Lighter border */
            background-color: #ffffff;
            vertical-align: middle; /* Align content vertically */
        }
        .category-table tbody tr:nth-child(even) td {
            background-color: #f5faff; /* Very light blue for even rows */
        }
        .category-table tbody tr:hover td {
            background-color: #eaf2fa; /* Light blue on hover */
            cursor: pointer;
        }
        .category-table tbody tr:last-child td {
            border-bottom: none; /* No border for last row */
        }

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

        .no-categories {
            text-align: center;
            color: #6c757d;
            margin-top: 40px;
            font-size: 1.2em;
            padding: 20px;
            background-color: #f2f2f2;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .no-categories a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }
        .no-categories a:hover {
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
    <div class="container-categories">
        <h1><i class="fas fa-tags me-3"></i> Manage Task Categories</h1>

        <div class="header-actions">
            <a href="<%= request.getContextPath() %>/categories/add" class="btn btn-success">
                <i class="fas fa-plus-circle me-2"></i> Add New Category
            </a>
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-alt-circle-left me-2"></i> Back to Dashboard
            </a>
        </div>

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

        <%
            List<Category> categories = (List<Category>) request.getAttribute("categories");
            if (categories != null && !categories.isEmpty()) {
        %>
        <div class="table-responsive">
            <table class="category-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Category category : categories) { %>
                <tr>
                    <td><%= category.getCategoryId() %></td>
                    <td><%= category.getName() %></td>
                    <td><%= category.getDescription() != null && !category.getDescription().isEmpty() ? category.getDescription() : "N/A" %></td>
                    <td class="actions text-nowrap">
                        <a href="<%= request.getContextPath() %>/categories/edit?id=<%= category.getCategoryId() %>" title="Edit Category"><i class="fas fa-edit"></i></a>
                        <a href="<%= request.getContextPath() %>/categories/delete?id=<%= category.getCategoryId() %>" class="delete-btn" title="Delete Category" onclick="return confirm('Are you sure you want to delete this category? This will affect tasks associated with it.');"><i class="fas fa-trash-alt"></i></a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <p class="no-categories">
            <i class="fas fa-info-circle me-2"></i> No categories found. Why not <a href="<%= request.getContextPath() %>/categories/add">add the first one</a>?
        </p>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>