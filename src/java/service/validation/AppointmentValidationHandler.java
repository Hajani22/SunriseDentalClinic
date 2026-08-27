package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;

public interface AppointmentValidationHandler {

    AppointmentValidationHandler setNext(
            AppointmentValidationHandler next
    );

    void validate(
            Appointment appointment,
            AppointmentDAO appointmentDAO
    ) throws SQLException;
}
