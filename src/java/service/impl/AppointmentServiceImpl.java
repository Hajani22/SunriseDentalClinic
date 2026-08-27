package service.impl;

import dao.AppointmentDAO;
import dao.DoctorScheduleDAO;
import dao.impl.AppointmentDAOImpl;
import dao.impl.DoctorScheduleDAOImpl;

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
import service.validation.DoctorAvailabilityHandler;

import java.sql.SQLException;

import java.util.List;
import java.util.UUID;

/**
 * Appointment Service Implementation.
 *
 * Design Patterns used:
 *
 * 1. Chain of Responsibility 2. Observer 3. Decorator
 *
 * New Requirement:
 *
 * 4. Doctor Schedule & Availability Validation
 */
public class AppointmentServiceImpl
        implements AppointmentService {


    /*
     * =========================================================
     * APPOINTMENT DAO
     * =========================================================
     */
    private final AppointmentDAO dao
            = new AppointmentDAOImpl();


    /*
     * =========================================================
     * DOCTOR SCHEDULE DAO
     *
     * Used to check whether the selected doctor is working
     * on the selected date and time.
     * =========================================================
     */
    private final DoctorScheduleDAO scheduleDAO
            = new DoctorScheduleDAOImpl();


    /*
     * =========================================================
     * DECORATOR PATTERN
     *
     * LoggingNotificationServiceDecorator adds logging
     * functionality around the NotificationService.
     * =========================================================
     */
    private final NotificationService notificationService
            = new LoggingNotificationServiceDecorator(
                    new NotificationServiceImpl()
            );


    /*
     * =========================================================
     * OBSERVER PATTERN
     *
     * Appointment events are published through the publisher.
     * =========================================================
     */
    private final AppointmentEventPublisher eventPublisher
            = new AppointmentEventPublisher();


    /*
     * =========================================================
     * CHAIN OF RESPONSIBILITY
     *
     * Validation chain:
     *
     * Required Fields
     *        ↓
     * Date Validation
     *        ↓
     * Time Validation
     *        ↓
     * Doctor Availability
     *        ↓
     * Appointment Slot
     * =========================================================
     */
    private final AppointmentValidationHandler validationChain
            = buildValidationChain();


    /*
     * =========================================================
     * CONSTRUCTOR
     * =========================================================
     */
    public AppointmentServiceImpl() {

        /*
         * Observer Pattern
         *
         * Register the doctor appointment observer.
         */
        eventPublisher.subscribe(
                new DoctorAppointmentObserver(
                        notificationService
                )
        );
    }


    /*
     * =========================================================
     * BUILD APPOINTMENT VALIDATION CHAIN
     * =========================================================
     */
    private AppointmentValidationHandler
            buildValidationChain() {


        /*
         * -----------------------------------------------------
         * 1. REQUIRED FIELD VALIDATION
         * -----------------------------------------------------
         */
        AppointmentValidationHandler required
                = new RequiredAppointmentFieldsHandler();


        /*
         * -----------------------------------------------------
         * 2. DATE VALIDATION
         * -----------------------------------------------------
         */
        AppointmentValidationHandler date
                = new AppointmentDateHandler();


        /*
         * -----------------------------------------------------
         * 3. TIME VALIDATION
         * -----------------------------------------------------
         */
        AppointmentValidationHandler time
                = new AppointmentTimeHandler();


        /*
         * -----------------------------------------------------
         * 4. DOCTOR AVAILABILITY VALIDATION
         *
         * NEW REQUIREMENT
         *
         * Checks:
         *
         * - Doctor has a schedule
         * - Doctor works on selected day
         * - Selected time is inside working hours
         * - Selected time is not during break
         * - Schedule is active
         * -----------------------------------------------------
         */
        AppointmentValidationHandler availability
                = new DoctorAvailabilityHandler();


        /*
         * -----------------------------------------------------
         * 5. APPOINTMENT SLOT VALIDATION
         *
         * Existing requirement.
         *
         * Prevents double booking.
         * -----------------------------------------------------
         */
        AppointmentValidationHandler slot
                = new AppointmentSlotHandler();


        /*
         * -----------------------------------------------------
         * CONNECT THE CHAIN
         * -----------------------------------------------------
         *
         * Required
         *    ↓
         * Date
         *    ↓
         * Time
         *    ↓
         * Doctor Availability
         *    ↓
         * Slot
         */
        required
                .setNext(date)
                .setNext(time)
                .setNext(availability)
                .setNext(slot);

        return required;
    }


    /*
     * =========================================================
     * GET AVAILABLE DOCTORS
     * =========================================================
     */
    @Override
    public List<DoctorOption> getDoctors()
            throws SQLException {

        return dao.getDoctors();
    }


    /*
     * =========================================================
     * BOOK APPOINTMENT
     * =========================================================
     */
    @Override
    public boolean bookAppointment(
            Appointment appointment)
            throws SQLException {


        /*
         * -----------------------------------------------------
         * RUN COMPLETE VALIDATION CHAIN
         * -----------------------------------------------------
         *
         * The chain now checks doctor availability before
         * allowing the appointment to be created.
         */
        validationChain.validate(
                appointment,
                dao
        );


        /*
         * -----------------------------------------------------
         * GENERATE UNIQUE APPOINTMENT NUMBER
         * -----------------------------------------------------
         */
        appointment.setAppointmentNo(
                "SDC-"
                + UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase()
        );


        /*
         * -----------------------------------------------------
         * CREATE APPOINTMENT
         * -----------------------------------------------------
         */
        boolean created
                = dao.createAppointment(
                        appointment
                );


        /*
         * If appointment creation failed,
         * return false.
         */
        if (!created) {
            return false;
        }


        /*
         * -----------------------------------------------------
         * OBSERVER PATTERN
         *
         * Publish CREATED event.
         * -----------------------------------------------------
         */
        eventPublisher.publish(
                new AppointmentEvent(
                        AppointmentEvent.Type.CREATED,
                        appointment
                )
        );

        return true;
    }


    /*
     * =========================================================
     * GET PATIENT APPOINTMENTS
     * =========================================================
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
     * =========================================================
     * GET DOCTOR APPOINTMENTS
     * =========================================================
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
     * =========================================================
     * GET ADMIN APPOINTMENTS
     * =========================================================
     */
    @Override
    public List<Appointment> getAdminAppointments()
            throws SQLException {

        return dao.getAdminAppointments();
    }


    /*
     * =========================================================
     * GET ALL APPOINTMENTS
     * =========================================================
     */
    @Override
    public List<Appointment> getAllAppointments()
            throws SQLException {

        return dao.getAllAppointments();
    }


    /*
     * =========================================================
     * FILTER ADMIN APPOINTMENTS
     * =========================================================
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
     * =========================================================
     * GET APPOINTMENT BY ID
     * =========================================================
     */
    @Override
    public Appointment getById(
            int id)
            throws SQLException {

        return dao.getById(id);
    }


    /*
     * =========================================================
     * DOCTOR DECISION
     *
     * Doctor approves or rejects an appointment.
     * =========================================================
     */
    @Override
    public boolean doctorDecision(
            int appointmentId,
            int doctorId,
            boolean approve,
            String note)
            throws SQLException {


        /*
         * Get appointment.
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
         * Security check.
         *
         * Make sure the appointment belongs
         * to the logged-in doctor.
         */
        if (appointment.getDoctorId()
                != doctorId) {

            return false;
        }


        /*
         * Only PENDING_DOCTOR appointments
         * can be processed.
         */
        if (!"PENDING_DOCTOR".equals(
                appointment.getStatus()
        )) {

            return false;
        }


        /*
         * Update appointment.
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
         * =====================================================
         * DOCTOR APPROVED
         * =====================================================
         */
        if (approve) {


            /*
             * Notify admin.
             */
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


            /*
             * =================================================
             * DOCTOR REJECTED
             * =================================================
             */
            String reason
                    = note == null
                    || note.trim().isEmpty()
                    ? "Doctor is not available."
                    : note;


            /*
             * Notify patient.
             */
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


    /*
     * =========================================================
     * ADMIN DECISION
     *
     * Admin approves or rejects appointment.
     * =========================================================
     */
    @Override
    public boolean adminDecision(
            int appointmentId,
            boolean approve,
            String note)
            throws SQLException {


        /*
         * Get appointment.
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
         * Only PENDING_ADMIN appointments
         * can be processed.
         */
        if (!"PENDING_ADMIN".equals(
                appointment.getStatus()
        )) {

            return false;
        }


        /*
         * Update appointment.
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
         * =====================================================
         * ADMIN APPROVED
         * =====================================================
         */
        if (approve) {


            /*
             * Notify patient.
             */
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


            /*
             * =================================================
             * ADMIN REJECTED
             * =================================================
             */
            String reason
                    = note == null
                    || note.trim().isEmpty()
                    ? "Appointment could not be confirmed."
                    : note;


            /*
             * Notify patient.
             */
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


        /*
         * Get existing appointment.
         */
        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * -----------------------------------------------------
         * SECURITY CHECK
         *
         * Only the patient who owns the appointment
         * can reschedule it.
         * -----------------------------------------------------
         */
        if (appointment == null
                || appointment.getPatientId()
                != patientId) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * CHECK APPOINTMENT STATUS
         *
         * Only active appointments can be rescheduled.
         * -----------------------------------------------------
         */
        String status
                = appointment.getStatus();

        if (!"PENDING_DOCTOR".equals(status)
                && !"PENDING_ADMIN".equals(status)
                && !"CONFIRMED".equals(status)) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * VALIDATE NEW DATE AND TIME
         * -----------------------------------------------------
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


            /*
             * New date cannot be in the past.
             */
            if (newDate.isBefore(
                    java.time.LocalDate.now()
            )) {

                return false;
            }


            /*
             * If selected date is today,
             * selected time must be in the future.
             */
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
         * =====================================================
         * DOCTOR AVAILABILITY CHECK
         *
         * NEW REQUIREMENT
         *
         * A rescheduled appointment must also be within
         * the doctor's working schedule.
         * =====================================================
         */
        boolean doctorAvailable
                = scheduleDAO.isDoctorAvailable(
                        appointment.getDoctorId(),
                        date,
                        time
                );


        /*
         * Doctor is not working at selected time.
         */
        if (!doctorAvailable) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * PREVENT DOUBLE BOOKING
         * -----------------------------------------------------
         */
        if (dao.isSlotBookedForReschedule(
                appointmentId,
                appointment.getDoctorId(),
                date,
                time
        )) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * UPDATE APPOINTMENT
         * -----------------------------------------------------
         */
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
         * -----------------------------------------------------
         * NOTIFY PATIENT
         * -----------------------------------------------------
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
         * -----------------------------------------------------
         * NOTIFY DOCTOR
         * -----------------------------------------------------
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


        /*
         * Get appointment.
         */
        Appointment appointment
                = dao.getById(
                        appointmentId
                );


        /*
         * -----------------------------------------------------
         * SECURITY CHECK
         * -----------------------------------------------------
         */
        if (appointment == null
                || appointment.getPatientId()
                != patientId) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * CHECK APPOINTMENT STATUS
         * -----------------------------------------------------
         */
        String status
                = appointment.getStatus();

        if (!"PENDING_DOCTOR".equals(status)
                && !"PENDING_ADMIN".equals(status)
                && !"CONFIRMED".equals(status)) {

            return false;
        }


        /*
         * -----------------------------------------------------
         * DEFAULT CANCELLATION REASON
         * -----------------------------------------------------
         */
        if (reason == null
                || reason.trim().isEmpty()) {

            reason
                    = "Cancelled by patient.";
        }


        /*
         * Remove leading/trailing spaces.
         */
        reason
                = reason.trim();


        /*
         * Limit reason length.
         */
        if (reason.length() > 500) {

            reason
                    = reason.substring(
                            0,
                            500
                    );
        }


        /*
         * -----------------------------------------------------
         * CANCEL APPOINTMENT
         * -----------------------------------------------------
         */
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
         * -----------------------------------------------------
         * NOTIFY DOCTOR
         * -----------------------------------------------------
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
         * -----------------------------------------------------
         * NOTIFY ADMIN
         *
         * Existing system uses admin ID 1.
         * -----------------------------------------------------
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
