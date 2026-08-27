package service.observer;

import java.sql.SQLException;

public interface AppointmentObserver {

    void update(
            AppointmentEvent event
    ) throws SQLException;
}