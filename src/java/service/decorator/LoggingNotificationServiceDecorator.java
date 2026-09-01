package service.decorator;

import service.NotificationService;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoggingNotificationServiceDecorator
        extends NotificationServiceDecorator {

    private static final Logger LOGGER
            = Logger.getLogger(
                    LoggingNotificationServiceDecorator.class.getName()
            );
    public LoggingNotificationServiceDecorator(
            NotificationService wrappedService) {

        super(wrappedService);
    }

    @Override
    public boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        LOGGER.log(
                Level.INFO,
                "Creating notification. role={0}, appointmentId={1}",
                new Object[]{
                    role,
                    appointmentId
                }
        );

        return super.create(
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

        LOGGER.log(
                Level.INFO,
                "Loading notifications. role={0}, userId={1}",
                new Object[]{
                    role,
                    userId
                }
        );

        return super.getForUser(
                userId,
                role
        );
    }
}
