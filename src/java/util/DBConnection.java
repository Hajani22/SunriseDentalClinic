package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton Pattern. One application-level DBConnection manager is shared by
 * the DAOs.
 */
public final class DBConnection {

    private static final String URL
            = "jdbc:mysql://localhost:3306/sunrise_dental"
            + "?useSSL=false"
            + "&serverTimezone=UTC"
            + "&allowPublicKeyRetrieval=true"
            + "&useUnicode=true"
            + "&characterEncoding=UTF-8";

    private static final String USER = "root";
    private static final String PASSWORD = "";

    private static final DBConnection INSTANCE
            = new DBConnection();

    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(
                    "MySQL JDBC Driver not found: "
                    + e.getMessage()
            );
        }
    }

    public static DBConnection getInstance() {
        return INSTANCE;
    }

    public Connection openConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }

    /**
     * Backward-compatible helper so existing DAO classes continue to work
     * without changing every SQL statement.
     */
    public static Connection getConnection()
            throws SQLException {

        return getInstance().openConnection();
    }
}
