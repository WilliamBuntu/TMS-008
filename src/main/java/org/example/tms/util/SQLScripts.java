package org.example.tms.util;

public class SQLScripts {

    // User table
    public static final String CREATE_USER_TABLE =
        "CREATE TABLE IF NOT EXISTS users (" +
        "user_id SERIAL PRIMARY KEY," +
        "username VARCHAR(50) NOT NULL UNIQUE," +
        "email VARCHAR(100) NOT NULL UNIQUE," +
        "password VARCHAR(255) NOT NULL," +
        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
        ");";

    // Category table
    public static final String CREATE_CATEGORY_TABLE =
        "CREATE TABLE IF NOT EXISTS category (" +
        "category_id SERIAL PRIMARY KEY," +
        "name VARCHAR(50) NOT NULL UNIQUE," +
        "description VARCHAR(255)" +
        ");";

    // Task table
    public static final String CREATE_TASK_TABLE =
        "CREATE TABLE IF NOT EXISTS task (" +
        "task_id SERIAL PRIMARY KEY," +
        "user_id INT NOT NULL," +
        "category_id INT NOT NULL," +
        "title VARCHAR(100) NOT NULL," +
        "description TEXT," +
        "status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))," +
        "due_date DATE," +
        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
        "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE," +
        "FOREIGN KEY (category_id) REFERENCES category(category_id)" +
        ");";

    // Insert default categories (PostgreSQL style)
    public static final String INSERT_DEFAULT_CATEGORIES =
        "INSERT INTO category (name, description) VALUES " +
        "('Work', 'Work-related tasks and projects')," +
        "('Personal', 'Personal tasks and errands')," +
        "('Study', 'Educational and learning tasks')," +
        "('Health', 'Health and fitness related tasks') " +
        "ON CONFLICT (name) DO NOTHING;";
}
