package org.example.tms.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.tms.dao.CategoryDAO;
import org.example.tms.model.Category;
import org.example.tms.util.CustomLogger;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/categories/*")
public class CategoryServlet extends HttpServlet {
    private static final Logger logger = CustomLogger.createLogger(CategoryServlet.class.getName());
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getPathInfo();

        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/add":
                showAddCategoryForm(request, response);
                break;
            case "/edit":
                showEditCategoryForm(request, response);
                break;
            case "/delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getPathInfo();

        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/add":
                addCategory(request, response);
                break;
            case "/edit":
                updateCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/categories");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/category-list.jsp").forward(request, response);
    }

    private void showAddCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
    }

    private void showEditCategoryForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.getCategoryById(categoryId);

        if (category != null) {
            request.setAttribute("category", category);
            request.getRequestDispatcher("/views/category-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Category category = new Category();
        category.setName(name);
        category.setDescription(description);

        boolean success = categoryDAO.createCategory(category);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/categories");
        } else {
            logger.severe( "Failed to create category");
            request.setAttribute("errorMessage", "Failed to create category");
            showAddCategoryForm(request, response);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("name");
        String description = request.getParameter("description");

        Category category = new Category();
        category.setCategoryId(categoryId);
        category.setName(name);
        category.setDescription(description);

        boolean success = categoryDAO.updateCategory(category);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/categories");
        } else {
            logger.severe( "Failed to update category");
            request.setAttribute("errorMessage", "Failed to update category");
            showEditCategoryForm(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));

        boolean success = categoryDAO.deleteCategory(categoryId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/categories");
        } else {
            logger.severe( "Failed to delete category");
            request.setAttribute("errorMessage", "Failed to delete category");
            listCategories(request, response);
        }
    }
}
