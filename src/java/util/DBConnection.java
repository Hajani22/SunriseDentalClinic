package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Singleton Design Pattern.
 *
 * Provides one application-level DBConnection manager.
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
     * Backward-compatible method for existing DAO classes.
     */
    public static Connection getConnection()
            throws SQLException {

        return getInstance().openConnection();
    }
}
