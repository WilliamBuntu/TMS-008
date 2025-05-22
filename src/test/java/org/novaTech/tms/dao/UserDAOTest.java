package org.novaTech.tms.dao;

import org.novaTech.tms.model.User;
import org.novaTech.tms.util.DatabaseUtil;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import io.github.cdimascio.dotenv.Dotenv;

import java.sql.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserDAOTest {

    private UserDAO userDAO;
    private static String testUsername;
    private static String testPassword;
    private static String testEmail;
    private static String testWrongPassword;
    @Mock
    private Connection mockConnection;
    @Mock
    private PreparedStatement mockPreparedStatement;
    @Mock
    private ResultSet mockResultSet;

    private MockedStatic<DatabaseUtil> mockedDatabaseUtil;


    @BeforeAll
    static void setUpEnvironment() {
        // Load environment variables from .env file
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
        testUsername = dotenv.get("TESTING_USERNAME");
        testPassword = dotenv.get("TESTING_PASSWORD");
        testEmail = dotenv.get("TESTING_EMAIL");
        testWrongPassword = dotenv.get("TESTING_WRONG_PASSWORD");
    }

    @BeforeEach
    void setUp() {
        userDAO = new UserDAO();
        mockedDatabaseUtil = Mockito.mockStatic(DatabaseUtil.class);
        mockedDatabaseUtil.when(DatabaseUtil::getConnection).thenReturn(mockConnection);
    }

    @AfterEach
    void tearDown() {
        mockedDatabaseUtil.close();
    }

    @Test
    void createUser_Success() throws SQLException {
        // Arrange
        User user = new User();
        user.setUsername(testUsername);
        user.setEmail(testEmail);
        user.setPassword(testPassword);

        when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                .thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        boolean result = userDAO.createUser(user);

        // Assert
        assertTrue(result);
        assertEquals(1, user.getUserId());
        verify(mockPreparedStatement).setString(1, testUsername);
        verify(mockPreparedStatement).setString(2, testEmail);
        verify(mockPreparedStatement).setString(3, testPassword);
        verify(mockPreparedStatement).executeUpdate();
    }

    @Test
    void createUser_Failure() throws SQLException {
        // Arrange
        User user = new User();
        user.setUsername(testUsername);
        user.setEmail(testEmail);
        user.setPassword(testPassword);

        final var preparedStatementOngoingStubbing = when(mockConnection.prepareStatement(anyString(), eq(Statement.RETURN_GENERATED_KEYS)))
                .thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = userDAO.createUser(user);

        // Assert
        assertFalse(result);
        verify(mockPreparedStatement).executeUpdate();
    }

    @Test
    void getUserByUsername_Found() throws SQLException {
        // Arrange
        String username = testUsername;
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("user_id")).thenReturn(1);
        when(mockResultSet.getString("username")).thenReturn(username);
        when(mockResultSet.getString("email")).thenReturn(testEmail);
        when(mockResultSet.getString("password")).thenReturn(testPassword);

        // Act
        User result = userDAO.getUserByUsername(username);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getUserId());
        assertEquals(username, result.getUsername());
        assertEquals(testEmail, result.getEmail());
        verify(mockPreparedStatement).setString(1, username);
    }

    @Test
    void getUserByUsername_NotFound() throws SQLException {
        // Arrange
        String username = testUsername;
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        // Act
        User result = userDAO.getUserByUsername(username);

        // Assert
        assertNull(result);
        verify(mockPreparedStatement).setString(1, username);
    }

    @Test
    void authenticateUser_Success() throws SQLException {
        // Arrange
        String username = testUsername;
        String password = testPassword;
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("user_id")).thenReturn(1);
        when(mockResultSet.getString("username")).thenReturn(username);
        when(mockResultSet.getString("email")).thenReturn(testEmail);
        when(mockResultSet.getString("password")).thenReturn(password);

        // Act
        User result = userDAO.authenticateUser(username, password);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getUserId());
        assertEquals(username, result.getUsername());
        verify(mockPreparedStatement).setString(1, username);
        verify(mockPreparedStatement).setString(2, password);
    }

    @Test
    void authenticateUser_Failure() throws SQLException {
        // Arrange
        String username = testUsername;
        String password = testWrongPassword;
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);

        // Act
        User result = userDAO.authenticateUser(username, password);

        // Assert
        assertNull(result);
        verify(mockPreparedStatement).setString(1, username);
        verify(mockPreparedStatement).setString(2, password);
    }
}