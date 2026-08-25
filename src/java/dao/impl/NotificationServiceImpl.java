package service.impl;

import dao.NotificationDAO;
import dao.impl.NotificationDAOImpl;

import service.NotificationService;

import java.sql.SQLException;
import java.util.List;

public class NotificationServiceImpl
        implements NotificationService {

    private final NotificationDAO dao
            = new NotificationDAOImpl();

    @Override
    public boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        return dao.create(
                userId,
                role,
                title,
                message,
                appointmentId
        );
    }

    @Override
    public List<String[]> getForUser(
            int userId,
            String role)
            throws SQLException {

        return dao.getForUser(
                userId,
                role
        );
    }
}
