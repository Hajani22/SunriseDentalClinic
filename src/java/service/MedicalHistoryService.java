package service;

import model.MedicalHistory;

import java.sql.SQLException;
import java.util.List;

public interface MedicalHistoryService {

    List<MedicalHistory> getPatientHistory(
            int patientId
    ) throws SQLException;

    List<MedicalHistory> getAppointmentHistory(
            int appointmentId
    ) throws SQLException;

    MedicalHistory getById(
            int id
    ) throws SQLException;

    boolean addHistory(
            MedicalHistory history
    ) throws SQLException;

    boolean updateHistory(
            MedicalHistory history
    ) throws SQLException;
}
