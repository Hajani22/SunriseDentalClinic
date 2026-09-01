package service.decorator;

import service.NotificationService;

import java.sql.SQLException;
import java.util.List;

public abstract class NotificationServiceDecorator
        implements NotificationService {

    protected final NotificationService wrappedService;

    protected NotificationServiceDecorator(
            NotificationService wrappedService) {

        if (wrappedService == null) {

            throw new IllegalArgumentException(
                    "Notification service cannot be null."
            );
        }
        this.wrappedService = wrappedService;
    }

    @Override
    public boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        return wrappedService.create(
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

        return wrappedService.getForUser(
                userId,
                role
        );
    }
}