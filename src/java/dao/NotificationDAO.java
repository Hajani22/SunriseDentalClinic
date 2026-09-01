package dao;

import java.sql.SQLException;
import java.util.List;

public interface NotificationDAO {

    boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId
    ) throws SQLException;

    List<String[]> getForUser(
            int userId,
            String role
    ) throws SQLException;

    /**
     * Returns IDs of users belonging to the supplied role. Used by the feedback
     * workflow to notify administrators.
     */
    List<Integer> getUserIdsByRole(
            String role
    ) throws SQLException;
}
