package dao;

import model.MedicalHistory;

import java.sql.SQLException;
import java.util.List;

public interface MedicalHistoryDAO {

    List<MedicalHistory> getByPatientId(
            int patientId
    ) throws SQLException;

    List<MedicalHistory> getByAppointmentId(
            int appointmentId
    ) throws SQLException;

    boolean add(
            MedicalHistory history
    ) throws SQLException;

    boolean update(
            MedicalHistory history
    ) throws SQLException;

    MedicalHistory getById(
            int id
    ) throws SQLException;
}
