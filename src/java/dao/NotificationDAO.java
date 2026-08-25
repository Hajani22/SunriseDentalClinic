package dao;

import java.sql.SQLException;
import java.util.List;

public interface NotificationDAO {

    boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException;

    boolean createForRole(
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException;

    List<String[]> getForUser(
            int userId,
            String role)
            throws SQLException;
}