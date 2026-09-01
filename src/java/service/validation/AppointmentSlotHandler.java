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

        if (appointment == null) {

            throw new IllegalArgumentException(
                    "Appointment details are required."
            );
        }

        // -----------------------------------------------------
        // CHECK EXISTING ACTIVE APPOINTMENT
        //
        // Same:
        //   Doctor
        //   Date
        //   Time
        //
        // cannot be booked again.
        // -----------------------------------------------------
        boolean alreadyBooked
                = appointmentDAO.isSlotBooked(
                        appointment.getDoctorId(),
                        appointment.getAppointmentDate(),
                        appointment.getAppointmentTime()
                );

        if (alreadyBooked) {

            throw new IllegalArgumentException(
                    "The selected dentist already has an appointment at the selected date and time. Please choose another time."
            );
        }
    }
}
