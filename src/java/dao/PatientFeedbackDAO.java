package dao;

import model.PatientFeedback;

import java.sql.SQLException;
import java.util.List;

public interface PatientFeedbackDAO {

    /*
     * Add new feedback.
     */
    boolean addFeedback(
            PatientFeedback feedback)
            throws SQLException;


    /*
     * Check whether feedback already exists
     * for the appointment and patient.
     */
    boolean hasFeedback(
            int appointmentId,
            int patientId)
            throws SQLException;


    /*
     * Get all feedback submitted by one patient.
     */
    List<PatientFeedback> getPatientFeedback(
            int patientId)
            throws SQLException;


    /*
     * Get all feedback for administrators.
     */
    List<PatientFeedback> getAllFeedback()
            throws SQLException;


    /*
     * IMPORTANT:
     *
     * Convert the user-facing appointment number
     * into the internal appointment ID.
     *
     * Example:
     *
     * SDC-F3B3A0AB
     *       ↓
     * appointments.id = 10
     */
    int findAppointmentIdByNumberAndPatient(
            String appointmentNo,
            int patientId)
            throws SQLException;
}
