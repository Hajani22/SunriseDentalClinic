package service.observer;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentEventPublisher {

    private static final Logger LOGGER
            = Logger.getLogger(
                    AppointmentEventPublisher.class.getName()
            );

    private final List<AppointmentObserver> observers
            = new ArrayList<>();

    public void subscribe(
            AppointmentObserver observer) {

        if (observer != null
                && !observers.contains(observer)) {

            observers.add(observer);
        }
    }

    public void publish(
            AppointmentEvent event) {

        for (AppointmentObserver observer : observers) {
            try {
                observer.update(event);
                
            } catch (SQLException e) {
                LOGGER.log(
                        Level.WARNING,
                        "Appointment observer failed.",
                        e
                );
            } catch (RuntimeException e) {
                LOGGER.log(
                        Level.WARNING,
                        "Appointment observer error.",
                        e
                );
            }
        }
    }
}
