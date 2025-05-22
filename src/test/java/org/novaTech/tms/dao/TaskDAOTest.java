package org.novaTech.tms.dao;

    import org.novaTech.tms.model.Task;
    import org.novaTech.tms.util.DatabaseUtil;
    import org.junit.jupiter.api.AfterEach;
    import org.junit.jupiter.api.BeforeEach;
    import org.junit.jupiter.api.Test;
    import org.junit.jupiter.api.extension.ExtendWith;
    import org.mockito.Mock;
    import org.mockito.MockedStatic;
    import org.mockito.Mockito;
    import org.mockito.junit.jupiter.MockitoExtension;

    import java.sql.*;
    import java.util.List;

    import static org.junit.jupiter.api.Assertions.*;
    import static org.mockito.ArgumentMatchers.*;
    import static org.mockito.Mockito.*;

    @ExtendWith(MockitoExtension.class)
    class TaskDAOTest {

        private TaskDAO taskDAO;

        @Mock
        private Connection mockConnection;
        @Mock
        private PreparedStatement mockPreparedStatement;
        @Mock
        private ResultSet mockResultSet;

        private MockedStatic<DatabaseUtil> mockedDatabaseUtil;

        @BeforeEach
        void setUp() {
            taskDAO = new TaskDAO();
            mockedDatabaseUtil = Mockito.mockStatic(DatabaseUtil.class);
            mockedDatabaseUtil.when(DatabaseUtil::getConnection).thenReturn(mockConnection);
        }

        @AfterEach
        void tearDown() {
            mockedDatabaseUtil.close();
        }

        @Test
        void createTask_Success() throws SQLException {
            // Arrange
            Task task = new Task();
            task.setUserId(1);
            task.setCategoryId(2);
            task.setTitle("Test Task");
            task.setDescription("Test Description");
            task.setStatus(Task.TaskStatus.PENDING);
            task.setDueDate(Date.valueOf("2023-12-31"));

            final var preparedStatementOngoingStubbing = when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                    .thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);
            when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true);
            when(mockResultSet.getInt(1)).thenReturn(1);

            // Act
            boolean result = taskDAO.createTask(task);

            // Assert
            assertTrue(result);
            assertEquals(1, task.getTaskId());
            verify(mockPreparedStatement).setInt(1, 1); // userId
            verify(mockPreparedStatement).setInt(2, 2); // categoryId
            verify(mockPreparedStatement).setString(3, "Test Task");
            verify(mockPreparedStatement).setString(4, "Test Description");
            verify(mockPreparedStatement).setString(5, "PENDING");
            verify(mockPreparedStatement).setDate(6, Date.valueOf("2023-12-31"));
        }

        @Test
        void createTask_Failure() throws SQLException {
            // Arrange
            Task task = new Task();
            task.setUserId(1);
            task.setCategoryId(2);
            task.setTitle("Test Task");
            task.setDescription("Test Description");
            task.setStatus(Task.TaskStatus.PENDING);
            task.setDueDate(Date.valueOf("2023-12-31"));

            when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                    .thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = taskDAO.createTask(task);

            // Assert
            assertFalse(result);
        }

        @Test
        void getTaskById_Found() throws SQLException {
            // Arrange
            int taskId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true);

            // Mock result set values
            when(mockResultSet.getInt("task_id")).thenReturn(taskId);
            when(mockResultSet.getInt("user_id")).thenReturn(1);
            when(mockResultSet.getInt("category_id")).thenReturn(2);
            when(mockResultSet.getString("title")).thenReturn("Test Task");
            when(mockResultSet.getString("description")).thenReturn("Test Description");
            when(mockResultSet.getString("status")).thenReturn("PENDING");
            when(mockResultSet.getDate("due_date")).thenReturn(Date.valueOf("2023-12-31"));
            when(mockResultSet.getTimestamp("created_at")).thenReturn(Timestamp.valueOf("2023-01-01 12:00:00"));

            // Act
            Task result = taskDAO.getTaskById(taskId);

            // Assert
            assertNotNull(result);
            assertEquals(taskId, result.getTaskId());
            assertEquals(1, result.getUserId());
            assertEquals(2, result.getCategoryId());
            assertEquals("Test Task", result.getTitle());
            assertEquals("Test Description", result.getDescription());
            assertEquals(Task.TaskStatus.PENDING, result.getStatus());
            assertEquals(Date.valueOf("2023-12-31"), result.getDueDate());
            verify(mockPreparedStatement).setInt(1, taskId);
        }

        @Test
        void getTaskById_NotFound() throws SQLException {
            // Arrange
            int taskId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(false);

            // Act
            Task result = taskDAO.getTaskById(taskId);

            // Assert
            assertNull(result);
            verify(mockPreparedStatement).setInt(1, taskId);
        }

        @Test
        void getTasksByUserId_Success() throws SQLException {
            // Arrange
            int userId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true, true, false); // Two tasks

            // Mock result set values for first and second task
            when(mockResultSet.getInt("task_id")).thenReturn(1, 2);
            when(mockResultSet.getInt("user_id")).thenReturn(userId, userId);
            when(mockResultSet.getInt("category_id")).thenReturn(2, 3);
            when(mockResultSet.getString("title")).thenReturn("Task 1", "Task 2");
            when(mockResultSet.getString("description")).thenReturn("Description 1", "Description 2");
            when(mockResultSet.getString("status")).thenReturn("PENDING", "COMPLETED");
            when(mockResultSet.getDate("due_date")).thenReturn(Date.valueOf("2023-12-31"), Date.valueOf("2023-11-30"));
            when(mockResultSet.getTimestamp("created_at")).thenReturn(
                    Timestamp.valueOf("2023-01-01 12:00:00"),
                    Timestamp.valueOf("2023-01-02 12:00:00"));

            // Act
            List<Task> tasks = taskDAO.getTasksByUserId(userId);

            // Assert
            assertEquals(2, tasks.size());

            // Check first task
            assertEquals(1, tasks.getFirst().getTaskId());
            assertEquals(userId, tasks.getFirst().getUserId());
            assertEquals(2, tasks.getFirst().getCategoryId());
            assertEquals("Task 1", tasks.getFirst().getTitle());
            assertEquals("Description 1", tasks.getFirst().getDescription());
            assertEquals(Task.TaskStatus.PENDING, tasks.getFirst().getStatus());

            // Check second task
            assertEquals(2, tasks.get(1).getTaskId());
            assertEquals(userId, tasks.get(1).getUserId());
            assertEquals(3, tasks.get(1).getCategoryId());
            assertEquals("Task 2", tasks.get(1).getTitle());
            assertEquals("Description 2", tasks.get(1).getDescription());
            assertEquals(Task.TaskStatus.COMPLETED, tasks.get(1).getStatus());

            verify(mockPreparedStatement).setInt(1, userId);
        }

        @Test
        void getTasksByUserIdAndStatus_Success() throws SQLException {
            // Arrange
            int userId = 1;
            Task.TaskStatus status = Task.TaskStatus.PENDING;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true, false); // One task

            // Mock result set values
            when(mockResultSet.getInt("task_id")).thenReturn(1);
            when(mockResultSet.getInt("user_id")).thenReturn(userId);
            when(mockResultSet.getInt("category_id")).thenReturn(2);
            when(mockResultSet.getString("title")).thenReturn("Pending Task");
            when(mockResultSet.getString("description")).thenReturn("Description");
            when(mockResultSet.getString("status")).thenReturn("PENDING");
            when(mockResultSet.getDate("due_date")).thenReturn(Date.valueOf("2023-12-31"));
            when(mockResultSet.getTimestamp("created_at")).thenReturn(Timestamp.valueOf("2023-01-01 12:00:00"));

            // Act
            List<Task> tasks = taskDAO.getTasksByUserIdAndStatus(userId, status);

            // Assert
            assertEquals(1, tasks.size());
            assertEquals(1, tasks.getFirst().getTaskId());
            assertEquals(status, tasks.getFirst().getStatus());

            verify(mockPreparedStatement).setInt(1, userId);
            verify(mockPreparedStatement).setString(2, status.toString());
        }

        @Test
        void getTasksByUserIdAndCategoryId_Success() throws SQLException {
            // Arrange
            int userId = 1;
            int categoryId = 2;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true, false); // One task

            // Mock result set values
            when(mockResultSet.getInt("task_id")).thenReturn(1);
            when(mockResultSet.getInt("user_id")).thenReturn(userId);
            when(mockResultSet.getInt("category_id")).thenReturn(categoryId);
            when(mockResultSet.getString("title")).thenReturn("Category Task");
            when(mockResultSet.getString("description")).thenReturn("Description");
            when(mockResultSet.getString("status")).thenReturn("PENDING");
            when(mockResultSet.getDate("due_date")).thenReturn(Date.valueOf("2023-12-31"));
            when(mockResultSet.getTimestamp("created_at")).thenReturn(Timestamp.valueOf("2023-01-01 12:00:00"));

            // Act
            List<Task> tasks = taskDAO.getTasksByUserIdAndCategoryId(userId, categoryId);

            // Assert
            assertEquals(1, tasks.size());
            assertEquals(1, tasks.getFirst().getTaskId());
            assertEquals(categoryId, tasks.getFirst().getCategoryId());

            verify(mockPreparedStatement).setInt(1, userId);
            verify(mockPreparedStatement).setInt(2, categoryId);
        }

        @Test
        void getTasksDueToday_Success() throws SQLException {
            // Arrange
            int userId = 1;
            Date today = Date.valueOf("2023-12-01");

            mockedDatabaseUtil.when(DatabaseUtil::getCurrentDate).thenReturn(today);

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true, false); // One task

            // Mock result set values
            when(mockResultSet.getInt("task_id")).thenReturn(1);
            when(mockResultSet.getInt("user_id")).thenReturn(userId);
            when(mockResultSet.getInt("category_id")).thenReturn(2);
            when(mockResultSet.getString("title")).thenReturn("Today's Task");
            when(mockResultSet.getString("description")).thenReturn("Description");
            when(mockResultSet.getString("status")).thenReturn("PENDING");
            when(mockResultSet.getDate("due_date")).thenReturn(today);
            when(mockResultSet.getTimestamp("created_at")).thenReturn(Timestamp.valueOf("2023-01-01 12:00:00"));

            // Act
            List<Task> tasks = taskDAO.getTasksDueToday(userId);

            // Assert
            assertEquals(1, tasks.size());
            assertEquals(1, tasks.getFirst().getTaskId());
            assertEquals(today, tasks.getFirst().getDueDate());

            verify(mockPreparedStatement).setInt(1, userId);
            verify(mockPreparedStatement).setDate(2, today);
        }

        @Test
        void updateTask_Success() throws SQLException {
            // Arrange
            Task task = new Task();
            task.setTaskId(1);
            task.setUserId(1);
            task.setCategoryId(2);
            task.setTitle("Updated Task");
            task.setDescription("Updated Description");
            task.setStatus(Task.TaskStatus.IN_PROGRESS);
            task.setDueDate(Date.valueOf("2024-01-15"));

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);

            // Act
            boolean result = taskDAO.updateTask(task);

            // Assert
            assertTrue(result);
            verify(mockPreparedStatement).setInt(1, 2); // categoryId
            verify(mockPreparedStatement).setString(2, "Updated Task");
            verify(mockPreparedStatement).setString(3, "Updated Description");
            verify(mockPreparedStatement).setString(4, "IN_PROGRESS");
            verify(mockPreparedStatement).setDate(5, Date.valueOf("2024-01-15"));
            verify(mockPreparedStatement).setInt(6, 1); // taskId
            verify(mockPreparedStatement).setInt(7, 1); // userId
        }

        @Test
        void updateTask_Failure() throws SQLException {
            // Arrange
            Task task = new Task();
            task.setTaskId(1);
            task.setUserId(1);
            task.setCategoryId(2);
            task.setTitle("Updated Task");
            task.setDescription("Updated Description");
            task.setStatus(Task.TaskStatus.IN_PROGRESS);
            task.setDueDate(Date.valueOf("2024-01-15"));

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = taskDAO.updateTask(task);

            // Assert
            assertFalse(result);
        }

        @Test
        void updateTaskStatus_Success() throws SQLException {
            // Arrange
            int taskId = 1;
            int userId = 1;
            Task.TaskStatus newStatus = Task.TaskStatus.COMPLETED;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);

            // Act
            boolean result = taskDAO.updateTaskStatus(taskId, userId, newStatus);

            // Assert
            assertTrue(result);
            verify(mockPreparedStatement).setString(1, "COMPLETED");
            verify(mockPreparedStatement).setInt(2, taskId);
            verify(mockPreparedStatement).setInt(3, userId);
        }

        @Test
        void updateTaskStatus_Failure() throws SQLException {
            // Arrange
            int taskId = 1;
            int userId = 1;
            Task.TaskStatus newStatus = Task.TaskStatus.COMPLETED;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = taskDAO.updateTaskStatus(taskId, userId, newStatus);

            // Assert
            assertFalse(result);
        }

        @Test
        void deleteTask_Success() throws SQLException {
            // Arrange
            int taskId = 1;
            int userId = 1;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);

            // Act
            boolean result = taskDAO.deleteTask(taskId, userId);

            // Assert
            assertTrue(result);
            verify(mockPreparedStatement).setInt(1, taskId);
            verify(mockPreparedStatement).setInt(2, userId);
        }

        @Test
        void deleteTask_Failure() throws SQLException {
            // Arrange
            int taskId = 1;
            int userId = 1;

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = taskDAO.deleteTask(taskId, userId);

            // Assert
            assertFalse(result);
        }
    }