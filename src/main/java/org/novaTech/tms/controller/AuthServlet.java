package org.novaTech.tms.controller;
import org.novaTech.tms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.novaTech.tms.dao.UserDAO;
import org.novaTech.tms.util.CustomLogger;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private static final Logger logger = CustomLogger.createLogger(AuthServlet.class.getName());
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
                break;
        }
    }

    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Simple validation
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            logger.info("Invalid username or password");
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            response.sendRedirect(request.getContextPath() + "/HomeServlet");
        } else {
            logger.info("Invalid username or password");
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Simple validation
        if (username == null || username.isEmpty() ||
                email == null || email.isEmpty() ||
                password == null || password.isEmpty() ||
                !password.equals(confirmPassword)) {
                 logger.info("Invalid registration");
            request.setAttribute("errorMessage", "All fields are required and passwords must match");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            logger.warning("Username already exists");
            request.setAttribute("errorMessage", "Username already exists");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(password); // In production, password should be hashed

        boolean success = userDAO.createUser(newUser);

        if (success) {
            logger.info("Registration successful");
            request.setAttribute("successMessage", "Registration successful! Please login.");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        } else {
            logger.severe("Registration failed");
            request.setAttribute("errorMessage", "Registration failed");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }
}