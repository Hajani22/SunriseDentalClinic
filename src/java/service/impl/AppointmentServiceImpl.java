package service.impl;

import dao.AppointmentDAO;
import dao.NotificationDAO;

import dao.impl.AppointmentDAOImpl;
import dao.impl.NotificationDAOImpl;

import model.Appointment;
import model.DoctorOption;

import service.AppointmentService;

import java.sql.SQLException;

import java.time.LocalDate;
import java.time.LocalTime;

import java.util.List;
import java.util.UUID;


public class AppointmentServiceImpl
        implements AppointmentService {


    /*
     * ============================================================
     * DAO OBJECTS
     * ============================================================
     */

    private final AppointmentDAO dao
            = new AppointmentDAOImpl();

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();


    /*
     * ============================================================
     * GET ALL DOCTORS
     * ============================================================
     */

    @Override
    public List<DoctorOption> getDoctors()
            throws SQLException {

        return dao.getDoctors();
    }


    /*
     * ============================================================
     * BOOK NEW APPOINTMENT
     * ============================================================
     */

    @Override
    public boolean bookAppointment(
            Appointment appointment)
            throws SQLException {


        /*
         * Basic null validation
         */

        if (appointment == null) {

            return false;
        }


        /*
         * Check whether selected doctor/time slot
         * is already booked.
         */

        if (dao.isSlotBooked(
                appointment.getDoctorId(),
                appointment.getAppointmentDate(),
                appointment.getAppointmentTime()
        )) {

            return false;
        }


        /*
         * Convert appointment date and time
         * into Java LocalDate and LocalTime.
         */

        LocalDate date
                = LocalDate.parse(
                        appointment.getAppointmentDate()
                );

        LocalTime time
                = LocalTime.parse(
                        appointment.getAppointmentTime()
                );


        /*
         * Appointment date cannot be in the past.
         */

        if (date.isBefore(LocalDate.now())) {

            return false;
        }


        /*
         * Appointment time cannot be in the past
         * if the appointment is today.
         */

        if (date.equals(LocalDate.now())
                && !time.isAfter(LocalTime.now())) {

            return false;
        }


        /*
         * Generate unique appointment number.
         *
         * Example:
         * SDC-A82F91BC
         */

        appointment.setAppointmentNo(
                "SDC-"
                + UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase()
        );


        /*
         * Save appointment into database.
         */

        boolean created
                = dao.createAppointment(
                        appointment
                );


        if (!created) {

            return false;
        }


        /*
         * ========================================================
         * PATIENT -> DOCTOR NOTIFICATION
         * ========================================================
         *
         * When patient creates an appointment,
         * the selected doctor receives a notification.
         */

        String message
                = "New appointment request from "
                + appointment.getPatientName()
                + " on "
                + appointment.getAppointmentDate()
                + " at "
                + appointment.getAppointmentTime()
                + ".";


        notificationDAO.create(
                appointment.getDoctorId(),
                "doctor",
                "New Appointment Request",
                message,
                appointment.getId()
        );


        return true;
    }


    /*
     * ============================================================
     * GET PATIENT APPOINTMENTS
     * ============================================================
     */

    @Override
    public List<Appointment> getPatientAppointments(
            int patientId)
            throws SQLException {

        return dao.getPatientAppointments(
                patientId
        );
    }


    /*
     * ============================================================
     * GET DOCTOR APPOINTMENTS
     * ============================================================
     */

    @Override
    public List<Appointment> getDoctorAppointments(
            int doctorId)
            throws SQLException {

        return dao.getDoctorAppointments(
                doctorId
        );
    }


    /*
     * ============================================================
     * GET ADMIN PENDING APPOINTMENTS
     * ============================================================
     *
     * This method returns appointments that are waiting
     * specifically for administrator confirmation.
     */

    @Override
    public List<Appointment> getAdminAppointments()
            throws SQLException {

        return dao.getAdminAppointments();
    }


    /*
     * ============================================================
     * NEW METHOD
     * GET ALL APPOINTMENTS
     * ============================================================
     *
     * Used by the Admin Appointment Management page.
     *
     * This returns:
     *
     * - Pending Doctor
     * - Pending Admin
     * - Confirmed
     * - Rejected
     *
     * appointments.
     */

    @Override
    public List<Appointment> getAllAppointments()
            throws SQLException {

        return dao.getAllAppointments();
    }


    /*
     * ============================================================
     * NEW METHOD
     * FILTER ADMIN APPOINTMENTS
     * ============================================================
     *
     * Supports:
     *
     * 1. Doctor filter
     * 2. Date filter
     * 3. Status filter
     *
     * Example:
     *
     * Doctor = Dr. Kumar
     * Date   = 2026-08-26
     * Status = PENDING_ADMIN
     *
     * Only matching records will be returned.
     */

    @Override
    public List<Appointment> filterAdminAppointments(
            String doctorId,
            String appointmentDate,
            String status)
            throws SQLException {

        return dao.filterAdminAppointments(
                doctorId,
                appointmentDate,
                status
        );
    }


    /*
     * ============================================================
     * GET APPOINTMENT BY ID
     * ============================================================
     */

    @Override
    public Appointment getById(
            int id)
            throws SQLException {

        return dao.getById(id);
    }


    /*
     * ============================================================
     * DOCTOR DECISION
     * ============================================================
     *
     * Doctor can:
     *
     * APPROVE
     *     PENDING_DOCTOR
     *          ↓
     *     PENDING_ADMIN
     *
     * REJECT
     *     PENDING_DOCTOR
     *          ↓
     *     REJECTED_BY_DOCTOR
     *
     */

    @Override
    public boolean doctorDecision(
            int appointmentId,
            int doctorId,
            boolean approve,
            String note)
            throws SQLException {


        /*
         * Retrieve appointment.
         */

        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * Appointment does not exist.
         */

        if (appointment == null) {

            return false;
        }


        /*
         * Security validation:
         *
         * Make sure this appointment actually belongs
         * to the logged-in doctor.
         */

        if (appointment.getDoctorId()
                != doctorId) {

            return false;
        }


        /*
         * Only PENDING_DOCTOR appointments
         * can be processed by doctor.
         */

        if (!"PENDING_DOCTOR".equals(
                appointment.getStatus())) {

            return false;
        }


        /*
         * Update appointment status.
         */

        boolean updated
                = dao.doctorDecision(
                        appointmentId,
                        doctorId,
                        approve,
                        note
                );


        if (!updated) {

            return false;
        }


        /*
         * ========================================================
         * DOCTOR ACCEPTED
         * ========================================================
         *
         * Appointment moves to:
         *
         * PENDING_ADMIN
         *
         * Admin receives notification.
         */

        if (approve) {


            notificationDAO.create(
                    1,
                    "admin",
                    "Appointment Waiting for Confirmation",

                    "Appointment "
                    + appointment.getAppointmentNo()
                    + " for "
                    + appointment.getPatientName()
                    + " has been accepted by Dr. "
                    + appointment.getDoctorName()
                    + " and is waiting for admin confirmation.",

                    appointmentId
            );


        }


        /*
         * ========================================================
         * DOCTOR REJECTED
         * ========================================================
         *
         * Patient receives rejection notification.
         */

        else {


            String reason
                    = (note == null
                    || note.trim().isEmpty())

                    ? "Doctor is not available."

                    : note;


            String message
                    = "Your appointment "
                    + appointment.getAppointmentNo()
                    + " on "
                    + appointment.getAppointmentDate()
                    + " at "
                    + appointment.getAppointmentTime()
                    + " was rejected by Dr. "
                    + appointment.getDoctorName()
                    + ". Reason: "
                    + reason;


            notificationDAO.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Rejected",
                    message,
                    appointmentId
            );
        }


        return true;
    }


    /*
     * ============================================================
     * ADMIN DECISION
     * ============================================================
     *
     * Admin can:
     *
     * CONFIRM
     *     PENDING_ADMIN
     *          ↓
     *     CONFIRMED
     *
     * REJECT
     *     PENDING_ADMIN
     *          ↓
     *     REJECTED_BY_ADMIN
     *
     */

    @Override
    public boolean adminDecision(
            int appointmentId,
            boolean approve,
            String note)
            throws SQLException {


        /*
         * Retrieve appointment.
         */

        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * Appointment does not exist.
         */

        if (appointment == null) {

            return false;
        }


        /*
         * Only appointments waiting
         * for admin confirmation can be processed.
         */

        if (!"PENDING_ADMIN".equals(
                appointment.getStatus())) {

            return false;
        }


        /*
         * Update database.
         */

        boolean updated
                = dao.adminDecision(
                        appointmentId,
                        approve,
                        note
                );


        if (!updated) {

            return false;
        }


        /*
         * ========================================================
         * ADMIN CONFIRMED
         * ========================================================
         *
         * Patient receives confirmation.
         */

        if (approve) {


            String message
                    = "Your appointment "
                    + appointment.getAppointmentNo()
                    + " is confirmed for "
                    + appointment.getAppointmentDate()
                    + " at "
                    + appointment.getAppointmentTime()
                    + " with Dr. "
                    + appointment.getDoctorName()
                    + ".";


            notificationDAO.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Confirmed",
                    message,
                    appointmentId
            );


        }


        /*
         * ========================================================
         * ADMIN REJECTED
         * ========================================================
         *
         * Patient receives rejection notification.
         */

        else {


            String reason
                    = (note == null
                    || note.trim().isEmpty())

                    ? "Appointment could not be confirmed."

                    : note;


            String message
                    = "Your appointment "
                    + appointment.getAppointmentNo()
                    + " was rejected by the clinic administrator."
                    + " Reason: "
                    + reason;


            notificationDAO.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Rejected",
                    message,
                    appointmentId
            );
        }


        return true;
    }

}