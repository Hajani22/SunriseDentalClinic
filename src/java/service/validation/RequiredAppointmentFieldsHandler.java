package service.validation;

import dao.AppointmentDAO;
import model.Appointment;

import java.sql.SQLException;

public class RequiredAppointmentFieldsHandler
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

        if (appointment.getPatientId() <= 0) {
            throw new IllegalArgumentException(
                    "Invalid patient."
            );
        }

        if (appointment.getDoctorId() <= 0) {
            throw new IllegalArgumentException(
                    "Please select a dentist."
            );
        }

        if (isBlank(
                appointment.getPatientName())) {

            throw new IllegalArgumentException(
                    "Patient name is required."
            );
        }

        if (isBlank(
                appointment.getPatientPhone())) {

            throw new IllegalArgumentException(
                    "Contact number is required."
            );
        }

        if (isBlank(
                appointment.getTreatmentType())) {

            throw new IllegalArgumentException(
                    "Treatment type is required."
            );
        }

        if (isBlank(
                appointment.getAppointmentDate())) {

            throw new IllegalArgumentException(
                    "Appointment date is required."
            );
        }

        if (isBlank(
                appointment.getAppointmentTime())) {

            throw new IllegalArgumentException(
                    "Appointment time is required."
            );
        }
    }

    private boolean isBlank(String value) {
        return value == null
                || value.trim().isEmpty();
    }
}