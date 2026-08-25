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

    private final AppointmentDAO dao
            = new AppointmentDAOImpl();

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();

    @Override
    public List<DoctorOption> getDoctors()
            throws SQLException {

        return dao.getDoctors();
    }

    @Override
    public boolean bookAppointment(
            Appointment appointment)
            throws SQLException {

        if (appointment == null) {
            return false;
        }

        if (dao.isSlotBooked(
                appointment.getDoctorId(),
                appointment.getAppointmentDate(),
                appointment.getAppointmentTime()
        )) {
            return false;
        }

        LocalDate date
                = LocalDate.parse(
                        appointment.getAppointmentDate()
                );

        LocalTime time
                = LocalTime.parse(
                        appointment.getAppointmentTime()
                );

        if (date.isBefore(LocalDate.now())) {
            return false;
        }

        if (date.equals(LocalDate.now())
                && !time.isAfter(LocalTime.now())) {

            return false;
        }

        appointment.setAppointmentNo(
                "SDC-"
                + UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase()
        );

        boolean created
                = dao.createAppointment(
                        appointment
                );

        if (!created) {
            return false;
        }


        /*
         * PATIENT -> DOCTOR NOTIFICATION
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

    @Override
    public List<Appointment> getPatientAppointments(
            int patientId)
            throws SQLException {

        return dao.getPatientAppointments(
                patientId
        );
    }

    @Override
    public List<Appointment> getDoctorAppointments(
            int doctorId)
            throws SQLException {

        return dao.getDoctorAppointments(
                doctorId
        );
    }

    @Override
    public List<Appointment> getAdminAppointments()
            throws SQLException {

        return dao.getAdminAppointments();
    }

    @Override
    public Appointment getById(
            int id)
            throws SQLException {

        return dao.getById(id);
    }

    @Override
    public boolean doctorDecision(
            int appointmentId,
            int doctorId,
            boolean approve,
            String note)
            throws SQLException {

        Appointment appointment
                = dao.getById(
                        appointmentId
                );

        if (appointment == null) {
            return false;
        }

        if (appointment.getDoctorId() != doctorId) {
            return false;
        }

        if (!"PENDING_DOCTOR".equals(
                appointment.getStatus())) {

            return false;
        }

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
         * DOCTOR ACCEPTED
         * -> ADMIN NOTIFICATION
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

        } /*
         * DOCTOR REJECTED
         * -> PATIENT NOTIFICATION
         */ else {

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

    @Override
    public boolean adminDecision(
            int appointmentId,
            boolean approve,
            String note)
            throws SQLException {

        Appointment appointment
                = dao.getById(
                        appointmentId
                );

        if (appointment == null) {
            return false;
        }

        if (!"PENDING_ADMIN".equals(
                appointment.getStatus())) {

            return false;
        }

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
         * ADMIN CONFIRMED
         * -> PATIENT NOTIFICATION
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

        } /*
         * ADMIN REJECTED
         * -> PATIENT NOTIFICATION
         */ else {

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
