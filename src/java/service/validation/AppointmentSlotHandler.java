package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;

public class AppointmentSlotHandler
        extends AbstractAppointmentValidationHandler {

    @Override
    protected void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        if (appointmentDAO.isSlotBooked(
                appointment.getDoctorId(),
                appointment.getAppointmentDate(),
                appointment.getAppointmentTime())) {

            throw new IllegalArgumentException(
                    "The selected dentist is already booked "
                    + "for this time slot."
            );
        }
    }
}
