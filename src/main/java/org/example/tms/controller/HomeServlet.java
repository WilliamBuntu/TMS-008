package org.example.tms.controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.tms.dao.TaskDAO;
import org.example.tms.model.Task;

import java.io.IOException;
import java.util.List;

@WebServlet({"/home", "/"})
public class HomeServlet extends HttpServlet {
    private TaskDAO taskDAO;

    @Override
    public void init() {
        taskDAO = new TaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");

            // Get tasks due today
            List<Task> todayTasks = taskDAO.getTasksDueToday(userId);
            request.setAttribute("todayTasks", todayTasks);

            // Get pending tasks
            List<Task> pendingTasks = taskDAO.getTasksByUserIdAndStatus(userId, Task.TaskStatus.PENDING);
            request.setAttribute("pendingTasks", pendingTasks);

            request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/login");
        }
    }
}