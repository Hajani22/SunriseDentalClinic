package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.PatientFeedbackDAO;
import dao.impl.PatientFeedbackDAOImpl;

import model.Appointment;
import model.PatientFeedback;

import service.AppointmentService;
import service.PatientFeedbackService;

import service.impl.AppointmentServiceImpl;
import service.impl.PatientFeedbackServiceImpl;

import java.io.IOException;
import java.util.List;

@WebServlet("/PatientFeedbackServlet")
public class PatientFeedbackServlet
        extends HttpServlet {

    private final PatientFeedbackService feedbackService
            = new PatientFeedbackServiceImpl();

    private final PatientFeedbackDAO feedbackDAO
            = new PatientFeedbackDAOImpl();

    private final AppointmentService appointmentService
            = new AppointmentServiceImpl();


    /*
     * =========================================================
     * GET
     * =========================================================
     *
     * Display the feedback page.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);


        /*
         * -----------------------------------------------------
         * CHECK LOGIN
         * -----------------------------------------------------
         */
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    "Login.jsp?error=login"
            );

            return;
        }


        /*
         * -----------------------------------------------------
         * CHECK ROLE
         * -----------------------------------------------------
         */
        String role
                = String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }


        /*
         * -----------------------------------------------------
         * GET PATIENT ID
         * -----------------------------------------------------
         */
        Object userIdObject
                = session.getAttribute("userId");

        if (userIdObject == null) {

            response.sendRedirect(
                    "Login.jsp?error=session"
            );

            return;
        }

        int patientId
                = Integer.parseInt(
                        userIdObject.toString()
                );

        try {

            /*
             * Get this patient's appointments.
             *
             * The JSP will display appointmentNo,
             * not the internal ID.
             */
            List<Appointment> appointments
                    = appointmentService
                            .getPatientAppointments(
                                    patientId
                            );

            request.setAttribute(
                    "appointments",
                    appointments
            );


            /*
             * Get patient's previous feedback.
             */
            List<PatientFeedback> feedbackList
                    = feedbackService
                            .getPatientFeedback(
                                    patientId
                            );

            request.setAttribute(
                    "feedbackList",
                    feedbackList
            );


            /*
             * Forward to JSP.
             */
            request.getRequestDispatcher(
                    "/patient-feedback.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            getServletContext().log(
                    "Unable to load patient feedback page.",
                    e
            );

            response.sendRedirect(
                    "patient-dashboard.jsp?error=database"
            );
        }
    }


    /*
     * =========================================================
     * POST
     * =========================================================
     *
     * Submit feedback.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );

        HttpSession session
                = request.getSession(false);


        /*
         * -----------------------------------------------------
         * CHECK LOGIN
         * -----------------------------------------------------
         */
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    "Login.jsp?error=login"
            );

            return;
        }


        /*
         * -----------------------------------------------------
         * CHECK ROLE
         * -----------------------------------------------------
         */
        String role
                = String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }


        /*
         * -----------------------------------------------------
         * GET PATIENT ID FROM SESSION
         * -----------------------------------------------------
         */
        Object userIdObject
                = session.getAttribute("userId");

        if (userIdObject == null) {

            response.sendRedirect(
                    "Login.jsp?error=session"
            );

            return;
        }

        int patientId
                = Integer.parseInt(
                        userIdObject.toString()
                );


        /*
         * -----------------------------------------------------
         * GET FORM VALUES
         * -----------------------------------------------------
         */
        String appointmentNo
                = request.getParameter(
                        "appointmentNo"
                );

        String ratingValue
                = request.getParameter(
                        "rating"
                );

        String comments
                = request.getParameter(
                        "comments"
                );

        try {


            /*
             * -------------------------------------------------
             * VALIDATE APPOINTMENT NUMBER
             * -------------------------------------------------
             */
            if (appointmentNo == null
                    || appointmentNo.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Please select an appointment."
                );
            }

            appointmentNo
                    = appointmentNo.trim();


            /*
             * -------------------------------------------------
             * VALIDATE RATING
             * -------------------------------------------------
             */
            if (ratingValue == null
                    || ratingValue.trim().isEmpty()) {

                throw new IllegalArgumentException(
                        "Please select a rating."
                );
            }

            int rating
                    = Integer.parseInt(
                            ratingValue
                    );

            if (rating < 1
                    || rating > 5) {

                throw new IllegalArgumentException(
                        "Rating must be between 1 and 5."
                );
            }


            /*
             * -------------------------------------------------
             * IMPORTANT STEP
             * -------------------------------------------------
             *
             * Convert:
             *
             * SDC-F3B3A0AB
             *
             * into:
             *
             * appointments.id
             *
             * AND verify that the appointment belongs
             * to this logged-in patient.
             */
            int appointmentId
                    = feedbackDAO
                            .findAppointmentIdByNumberAndPatient(
                                    appointmentNo,
                                    patientId
                            );

            if (appointmentId <= 0) {

                throw new IllegalArgumentException(
                        "Invalid appointment number. "
                        + "Please select one of your appointments."
                );
            }


            /*
             * -------------------------------------------------
             * CHECK DUPLICATE BEFORE INSERT
             * -------------------------------------------------
             */
            if (feedbackDAO.hasFeedback(
                    appointmentId,
                    patientId
            )) {

                throw new IllegalArgumentException(
                        "Feedback has already been submitted "
                        + "for this appointment."
                );
            }


            /*
             * -------------------------------------------------
             * CREATE FEEDBACK OBJECT
             * -------------------------------------------------
             */
            PatientFeedback feedback
                    = new PatientFeedback();

            feedback.setAppointmentId(
                    appointmentId
            );

            feedback.setPatientId(
                    patientId
            );

            feedback.setRating(
                    rating
            );

            feedback.setComments(
                    comments
            );


            /*
             * Keep the user-facing appointment number.
             *
             * This is used in the admin notification.
             */
            feedback.setAppointmentNo(
                    appointmentNo
            );


            /*
             * Get patient name from session if available.
             */
            Object userNameObject
                    = session.getAttribute("userName");

            if (userNameObject != null) {

                feedback.setPatientName(
                        userNameObject.toString()
                );
            }


            /*
             * -------------------------------------------------
             * SUBMIT
             * -------------------------------------------------
             */
            boolean success
                    = feedbackService.submitFeedback(
                            feedback
                    );

            if (success) {

                response.sendRedirect(
                        "PatientFeedbackServlet"
                        + "?success=submitted"
                );

            } else {

                response.sendRedirect(
                        "PatientFeedbackServlet"
                        + "?error=database"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "PatientFeedbackServlet"
                    + "?error=rating"
            );

        } catch (IllegalArgumentException e) {

            /*
             * Send validation message through URL.
             */
            response.sendRedirect(
                    "PatientFeedbackServlet"
                    + "?error="
                    + java.net.URLEncoder.encode(
                            e.getMessage(),
                            java.nio.charset.StandardCharsets.UTF_8
                    )
            );

        } catch (Exception e) {

            getServletContext().log(
                    "Feedback submission failed.",
                    e
            );

            response.sendRedirect(
                    "PatientFeedbackServlet"
                    + "?error=database"
            );
        }
    }
}
