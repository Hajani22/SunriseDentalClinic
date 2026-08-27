package dao;

import model.Appointment;
import model.DoctorOption;

import java.sql.SQLException;
import java.util.List;

public interface AppointmentDAO {

    List<DoctorOption> getDoctors()
            throws SQLException;

    boolean isSlotBooked(
            int doctorId,
            String date,
            String time)
            throws SQLException;

    boolean createAppointment(
            Appointment appointment)
            throws SQLException;

    List<Appointment> getPatientAppointments(
            int patientId)
            throws SQLException;

    List<Appointment> getDoctorAppointments(
            int doctorId)
            throws SQLException;

    List<Appointment> getAdminAppointments()
            throws SQLException;

    List<Appointment> getAllAppointments()
            throws SQLException;

    List<Appointment> filterAdminAppointments(
            String doctorId,
            String appointmentDate,
            String status)
            throws SQLException;

    Appointment getById(
            int id)
            throws SQLException;

    boolean doctorDecision(
            int appointmentId,
            int doctorId,
            boolean approve,
            String note)
            throws SQLException;

    boolean adminDecision(
            int appointmentId,
            boolean approve,
            String note)
            throws SQLException;


    /*
     * =========================================================
     * RESCHEDULE
     * =========================================================
     */
    boolean isSlotBookedForReschedule(
            int appointmentId,
            int doctorId,
            String date,
            String time)
            throws SQLException;

    boolean rescheduleAppointment(
            int appointmentId,
            int patientId,
            String date,
            String time)
            throws SQLException;


    /*
     * =========================================================
     * CANCELLATION
     * =========================================================
     */
    boolean cancelAppointment(
            int appointmentId,
            int patientId,
            String reason)
            throws SQLException;
}
