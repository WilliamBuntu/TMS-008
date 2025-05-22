package org.example.tms.controller;

import org.example.tms.dao.CategoryDAO;
import org.example.tms.dao.TaskDAO;
import org.example.tms.model.Category;
import org.example.tms.model.Task;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.tms.util.CustomLogger;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/tasks/*")
public class TaskServlet extends HttpServlet {
    private static final Logger logger = CustomLogger.createLogger(TaskServlet.class.getName());
    private TaskDAO taskDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
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
                showAddTaskForm(request, response);
                break;
            case "/edit":
                showEditTaskForm(request, response);
                break;
            case "/view":
                viewTask(request, response);
                break;
            case "/delete":
                deleteTask(request, response);
                break;
            case "/filter":
                filterTasks(request, response);
                break;
            default:
                listTasks(request, response);
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
                addTask(request, response);
                break;
            case "/edit":
                updateTask(request, response);
                break;
            case "/status":
                updateTaskStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/tasks");
                break;
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        List<Task> tasks = taskDAO.getTasksByUserId(userId);
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("tasks", tasks);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/task-list.jsp").forward(request, response);
    }

    private void showAddTaskForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/task-form.jsp").forward(request, response);
    }

    private void showEditTaskForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int taskId = Integer.parseInt(request.getParameter("id"));

        Task task = taskDAO.getTaskById(taskId);

        if (task != null && task.getUserId() == userId) {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("task", task);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/task-form.jsp").forward(request, response);
        } else {
            logger.warning("Task not found or does not belong to the user");
            response.sendRedirect(request.getContextPath() + "/tasks");
        }
    }

    private void viewTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int taskId = Integer.parseInt(request.getParameter("id"));

        Task task = taskDAO.getTaskById(taskId);

        if (task != null && task.getUserId() == userId) {
            Category category = categoryDAO.getCategoryById(task.getCategoryId());
            request.setAttribute("task", task);
            request.setAttribute("category", category);
            request.getRequestDispatcher("/views/task-view.jsp").forward(request, response);
        } else {
            logger.warning("Task not found or does not belong to the user");
            response.sendRedirect(request.getContextPath() + "/tasks");
        }
    }

    private void addTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String dueDate = request.getParameter("dueDate");

        Task task = new Task();
        task.setUserId(userId);
        task.setTitle(title);
        task.setDescription(description);
        task.setCategoryId(categoryId);
        task.setStatus(Task.TaskStatus.PENDING);

        if (dueDate != null && !dueDate.isEmpty()) {
            task.setDueDate(Date.valueOf(dueDate));
        }

        boolean success = taskDAO.createTask(task);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/tasks");
        } else {
            logger.severe("Failed to create task");
            request.setAttribute("errorMessage", "Failed to create task");
            showAddTaskForm(request, response);
        }
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int taskId = Integer.parseInt(request.getParameter("taskId"));

        Task task = taskDAO.getTaskById(taskId);

        if (task != null && task.getUserId() == userId) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String statusStr = request.getParameter("status");
            String dueDate = request.getParameter("dueDate");

            task.setTitle(title);
            task.setDescription(description);
            task.setCategoryId(categoryId);

            if (statusStr != null && !statusStr.isEmpty()) {
                task.setStatus(Task.TaskStatus.valueOf(statusStr));
            }

            if (dueDate != null && !dueDate.isEmpty()) {
                task.setDueDate(Date.valueOf(dueDate));
            }

            boolean success = taskDAO.updateTask(task);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/tasks");
            } else {
                logger.severe("Failed to update task");
                request.setAttribute("errorMessage", "Failed to update task");
                showEditTaskForm(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/tasks");
        }
    }

    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        String statusStr = request.getParameter("status");

        Task.TaskStatus status = Task.TaskStatus.valueOf(statusStr);

        boolean success = taskDAO.updateTaskStatus(taskId, userId, status);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/tasks");
        } else {
            logger.severe("Failed to update task status");
            request.setAttribute("errorMessage", "Failed to update task status");
            listTasks(request, response);
        }
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        int taskId = Integer.parseInt(request.getParameter("id"));

        boolean success = taskDAO.deleteTask(taskId, userId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/tasks");
        } else {
            logger.severe("Failed to delete task");
            request.setAttribute("errorMessage", "Failed to delete task");
            listTasks(request, response);
        }
    }

    private void filterTasks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (int) request.getSession().getAttribute("userId");
        String statusStr = request.getParameter("status");
        String categoryIdStr = request.getParameter("categoryId");

        List<Task> tasks;

        if (statusStr != null && !statusStr.isEmpty()) {
            Task.TaskStatus status = Task.TaskStatus.valueOf(statusStr);
            tasks = taskDAO.getTasksByUserIdAndStatus(userId, status);
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            tasks = taskDAO.getTasksByUserIdAndCategoryId(userId, categoryId);
        } else {
            tasks = taskDAO.getTasksByUserId(userId);
        }

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("tasks", tasks);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedStatus", statusStr);
        request.setAttribute("selectedCategoryId", categoryIdStr);
        request.getRequestDispatcher("/views/task-list.jsp").forward(request, response);
    }
}
