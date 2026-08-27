package service.impl;

import dao.NotificationDAO;
import dao.impl.NotificationDAOImpl;
import service.NotificationService;
import java.sql.SQLException;
import java.util.List;

/**
 * Notification Service Implementation.
 *
 * Design Pattern Support: - Observer Pattern - Decorator Pattern
 *
 * This class contains the business/service logic for creating and retrieving
 * notifications.
 */
public class NotificationServiceImpl
        implements NotificationService {

    private final NotificationDAO notificationDAO;

    public NotificationServiceImpl() {
        this.notificationDAO
                = new NotificationDAOImpl();
    }

    @Override
    public boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        /*
         * Basic validation
         */
        if (userId <= 0) {
            return false;
        }

        if (role == null
                || role.trim().isEmpty()) {
            return false;
        }

        if (title == null
                || title.trim().isEmpty()) {
            return false;
        }

        if (message == null
                || message.trim().isEmpty()) {
            return false;
        }

        /*
         * Store notification using DAO.
         */
        return notificationDAO.create(
                userId,
                role.trim(),
                title.trim(),
                message.trim(),
                appointmentId
        );
    }

    @Override
    public List<String[]> getForUser(
            int userId,
            String role)
            throws SQLException {

        if (userId <= 0) {
            return java.util.Collections.emptyList();
        }

        if (role == null
                || role.trim().isEmpty()) {

            return java.util.Collections.emptyList();
        }

        return notificationDAO.getForUser(
                userId,
                role.trim()
        );
    }
}
