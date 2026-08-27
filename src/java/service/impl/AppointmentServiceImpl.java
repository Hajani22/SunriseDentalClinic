package service.impl;

import dao.AppointmentDAO;
import dao.impl.AppointmentDAOImpl;

import model.Appointment;
import model.DoctorOption;

import service.AppointmentService;
import service.NotificationService;

import service.decorator.LoggingNotificationServiceDecorator;

import service.observer.AppointmentEvent;
import service.observer.AppointmentEventPublisher;
import service.observer.DoctorAppointmentObserver;

import service.validation.AppointmentDateHandler;
import service.validation.AppointmentSlotHandler;
import service.validation.AppointmentTimeHandler;
import service.validation.AppointmentValidationHandler;
import service.validation.RequiredAppointmentFieldsHandler;

import java.sql.SQLException;

import java.util.List;
import java.util.UUID;

/**
 * Appointment Service Implementation.
 *
 * Design Patterns already used:
 *
 * 1. Chain of Responsibility 2. Observer 3. Decorator
 */
public class AppointmentServiceImpl
        implements AppointmentService {

    private final AppointmentDAO dao
            = new AppointmentDAOImpl();


    /*
     * Decorator Pattern
     */
    private final NotificationService notificationService
            = new LoggingNotificationServiceDecorator(
                    new NotificationServiceImpl()
            );


    /*
     * Observer Pattern
     */
    private final AppointmentEventPublisher eventPublisher
            = new AppointmentEventPublisher();


    /*
     * Chain of Responsibility
     */
    private final AppointmentValidationHandler validationChain
            = buildValidationChain();

    public AppointmentServiceImpl() {

        eventPublisher.subscribe(
                new DoctorAppointmentObserver(
                        notificationService
                )
        );
    }

    private AppointmentValidationHandler
            buildValidationChain() {

        AppointmentValidationHandler required
                = new RequiredAppointmentFieldsHandler();

        AppointmentValidationHandler date
                = new AppointmentDateHandler();

        AppointmentValidationHandler time
                = new AppointmentTimeHandler();

        AppointmentValidationHandler slot
                = new AppointmentSlotHandler();

        required
                .setNext(date)
                .setNext(time)
                .setNext(slot);

        return required;
    }

    @Override
    public List<DoctorOption> getDoctors()
            throws SQLException {

        return dao.getDoctors();
    }

    @Override
    public boolean bookAppointment(
            Appointment appointment)
            throws SQLException {

        validationChain.validate(
                appointment,
                dao
        );

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

        eventPublisher.publish(
                new AppointmentEvent(
                        AppointmentEvent.Type.CREATED,
                        appointment
                )
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
    public List<Appointment> getAllAppointments()
            throws SQLException {

        return dao.getAllAppointments();
    }

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

        if (appointment.getDoctorId()
                != doctorId) {

            return false;
        }

        if (!"PENDING_DOCTOR".equals(
                appointment.getStatus()
        )) {

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

        if (approve) {

            notificationService.create(
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

        } else {

            String reason
                    = note == null
                    || note.trim().isEmpty()
                    ? "Doctor is not available."
                    : note;

            notificationService.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Rejected",
                    "Your appointment "
                    + appointment.getAppointmentNo()
                    + " was rejected by Dr. "
                    + appointment.getDoctorName()
                    + ". Reason: "
                    + reason,
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
                appointment.getStatus()
        )) {

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

        if (approve) {

            notificationService.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Confirmed",
                    "Your appointment "
                    + appointment.getAppointmentNo()
                    + " is confirmed for "
                    + appointment.getAppointmentDate()
                    + " at "
                    + appointment.getAppointmentTime()
                    + " with Dr. "
                    + appointment.getDoctorName()
                    + ".",
                    appointmentId
            );

        } else {

            String reason
                    = note == null
                    || note.trim().isEmpty()
                    ? "Appointment could not be confirmed."
                    : note;

            notificationService.create(
                    appointment.getPatientId(),
                    "patient",
                    "Appointment Rejected",
                    "Your appointment "
                    + appointment.getAppointmentNo()
                    + " was rejected by the clinic administrator."
                    + " Reason: "
                    + reason,
                    appointmentId
            );
        }

        return true;
    }


    /*
     * =========================================================
     * RESCHEDULE APPOINTMENT
     * =========================================================
     */
    @Override
    public boolean rescheduleAppointment(
            int appointmentId,
            int patientId,
            String date,
            String time)
            throws SQLException {

        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * Security check.
         */
        if (appointment == null
                || appointment.getPatientId()
                != patientId) {

            return false;
        }


        /*
         * Only active appointments can
         * be rescheduled.
         */
        String status
                = appointment.getStatus();

        if (!"PENDING_DOCTOR".equals(status)
                && !"PENDING_ADMIN".equals(status)
                && !"CONFIRMED".equals(status)) {

            return false;
        }


        /*
         * Validate date and time.
         */
        try {

            java.time.LocalDate newDate
                    = java.time.LocalDate.parse(
                            date
                    );

            java.time.LocalTime newTime
                    = java.time.LocalTime.parse(
                            time
                    );

            if (newDate.isBefore(
                    java.time.LocalDate.now()
            )) {

                return false;
            }

            if (newDate.equals(
                    java.time.LocalDate.now()
            )
                    && !newTime.isAfter(
                            java.time.LocalTime.now()
                    )) {

                return false;
            }

        } catch (Exception e) {

            return false;
        }


        /*
         * Prevent double booking.
         */
        if (dao.isSlotBookedForReschedule(
                appointmentId,
                appointment.getDoctorId(),
                date,
                time
        )) {

            return false;
        }

        boolean updated
                = dao.rescheduleAppointment(
                        appointmentId,
                        patientId,
                        date,
                        time
                );

        if (!updated) {
            return false;
        }


        /*
         * Notify patient.
         */
        notificationService.create(
                patientId,
                "patient",
                "Appointment Rescheduled",
                "Your appointment "
                + appointment.getAppointmentNo()
                + " has been rescheduled to "
                + date
                + " at "
                + time
                + ". It is waiting for doctor approval.",
                appointmentId
        );


        /*
         * Notify doctor.
         */
        notificationService.create(
                appointment.getDoctorId(),
                "doctor",
                "Appointment Rescheduled",
                "Appointment "
                + appointment.getAppointmentNo()
                + " has been rescheduled by "
                + appointment.getPatientName()
                + " to "
                + date
                + " at "
                + time
                + ".",
                appointmentId
        );

        return true;
    }


    /*
     * =========================================================
     * CANCEL APPOINTMENT
     * =========================================================
     */
    @Override
    public boolean cancelAppointment(
            int appointmentId,
            int patientId,
            String reason)
            throws SQLException {

        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * Security check.
         */
        if (appointment == null
                || appointment.getPatientId()
                != patientId) {

            return false;
        }


        /*
         * Only active appointments can
         * be cancelled.
         */
        String status
                = appointment.getStatus();

        if (!"PENDING_DOCTOR".equals(status)
                && !"PENDING_ADMIN".equals(status)
                && !"CONFIRMED".equals(status)) {

            return false;
        }

        if (reason == null
                || reason.trim().isEmpty()) {

            reason
                    = "Cancelled by patient.";
        }

        reason
                = reason.trim();

        if (reason.length() > 500) {

            reason
                    = reason.substring(
                            0,
                            500
                    );
        }

        boolean cancelled
                = dao.cancelAppointment(
                        appointmentId,
                        patientId,
                        reason
                );

        if (!cancelled) {
            return false;
        }


        /*
         * Notify doctor.
         */
        notificationService.create(
                appointment.getDoctorId(),
                "doctor",
                "Appointment Cancelled",
                "Appointment "
                + appointment.getAppointmentNo()
                + " for "
                + appointment.getPatientName()
                + " has been cancelled by the patient."
                + " Reason: "
                + reason,
                appointmentId
        );


        /*
         * Notify admin.
         *
         * Your current system uses admin ID 1.
         */
        notificationService.create(
                1,
                "admin",
                "Appointment Cancelled",
                "Appointment "
                + appointment.getAppointmentNo()
                + " for "
                + appointment.getPatientName()
                + " has been cancelled by the patient."
                + " Reason: "
                + reason,
                appointmentId
        );

        return true;
    }
}
