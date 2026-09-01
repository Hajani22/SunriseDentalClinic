package service;

import model.PatientFeedback;

import java.sql.SQLException;
import java.util.List;

public interface PatientFeedbackService {

    boolean submitFeedback(
            PatientFeedback feedback)
            throws SQLException;

    boolean hasFeedback(
            int appointmentId,
            int patientId)
            throws SQLException;

    List<PatientFeedback> getPatientFeedback(
            int patientId)
            throws SQLException;

    List<PatientFeedback> getAllFeedback()
            throws SQLException;
}
