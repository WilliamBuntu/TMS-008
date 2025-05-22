package org.novaTech.tms.dao;

    import org.novaTech.tms.model.Category;
    import org.novaTech.tms.util.CustomLogger;
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
    import java.util.logging.Logger;

    import static org.junit.jupiter.api.Assertions.*;
    import static org.mockito.ArgumentMatchers.*;
    import static org.mockito.Mockito.*;

    @ExtendWith(MockitoExtension.class)
    class CategoryDAOTest {
        private static final Logger logger = CustomLogger.createLogger(CategoryDAOTest.class.getName());
        private CategoryDAO categoryDAO;

        @Mock
        private Connection mockConnection;
        @Mock
        private PreparedStatement mockPreparedStatement;
        @Mock
        private Statement mockStatement;
        @Mock
        private ResultSet mockResultSet;

        private MockedStatic<DatabaseUtil> mockedDatabaseUtil;

        @BeforeEach
        void setUp() {
            categoryDAO = new CategoryDAO();
            mockedDatabaseUtil = Mockito.mockStatic(DatabaseUtil.class);
            mockedDatabaseUtil.when(DatabaseUtil::getConnection).thenReturn(mockConnection);
        }

        @AfterEach
        void tearDown() {
            mockedDatabaseUtil.close();
        }

        @Test
        void createCategory_Success() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setName("Test Category");
            category.setDescription("Test Description");

            when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                    .thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);
            when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true);
            when(mockResultSet.getInt(1)).thenReturn(1);

            // Act
            boolean result = categoryDAO.createCategory(category);

            // Assert
            assertTrue(result);
            assertEquals(1, category.getCategoryId());
            verify(mockPreparedStatement).setString(1, "Test Category");
            verify(mockPreparedStatement).setString(2, "Test Description");
            verify(mockPreparedStatement).executeUpdate();
        }

        @Test
        void createCategory_Failure() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setName("Test Category");
            category.setDescription("Test Description");

            when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                    .thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = categoryDAO.createCategory(category);

            // Assert
            assertFalse(result);
            verify(mockPreparedStatement).executeUpdate();
            logger.severe("Failed to create category because no rows were affected.");
        }

        @Test
        void createCategory_Exception() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setName("Test Category");
            category.setDescription("Test Description");

            when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                    .thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenThrow(new SQLException("Database error"));

            // Act
            boolean result = categoryDAO.createCategory(category);

            // Assert
            assertFalse(result);
            verify(mockPreparedStatement).executeUpdate();
        }

        @Test
        void getCategoryById_Found() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true);
            when(mockResultSet.getInt("category_id")).thenReturn(categoryId);
            when(mockResultSet.getString("name")).thenReturn("Test Category");
            when(mockResultSet.getString("description")).thenReturn("Test Description");

            // Act
            Category result = categoryDAO.getCategoryById(categoryId);

            // Assert
            assertNotNull(result);
            assertEquals(categoryId, result.getCategoryId());
            assertEquals("Test Category", result.getName());
            assertEquals("Test Description", result.getDescription());
            verify(mockPreparedStatement).setInt(1, categoryId);
        }

        @Test
        void getCategoryById_NotFound() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(false);

            // Act
            Category result = categoryDAO.getCategoryById(categoryId);

            // Assert
            assertNull(result);
            verify(mockPreparedStatement).setInt(1, categoryId);
            logger.severe("Category with ID " + categoryId + " not found.");
        }

        @Test
        void getCategoryById_Exception() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeQuery()).thenThrow(new SQLException("Database error"));

            // Act
            Category result = categoryDAO.getCategoryById(categoryId);

            // Assert
            assertNull(result);
            verify(mockPreparedStatement).setInt(1, categoryId);
        }

        @Test
        void getAllCategories_Success() throws SQLException {
            // Arrange
            when(mockConnection.createStatement()).thenReturn(mockStatement);
            when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(true, true, false);
            when(mockResultSet.getInt("category_id")).thenReturn(1, 2);
            when(mockResultSet.getString("name")).thenReturn("Category 1", "Category 2");
            when(mockResultSet.getString("description")).thenReturn("Description 1", "Description 2");

            // Act
            List<Category> categories = categoryDAO.getAllCategories();

            // Assert
            assertEquals(2, categories.size());
            assertEquals(1, categories.getFirst().getCategoryId());
            assertEquals("Category 1", categories.get(0).getName());
            assertEquals("Description 1", categories.get(0).getDescription());
            assertEquals(2, categories.get(1).getCategoryId());
            assertEquals("Category 2", categories.get(1).getName());
            assertEquals("Description 2", categories.get(1).getDescription());
        }

        @Test
        void getAllCategories_EmptyList() throws SQLException {
            // Arrange
            when(mockConnection.createStatement()).thenReturn(mockStatement);
            when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
            when(mockResultSet.next()).thenReturn(false);

            // Act
            List<Category> categories = categoryDAO.getAllCategories();

            // Assert
            assertTrue(categories.isEmpty());
            logger.info("Categories list is empty.");
        }

        @Test
        void getAllCategories_Exception() throws SQLException {
            // Arrange
            when(mockConnection.createStatement()).thenReturn(mockStatement);
            when(mockStatement.executeQuery(anyString())).thenThrow(new SQLException("Database error"));

            // Act
            List<Category> categories = categoryDAO.getAllCategories();

            // Assert
            assertTrue(categories.isEmpty());
        }

        @Test
        void updateCategory_Success() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setCategoryId(1);
            category.setName("Updated Category");
            category.setDescription("Updated Description");

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);

            // Act
            boolean result = categoryDAO.updateCategory(category);

            // Assert
            assertTrue(result);
            verify(mockPreparedStatement).setString(1, "Updated Category");
            verify(mockPreparedStatement).setString(2, "Updated Description");
            verify(mockPreparedStatement).setInt(3, 1);
        }

        @Test
        void updateCategory_Failure() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setCategoryId(1);
            category.setName("Updated Category");
            category.setDescription("Updated Description");

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = categoryDAO.updateCategory(category);

            // Assert
            assertFalse(result);
            verify(mockPreparedStatement).executeUpdate();
        }

        @Test
        void updateCategory_Exception() throws SQLException {
            // Arrange
            Category category = new Category();
            category.setCategoryId(1);
            category.setName("Updated Category");
            category.setDescription("Updated Description");

            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenThrow(new SQLException("Database error"));

            // Act
            boolean result = categoryDAO.updateCategory(category);

            // Assert
            assertFalse(result);
        }

        @Test
        void deleteCategory_Success() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(1);

            // Act
            boolean result = categoryDAO.deleteCategory(categoryId);

            // Assert
            assertTrue(result);
            verify(mockPreparedStatement).setInt(1, categoryId);
        }

        @Test
        void deleteCategory_Failure() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenReturn(0);

            // Act
            boolean result = categoryDAO.deleteCategory(categoryId);

            // Assert
            assertFalse(result);
            verify(mockPreparedStatement).setInt(1, categoryId);
        }

        @Test
        void deleteCategory_Exception() throws SQLException {
            // Arrange
            int categoryId = 1;
            when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
            when(mockPreparedStatement.executeUpdate()).thenThrow(new SQLException("Database error"));

            // Act
            boolean result = categoryDAO.deleteCategory(categoryId);

            // Assert
            assertFalse(result);
            verify(mockPreparedStatement).setInt(1, categoryId);
        }
    }