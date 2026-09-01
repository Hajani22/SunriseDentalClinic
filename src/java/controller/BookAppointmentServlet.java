package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Appointment;
import model.User;

import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

/**
 * Controller for patient appointment booking.
 *
 * Handles: - Session validation - Form validation - Appointment creation -
 * Duplicate appointment slot prevention
 */
@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentServiceImpl();
    }

    // =========================================================
    // GET - OPEN BOOK APPOINTMENT PAGE
    // =========================================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            service.DoctorScheduleService scheduleService
                    = new service.impl.DoctorScheduleServiceImpl();

            request.setAttribute(
                    "doctors",
                    appointmentService.getDoctors()
            );

            request.setAttribute(
                    "schedules",
                    scheduleService.getAllSchedules()
            );

            request.getRequestDispatcher(
                    "/book-appointment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "A database error occurred while loading the appointment page."
            );
        }
    }

    // =========================================================
    // POST - SEND APPOINTMENT REQUEST
    // =========================================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session
                = request.getSession(false);

        // -----------------------------------------------------
        // SESSION VALIDATION
        // -----------------------------------------------------
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        // -----------------------------------------------------
        // ROLE VALIDATION
        // -----------------------------------------------------
        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            // -------------------------------------------------
            // PATIENT ID
            // -------------------------------------------------
            Object idObject
                    = session.getAttribute("userId");

            if (idObject == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }

            int patientId;

            try {

                patientId
                        = Integer.parseInt(
                                idObject.toString()
                        );

            } catch (NumberFormatException e) {

                redirectError(
                        request,
                        response,
                        "Invalid patient account."
                );

                return;
            }

            // -------------------------------------------------
            // USER
            // -------------------------------------------------
            User user
                    = (User) session.getAttribute("user");

            if (user == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }

            // -------------------------------------------------
            // GET FORM VALUES
            // -------------------------------------------------
            String doctorIdValue
                    = clean(
                            request.getParameter("doctorId")
                    );

            String treatmentType
                    = clean(
                            request.getParameter("treatmentType")
                    );

            String appointmentDate
                    = clean(
                            request.getParameter("appointmentDate")
                    );

            String appointmentTime
                    = clean(
                            request.getParameter("appointmentTime")
                    );

            String phone
                    = clean(
                            request.getParameter("phone")
                    );

            String address
                    = clean(
                            request.getParameter("address")
                    );

            // -------------------------------------------------
            // REQUIRED FIELD VALIDATION
            // -------------------------------------------------
            if (doctorIdValue == null) {

                redirectError(
                        request,
                        response,
                        "Please select a dentist."
                );

                return;
            }

            if (treatmentType == null) {

                redirectError(
                        request,
                        response,
                        "Please select a treatment."
                );

                return;
            }

            if (appointmentDate == null) {

                redirectError(
                        request,
                        response,
                        "Please select an appointment date."
                );

                return;
            }

            if (appointmentTime == null) {

                redirectError(
                        request,
                        response,
                        "Please select an appointment time."
                );

                return;
            }

            if (phone == null) {

                redirectError(
                        request,
                        response,
                        "Phone number is required."
                );

                return;
            }

            if (address == null) {

                redirectError(
                        request,
                        response,
                        "Address is required."
                );

                return;
            }

            // -------------------------------------------------
            // PHONE VALIDATION
            // -------------------------------------------------
            String phoneDigits
                    = phone.replaceAll(
                            "[^0-9]",
                            ""
                    );

            if (!phoneDigits.matches(
                    "^[0-9]{9,12}$"
            )) {

                redirectError(
                        request,
                        response,
                        "Please enter a valid phone number."
                );

                return;
            }

            // -------------------------------------------------
            // ADDRESS VALIDATION
            // -------------------------------------------------
            if (address.length() < 5) {

                redirectError(
                        request,
                        response,
                        "Address must contain at least 5 characters."
                );

                return;
            }

            if (address.length() > 255) {

                redirectError(
                        request,
                        response,
                        "Address cannot exceed 255 characters."
                );

                return;
            }

            // -------------------------------------------------
            // DOCTOR ID
            // -------------------------------------------------
            int doctorId;

            try {

                doctorId
                        = Integer.parseInt(
                                doctorIdValue
                        );

            } catch (NumberFormatException e) {

                redirectError(
                        request,
                        response,
                        "Please select a valid dentist."
                );

                return;
            }

            if (doctorId <= 0) {

                redirectError(
                        request,
                        response,
                        "Please select a valid dentist."
                );

                return;
            }

            // -------------------------------------------------
            // DATE FORMAT VALIDATION
            // -------------------------------------------------
            try {

                java.time.LocalDate date
                        = java.time.LocalDate.parse(
                                appointmentDate
                        );

                if (date.isBefore(
                        java.time.LocalDate.now()
                )) {

                    redirectError(
                            request,
                            response,
                            "Appointment date cannot be in the past."
                    );

                    return;
                }

            } catch (java.time.format.DateTimeParseException e) {

                redirectError(
                        request,
                        response,
                        "Invalid appointment date."
                );

                return;
            }

            // -------------------------------------------------
            // TIME FORMAT VALIDATION
            // -------------------------------------------------
            try {

                java.time.LocalTime time
                        = java.time.LocalTime.parse(
                                appointmentTime
                        );

                java.time.LocalDate date
                        = java.time.LocalDate.parse(
                                appointmentDate
                        );

                if (date.equals(
                        java.time.LocalDate.now()
                )
                        && !time.isAfter(
                                java.time.LocalTime.now()
                        )) {

                    redirectError(
                            request,
                            response,
                            "Appointment time must be in the future."
                    );

                    return;
                }

            } catch (java.time.format.DateTimeParseException e) {

                redirectError(
                        request,
                        response,
                        "Invalid appointment time."
                );

                return;
            }

            // -------------------------------------------------
            // PATIENT NAME
            // -------------------------------------------------
            String patientName
                    = user.getFirstName()
                    + " "
                    + user.getLastName();

            if (patientName.trim().isEmpty()) {

                redirectError(
                        request,
                        response,
                        "Patient name is required."
                );

                return;
            }

            // -------------------------------------------------
            // CREATE APPOINTMENT OBJECT
            // -------------------------------------------------
            Appointment appointment
                    = new Appointment();

            appointment.setPatientId(
                    patientId
            );

            appointment.setDoctorId(
                    doctorId
            );

            appointment.setPatientName(
                    patientName
            );

            appointment.setPatientPhone(
                    phone
            );

            appointment.setPatientAddress(
                    address
            );

            appointment.setTreatmentType(
                    treatmentType
            );

            appointment.setAppointmentDate(
                    appointmentDate
            );

            appointment.setAppointmentTime(
                    appointmentTime
            );

            // -------------------------------------------------
            // BOOK APPOINTMENT
            //
            // Service validation will check:
            //
            // 1. Required fields
            // 2. Date
            // 3. Time
            // 4. Doctor schedule
            // 5. Doctor leave
            // 6. Existing appointment slot
            // -------------------------------------------------
            boolean created
                    = appointmentService.bookAppointment(
                            appointment
                    );

            // -------------------------------------------------
            // APPOINTMENT SLOT ALREADY BOOKED
            // -------------------------------------------------
            if (!created) {

                redirectError(
                        request,
                        response,
                        "The selected dentist already has an appointment at the selected date and time. Please choose another time."
                );

                return;
            }

            // -------------------------------------------------
            // SUCCESS
            // -------------------------------------------------
            response.sendRedirect(
                    request.getContextPath()
                    + "/PatientAppointmentsServlet?success=booked"
            );

        } catch (IllegalArgumentException e) {

            // IMPORTANT:
            // Show the actual validation message instead
            // of displaying only "Invalid appointment".
            redirectError(
                    request,
                    response,
                    e.getMessage()
            );

        } catch (SQLException e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "A database error occurred while submitting your appointment request."
            );
        }
    }

    // =========================================================
    // CLEAN INPUT
    // =========================================================
    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }

    // =========================================================
    // ERROR REDIRECT
    // =========================================================
    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        if (message == null
                || message.trim().isEmpty()) {

            message
                    = "Please check the appointment details.";
        }

        String encoded
                = URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                );

        response.sendRedirect(
                request.getContextPath()
                + "/BookAppointmentServlet"
                + "?error=validation"
                + "&errorMessage="
                + encoded
        );
    }
}
