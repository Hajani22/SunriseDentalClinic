package service.validation;

import dao.AppointmentDAO;
import dao.DoctorScheduleDAO;
import dao.impl.DoctorScheduleDAOImpl;

import model.Appointment;

import java.sql.SQLException;

public class DoctorAvailabilityHandler
        extends AbstractAppointmentValidationHandler {

    private final DoctorScheduleDAO scheduleDAO
            = new DoctorScheduleDAOImpl();

    @Override
    protected void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        boolean available
                = scheduleDAO.isDoctorAvailable(
                        appointment.getDoctorId(),
                        appointment.getAppointmentDate(),
                        appointment.getAppointmentTime()
                );

        if (!available) {

            throw new IllegalArgumentException(
                    "The selected dentist is not "
                    + "available at the selected date "
                    + "and time."
            );
        }
    }
}
