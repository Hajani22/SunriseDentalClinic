package service.impl;

import dao.NotificationDAO;
import dao.PatientFeedbackDAO;

import dao.impl.NotificationDAOImpl;
import dao.impl.PatientFeedbackDAOImpl;

import model.PatientFeedback;

import service.PatientFeedbackService;

import java.sql.SQLException;
import java.util.List;

public class PatientFeedbackServiceImpl
        implements PatientFeedbackService {

    private final PatientFeedbackDAO feedbackDAO
            = new PatientFeedbackDAOImpl();

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();


    /*
     * =========================================================
     * SUBMIT FEEDBACK
     * =========================================================
     */
    @Override
    public boolean submitFeedback(
            PatientFeedback feedback)
            throws SQLException {


        /*
         * =====================================================
         * BASIC VALIDATION
         * =====================================================
         */
        if (feedback == null) {

            throw new IllegalArgumentException(
                    "Feedback is required."
            );
        }

        if (feedback.getAppointmentId() <= 0) {

            throw new IllegalArgumentException(
                    "Invalid appointment."
            );
        }

        if (feedback.getPatientId() <= 0) {

            throw new IllegalArgumentException(
                    "Invalid patient."
            );
        }

        if (feedback.getRating() < 1
                || feedback.getRating() > 5) {

            throw new IllegalArgumentException(
                    "Rating must be between 1 and 5."
            );
        }


        /*
         * =====================================================
         * COMMENT VALIDATION
         * =====================================================
         */
        String comments
                = feedback.getComments();

        if (comments != null) {

            comments
                    = comments.trim();

            if (comments.length() > 1000) {

                throw new IllegalArgumentException(
                        "Feedback cannot exceed 1000 characters."
                );
            }

            if (comments.isEmpty()) {

                comments = null;
            }

            feedback.setComments(
                    comments
            );
        }


        /*
         * =====================================================
         * CHECK DUPLICATE
         * =====================================================
         */
        if (feedbackDAO.hasFeedback(
                feedback.getAppointmentId(),
                feedback.getPatientId()
        )) {

            throw new IllegalArgumentException(
                    "Feedback has already been submitted "
                    + "for this appointment."
            );
        }


        /*
         * =====================================================
         * SAVE FEEDBACK
         * =====================================================
         */
        boolean saved
                = feedbackDAO.addFeedback(
                        feedback
                );

        if (!saved) {

            return false;
        }


        /*
         * =====================================================
         * ADMIN NOTIFICATION
         * =====================================================
         */
        try {

            String patientName
                    = feedback.getPatientName();

            if (patientName == null
                    || patientName.trim().isEmpty()) {

                patientName
                        = "A patient";
            }


            /*
             * Create stars.
             */
            StringBuilder stars
                    = new StringBuilder();

            for (int i = 0;
                    i < feedback.getRating();
                    i++) {

                stars.append("★");
            }


            /*
             * Comment.
             */
            String commentText
                    = feedback.getComments();

            if (commentText == null
                    || commentText.trim().isEmpty()) {

                commentText
                        = "No written comment provided.";
            }


            /*
             * IMPORTANT:
             *
             * Use appointment NUMBER in the notification,
             * not the internal database ID.
             */
            String appointmentNumber
                    = feedback.getAppointmentNo();

            if (appointmentNumber == null
                    || appointmentNumber.trim().isEmpty()) {

                appointmentNumber
                        = "Appointment #"
                        + feedback.getAppointmentId();
            }


            /*
             * Create admin message.
             */
            String message
                    = patientName
                    + " submitted new patient feedback. "
                    + "Appointment: "
                    + appointmentNumber
                    + ". Rating: "
                    + stars
                    + ". Comment: "
                    + commentText;


            /*
             * Get all administrators.
             */
            List<Integer> adminIds
                    = notificationDAO.getUserIdsByRole(
                            "admin"
                    );


            /*
             * Send notification to every admin.
             */
            if (adminIds != null) {

                for (Integer adminId
                        : adminIds) {

                    if (adminId != null
                            && adminId > 0) {

                        try {

                            notificationDAO.create(
                                    adminId,
                                    "admin",
                                    "New Patient Feedback",
                                    message,
                                    feedback.getAppointmentId()
                            );

                        } catch (SQLException e) {

                            /*
                             * Feedback is already saved.
                             *
                             * Therefore notification failure
                             * should not cancel feedback.
                             */
                            System.err.println(
                                    "Unable to send feedback "
                                    + "notification to admin "
                                    + adminId
                            );

                            e.printStackTrace();
                        }
                    }
                }
            }

        } catch (Exception e) {

            /*
             * Feedback has already been saved.
             */
            System.err.println(
                    "Admin feedback notification failed."
            );

            e.printStackTrace();
        }

        return true;
    }


    /*
     * =========================================================
     * CHECK FEEDBACK
     * =========================================================
     */
    @Override
    public boolean hasFeedback(
            int appointmentId,
            int patientId)
            throws SQLException {

        return feedbackDAO.hasFeedback(
                appointmentId,
                patientId
        );
    }


    /*
     * =========================================================
     * GET PATIENT FEEDBACK
     * =========================================================
     */
    @Override
    public List<PatientFeedback>
            getPatientFeedback(
                    int patientId)
            throws SQLException {

        return feedbackDAO.getPatientFeedback(
                patientId
        );
    }


    /*
     * =========================================================
     * GET ALL FEEDBACK
     * =========================================================
     */
    @Override
    public List<PatientFeedback>
            getAllFeedback()
            throws SQLException {

        return feedbackDAO.getAllFeedback();
    }
}
