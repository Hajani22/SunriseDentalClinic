package service.validation;

import dao.AppointmentDAO;
import dao.DoctorLeaveDAO;
import dao.impl.DoctorLeaveDAOImpl;

import model.Appointment;

import java.sql.Date;
import java.sql.SQLException;

public class DoctorLeaveHandler
        extends AbstractAppointmentValidationHandler {

    private final DoctorLeaveDAO leaveDAO
            = new DoctorLeaveDAOImpl();

    @Override
    protected void validateCurrent(
            Appointment appointment,
            AppointmentDAO appointmentDAO)
            throws SQLException {

        if (appointment == null) {

            return;
        }

        Date date
                = Date.valueOf(
                        appointment
                                .getAppointmentDate()
                );

        boolean onLeave
                = leaveDAO.isDoctorOnLeave(
                        appointment.getDoctorId(),
                        date
                );

        if (onLeave) {

            throw new IllegalArgumentException(
                    "The selected dentist is on leave "
                    + "on the selected date. "
                    + "Please choose another date or dentist."
            );
        }
    }
}
