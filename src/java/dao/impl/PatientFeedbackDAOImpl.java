package dao.impl;

import dao.PatientFeedbackDAO;

import model.PatientFeedback;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class PatientFeedbackDAOImpl
        implements PatientFeedbackDAO {


    /*
     * =========================================================
     * ADD FEEDBACK
     * =========================================================
     */
    @Override
    public boolean addFeedback(
            PatientFeedback feedback)
            throws SQLException {

        String sql
                = "INSERT INTO patient_feedback "
                + "(appointment_id, patient_id, rating, comments) "
                + "VALUES (?, ?, ?, ?)";

        try (
                Connection connection
                = DBConnection.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    feedback.getAppointmentId()
            );

            statement.setInt(
                    2,
                    feedback.getPatientId()
            );

            statement.setInt(
                    3,
                    feedback.getRating()
            );

            statement.setString(
                    4,
                    feedback.getComments()
            );

            return statement.executeUpdate() == 1;
        }
    }


    /*
     * =========================================================
     * CHECK DUPLICATE FEEDBACK
     * =========================================================
     */
    @Override
    public boolean hasFeedback(
            int appointmentId,
            int patientId)
            throws SQLException {

        String sql
                = "SELECT COUNT(*) "
                + "FROM patient_feedback "
                + "WHERE appointment_id = ? "
                + "AND patient_id = ?";

        try (
                Connection connection
                = DBConnection.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    appointmentId
            );

            statement.setInt(
                    2,
                    patientId
            );

            try (
                    ResultSet resultSet
                    = statement.executeQuery()) {

                if (resultSet.next()) {

                    return resultSet.getInt(1) > 0;
                }
            }
        }

        return false;
    }


    /*
     * =========================================================
     * FIND INTERNAL APPOINTMENT ID
     * =========================================================
     *
     * This is the IMPORTANT FIX.
     *
     * Patient enters:
     *
     *     SDC-F3B3A0AB
     *
     * Database finds:
     *
     *     appointments.id = 10
     *
     * Only ID 10 is saved into patient_feedback.
     */
    @Override
    public int findAppointmentIdByNumberAndPatient(
            String appointmentNo,
            int patientId)
            throws SQLException {

        String sql
                = "SELECT id "
                + "FROM appointments "
                + "WHERE appointment_no = ? "
                + "AND patient_id = ? "
                + "LIMIT 1";

        try (
                Connection connection
                = DBConnection.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql)) {

            statement.setString(
                    1,
                    appointmentNo
            );

            statement.setInt(
                    2,
                    patientId
            );

            try (
                    ResultSet resultSet
                    = statement.executeQuery()) {

                if (resultSet.next()) {

                    return resultSet.getInt("id");
                }
            }
        }


        /*
         * 0 means appointment was not found
         * or does not belong to this patient.
         */
        return 0;
    }


    /*
     * =========================================================
     * GET PATIENT FEEDBACK
     * =========================================================
     *
     * Notice:
     *
     * We JOIN appointments so the patient/admin sees
     * the actual appointment number instead of the
     * internal numeric appointment ID.
     */
    @Override
    public List<PatientFeedback>
            getPatientFeedback(
                    int patientId)
            throws SQLException {

        List<PatientFeedback> feedbackList
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "pf.id, "
                + "pf.appointment_id, "
                + "pf.patient_id, "
                + "pf.rating, "
                + "pf.comments, "
                + "pf.created_at, "
                + "a.appointment_no, "
                + "a.patient_name "
                + "FROM patient_feedback pf "
                + "INNER JOIN appointments a "
                + "ON pf.appointment_id = a.id "
                + "WHERE pf.patient_id = ? "
                + "ORDER BY pf.created_at DESC";

        try (
                Connection connection
                = DBConnection.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    patientId
            );

            try (
                    ResultSet resultSet
                    = statement.executeQuery()) {

                while (resultSet.next()) {

                    PatientFeedback feedback
                            = mapFeedback(resultSet);

                    feedbackList.add(feedback);
                }
            }
        }

        return feedbackList;
    }


    /*
     * =========================================================
     * GET ALL FEEDBACK
     * =========================================================
     *
     * Used by administrator.
     */
    @Override
    public List<PatientFeedback>
            getAllFeedback()
            throws SQLException {

        List<PatientFeedback> feedbackList
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "pf.id, "
                + "pf.appointment_id, "
                + "pf.patient_id, "
                + "pf.rating, "
                + "pf.comments, "
                + "pf.created_at, "
                + "a.appointment_no, "
                + "a.patient_name "
                + "FROM patient_feedback pf "
                + "INNER JOIN appointments a "
                + "ON pf.appointment_id = a.id "
                + "ORDER BY pf.created_at DESC";

        try (
                Connection connection
                = DBConnection.getConnection(); PreparedStatement statement
                = connection.prepareStatement(sql); ResultSet resultSet
                = statement.executeQuery()) {

            while (resultSet.next()) {

                PatientFeedback feedback
                        = mapFeedback(resultSet);

                feedbackList.add(feedback);
            }
        }

        return feedbackList;
    }


    /*
     * =========================================================
     * MAP RESULTSET TO MODEL
     * =========================================================
     */
    private PatientFeedback mapFeedback(
            ResultSet resultSet)
            throws SQLException {

        PatientFeedback feedback
                = new PatientFeedback();

        feedback.setId(
                resultSet.getInt("id")
        );

        feedback.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        feedback.setPatientId(
                resultSet.getInt("patient_id")
        );

        feedback.setRating(
                resultSet.getInt("rating")
        );

        feedback.setComments(
                resultSet.getString("comments")
        );

        feedback.setCreatedAt(
                resultSet.getTimestamp("created_at")
        );

        feedback.setAppointmentNo(
                resultSet.getString("appointment_no")
        );

        feedback.setPatientName(
                resultSet.getString("patient_name")
        );

        return feedback;
    }
}
