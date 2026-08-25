package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

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

    private DBConnection() {
    }

    static {
        try {
            Class.forName(
                    "com.mysql.cj.jdbc.Driver"
            );
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                    "MySQL JDBC Driver not found.",
                    e
            );
        }
    }

    public static Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
        );
    }
}
