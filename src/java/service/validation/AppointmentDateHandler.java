package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class AppointmentDateHandler
        extends AbstractAppointmentValidationHandler {

    @Override
    protected void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        final LocalDate date;

        try {

            date = LocalDate.parse(
                    appointment.getAppointmentDate()
            );

        } catch (DateTimeParseException e) {

            throw new IllegalArgumentException(
                    "Invalid appointment date."
            );
        }

        if (date.isBefore(LocalDate.now())) {

            throw new IllegalArgumentException(
                    "Appointment date cannot be in the past."
            );
        }
    }
}
