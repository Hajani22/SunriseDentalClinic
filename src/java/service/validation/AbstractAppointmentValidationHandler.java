package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;

public abstract class AbstractAppointmentValidationHandler
        implements AppointmentValidationHandler {

    private AppointmentValidationHandler next;

    @Override
    public AppointmentValidationHandler setNext(
            AppointmentValidationHandler next) {

        this.next = next;
        return next;
    }

    @Override
    public final void validate(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        validateCurrent(
                appointment,
                appointmentDAO
        );

        if (next != null) {
            next.validate(
                    appointment,
                    appointmentDAO
            );
        }
    }

    protected abstract void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO
    ) throws SQLException;
}
