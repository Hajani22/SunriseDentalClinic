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

        
        if (isBlank(
                appointment.getPatientName()
        )) {

            throw new IllegalArgumentException(
                    "Patient name is required."
            );
        }
        if (appointment.getDoctorId() <= 0) {

            throw new IllegalArgumentException(
                    "Please select a dentist."
            );
        }
        if (isBlank(
                appointment.getPatientPhone()
        )) {

            throw new IllegalArgumentException(
                    "Phone number is required."
            );
        }

        String phone
                = appointment
                        .getPatientPhone()
                        .replaceAll(
                                "[^0-9]",
                                ""
                        );
        if (!phone.matches(
                "^[0-9]{9,12}$"
        )) {
            throw new IllegalArgumentException(
                    "Please enter a valid phone number."
            );
        }
        if (isBlank(
                appointment.getPatientAddress()
        )) {

            throw new IllegalArgumentException(
                    "Address is required."
            );
        }

        if (appointment
                .getPatientAddress()
                .trim()
                .length() < 5) {

            throw new IllegalArgumentException(
                    "Address must contain at least 5 characters."
            );
        }

        if (appointment
                .getPatientAddress()
                .trim()
                .length() > 255) {

            throw new IllegalArgumentException(
                    "Address cannot exceed 255 characters."
            );
        }

        // -----------------------------------------------------
        // TREATMENT
        // -----------------------------------------------------
        if (isBlank(
                appointment.getTreatmentType()
        )) {

            throw new IllegalArgumentException(
                    "Treatment type is required."
            );
        }

        // -----------------------------------------------------
        // DATE
        // -----------------------------------------------------
        if (isBlank(
                appointment.getAppointmentDate()
        )) {

            throw new IllegalArgumentException(
                    "Appointment date is required."
            );
        }

        // -----------------------------------------------------
        // TIME
        // -----------------------------------------------------
        if (isBlank(
                appointment.getAppointmentTime()
        )) {

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
