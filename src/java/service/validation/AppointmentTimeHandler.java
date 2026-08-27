package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

public class AppointmentTimeHandler
        extends AbstractAppointmentValidationHandler {

    @Override
    protected void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        final LocalDate date;
        final LocalTime time;

        try {

            date = LocalDate.parse(
                    appointment.getAppointmentDate()
            );

            time = LocalTime.parse(
                    appointment.getAppointmentTime()
            );

        } catch (DateTimeParseException e) {

            throw new IllegalArgumentException(
                    "Invalid appointment date or time."
            );
        }

        if (date.equals(LocalDate.now())
                && !time.isAfter(LocalTime.now())) {

            throw new IllegalArgumentException(
                    "Appointment time must be in the future."
            );
        }
    }
}
