package dao.impl;

import dao.MedicalHistoryDAO;
import model.MedicalHistory;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicalHistoryDAOImpl
        implements MedicalHistoryDAO {


    @Override
    public List<MedicalHistory> getByPatientId(
            int patientId)
            throws SQLException {


        List<MedicalHistory> list =
                new ArrayList<>();


        String sql =
                "SELECT mh.*, " +
                "CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM medical_history mh " +
                "LEFT JOIN doctors d " +
                "ON mh.doctor_id = d.id " +
                "LEFT JOIN patients p " +
                "ON mh.patient_id = p.id " +
                "WHERE mh.patient_id = ? " +
                "ORDER BY mh.visit_date DESC, mh.id DESC";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {


            ps.setInt(
                    1,
                    patientId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                while (rs.next()) {

                    list.add(
                            map(rs)
                    );

                }

            }

        }


        return list;
    }


    @Override
    public List<MedicalHistory> getByAppointmentId(
            int appointmentId)
            throws SQLException {


        List<MedicalHistory> list =
                new ArrayList<>();


        String sql =
                "SELECT mh.*, " +
                "CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM medical_history mh " +
                "LEFT JOIN doctors d " +
                "ON mh.doctor_id = d.id " +
                "LEFT JOIN patients p " +
                "ON mh.patient_id = p.id " +
                "WHERE mh.appointment_id = ? " +
                "ORDER BY mh.visit_date DESC, mh.id DESC";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {


            ps.setInt(
                    1,
                    appointmentId
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                while (rs.next()) {

                    list.add(
                            map(rs)
                    );

                }

            }

        }


        return list;
    }


    @Override
    public boolean add(
            MedicalHistory history)
            throws SQLException {


        String sql =
                "INSERT INTO medical_history " +
                "(patient_id, doctor_id, appointment_id, " +
                "visit_date, symptoms, diagnosis, treatment, " +
                "allergies, medications, medical_conditions, notes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {


            ps.setInt(
                    1,
                    history.getPatientId()
            );


            ps.setInt(
                    2,
                    history.getDoctorId()
            );


            if (history.getAppointmentId() != null) {

                ps.setInt(
                        3,
                        history.getAppointmentId()
                );

            } else {

                ps.setNull(
                        3,
                        java.sql.Types.INTEGER
                );

            }


            ps.setDate(
                    4,
                    history.getVisitDate()
            );


            ps.setString(
                    5,
                    history.getSymptoms()
            );


            ps.setString(
                    6,
                    history.getDiagnosis()
            );


            ps.setString(
                    7,
                    history.getTreatment()
            );


            ps.setString(
                    8,
                    history.getAllergies()
            );


            ps.setString(
                    9,
                    history.getMedications()
            );


            ps.setString(
                    10,
                    history.getMedicalConditions()
            );


            ps.setString(
                    11,
                    history.getNotes()
            );


            return ps.executeUpdate() > 0;
        }
    }


    @Override
    public boolean update(
            MedicalHistory history)
            throws SQLException {


        String sql =
                "UPDATE medical_history SET " +
                "visit_date = ?, " +
                "symptoms = ?, " +
                "diagnosis = ?, " +
                "treatment = ?, " +
                "allergies = ?, " +
                "medications = ?, " +
                "medical_conditions = ?, " +
                "notes = ? " +
                "WHERE id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {


            ps.setDate(
                    1,
                    history.getVisitDate()
            );


            ps.setString(
                    2,
                    history.getSymptoms()
            );


            ps.setString(
                    3,
                    history.getDiagnosis()
            );


            ps.setString(
                    4,
                    history.getTreatment()
            );


            ps.setString(
                    5,
                    history.getAllergies()
            );


            ps.setString(
                    6,
                    history.getMedications()
            );


            ps.setString(
                    7,
                    history.getMedicalConditions()
            );


            ps.setString(
                    8,
                    history.getNotes()
            );


            ps.setInt(
                    9,
                    history.getId()
            );


            return ps.executeUpdate() > 0;
        }
    }


    @Override
    public MedicalHistory getById(
            int id)
            throws SQLException {


        String sql =
                "SELECT mh.*, " +
                "CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, " +
                "CONCAT(p.first_name, ' ', p.last_name) AS patient_name " +
                "FROM medical_history mh " +
                "LEFT JOIN doctors d " +
                "ON mh.doctor_id = d.id " +
                "LEFT JOIN patients p " +
                "ON mh.patient_id = p.id " +
                "WHERE mh.id = ?";


        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    connection.prepareStatement(sql)
        ) {


            ps.setInt(
                    1,
                    id
            );


            try (
                ResultSet rs =
                        ps.executeQuery()
            ) {


                if (rs.next()) {

                    return map(rs);

                }

            }

        }


        return null;
    }


    private MedicalHistory map(
            ResultSet rs)
            throws SQLException {


        MedicalHistory history =
                new MedicalHistory();


        history.setId(
                rs.getInt("id")
        );


        history.setPatientId(
                rs.getInt("patient_id")
        );


        history.setDoctorId(
                rs.getInt("doctor_id")
        );


        int appointmentId =
                rs.getInt("appointment_id");


        if (!rs.wasNull()) {

            history.setAppointmentId(
                    appointmentId
            );

        }


        history.setVisitDate(
                rs.getDate("visit_date")
        );


        history.setSymptoms(
                rs.getString("symptoms")
        );


        history.setDiagnosis(
                rs.getString("diagnosis")
        );


        history.setTreatment(
                rs.getString("treatment")
        );


        history.setAllergies(
                rs.getString("allergies")
        );


        history.setMedications(
                rs.getString("medications")
        );


        history.setMedicalConditions(
                rs.getString("medical_conditions")
        );


        history.setNotes(
                rs.getString("notes")
        );


        history.setCreatedAt(
                rs.getTimestamp("created_at")
        );


        history.setUpdatedAt(
                rs.getTimestamp("updated_at")
        );


        history.setDoctorName(
                rs.getString("doctor_name")
        );


        history.setPatientName(
                rs.getString("patient_name")
        );


        return history;
    }
}