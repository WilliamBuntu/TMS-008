package org.novaTech.tms.dao;
import org.novaTech.tms.model.Task;
import org.novaTech.tms.util.CustomLogger;
import org.novaTech.tms.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class TaskDAO {
    private static final Logger logger = CustomLogger.createLogger(TaskDAO.class.getName());
    // Create a new task
    public boolean createTask(Task task) {
        String query = "INSERT INTO task (user_id, category_id, title, description, status, due_date) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, task.getUserId());
            pstmt.setInt(2, task.getCategoryId());
            pstmt.setString(3, task.getTitle());
            pstmt.setString(4, task.getDescription());
            pstmt.setString(5, task.getStatus().toString());
            pstmt.setDate(6, task.getDueDate());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        task.setTaskId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            logger.severe("Failed to create task: " + e.getMessage());

            return false;
        }
    }
    
    // Get a task by ID
    public Task getTaskById(int taskId) {
        String query = "SELECT * FROM task WHERE task_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractTaskFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logger.severe("Failed to get task by ID: " + e.getMessage());

        }
        return null;
    }
    
    // Get all tasks for a user
    public List<Task> getTasksByUserId(int userId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM task WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(extractTaskFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Failed to get tasks by user ID: " + e.getMessage());

        }
        return tasks;
    }
    
    // Get tasks by status for a user
    public List<Task> getTasksByUserIdAndStatus(int userId, Task.TaskStatus status) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM task WHERE user_id = ? AND status = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, status.toString());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(extractTaskFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Failed to get tasks by user ID and status: " + e.getMessage());

        }
        return tasks;
    }
    
    // Get tasks by category for a user
    public List<Task> getTasksByUserIdAndCategoryId(int userId, int categoryId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM task WHERE user_id = ? AND category_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, categoryId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(extractTaskFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Failed to get tasks by user ID and category ID: " + e.getMessage());

        }
        return tasks;
    }
    
    // Get tasks due today for a user
    public List<Task> getTasksDueToday(int userId) {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT * FROM task WHERE user_id = ? AND due_date = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, userId);
            pstmt.setDate(2,DatabaseUtil.getCurrentDate());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    tasks.add(extractTaskFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            logger.severe("Failed to get tasks due today: " + e.getMessage());

        }
        return tasks;
    }
    
    // Update task
    public boolean updateTask(Task task) {
        String query = "UPDATE task SET category_id = ?, title = ?, description = ?, status = ?, due_date = ? WHERE task_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, task.getCategoryId());
            pstmt.setString(2, task.getTitle());
            pstmt.setString(3, task.getDescription());
            pstmt.setString(4, task.getStatus().toString());
            pstmt.setDate(5, task.getDueDate());
            pstmt.setInt(6, task.getTaskId());
            pstmt.setInt(7, task.getUserId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            logger.severe("Failed to update task: " + e.getMessage());

            return false;
        }
    }
    
    // Update task status
    public boolean updateTaskStatus(int taskId, int userId, Task.TaskStatus status) {
        String query = "UPDATE task SET status = ? WHERE task_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, status.toString());
            pstmt.setInt(2, taskId);
            pstmt.setInt(3, userId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
           logger.severe("Failed to update task status: " + e.getMessage());
            return false;
        }
    }
    
    // Delete task
    public boolean deleteTask(int taskId, int userId) {
        String query = "DELETE FROM task WHERE task_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, taskId);
            pstmt.setInt(2, userId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
           logger.severe("Failed to delete task: " + e.getMessage());
            return false;
        }
    }
    
    // Helper method to extract task from ResultSet
    private Task extractTaskFromResultSet(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setUserId(rs.getInt("user_id"));
        task.setCategoryId(rs.getInt("category_id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setStatus(Task.TaskStatus.valueOf(rs.getString("status")));
        task.setDueDate(rs.getDate("due_date"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        return task;
    }
}