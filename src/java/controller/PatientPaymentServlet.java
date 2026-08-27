package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Payment;

import service.NotificationService;
import service.PaymentService;

import service.impl.NotificationServiceImpl;
import service.impl.PaymentServiceImpl;

import service.decorator.LoggingNotificationServiceDecorator;

import java.io.IOException;

@WebServlet("/PatientPaymentServlet")
public class PatientPaymentServlet
        extends HttpServlet {

    private final PaymentService paymentService =
            new PaymentServiceImpl();

    /*
     * Notification Service
     *
     * Decorator Pattern:
     *
     * LoggingNotificationServiceDecorator
     *              ↓
     * NotificationServiceImpl
     *              ↓
     * NotificationDAO
     */
    private final NotificationService notificationService =
            new LoggingNotificationServiceDecorator(
                    new NotificationServiceImpl()
            );


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);


        /* =====================================================
           PATIENT LOGIN CHECK
           ===================================================== */

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    "Login.jsp"
            );

            return;
        }


        /* =====================================================
           ROLE CHECK
           ===================================================== */

        String role =
                String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }


        try {


            /* =================================================
               PATIENT INFORMATION
               ================================================= */

            Object userIdObject =
                    session.getAttribute("userId");

            if (userIdObject == null) {

                response.sendRedirect(
                        "Login.jsp?error=session"
                );

                return;
            }

            int patientId;

            if (userIdObject instanceof Integer) {

                patientId =
                        (Integer) userIdObject;

            } else {

                patientId =
                        Integer.parseInt(
                                String.valueOf(
                                        userIdObject
                                )
                        );
            }


            String patientName =
                    String.valueOf(
                            session.getAttribute(
                                    "userName"
                            )
                    );


            /* =================================================
               FORM DATA
               ================================================= */

            String appointmentIdParameter =
                    request.getParameter(
                            "appointmentId"
                    );

            String appointmentNo =
                    request.getParameter(
                            "appointmentNo"
                    );

            String paymentType =
                    request.getParameter(
                            "paymentType"
                    );

            String paymentMethod =
                    request.getParameter(
                            "paymentMethod"
                    );


            /* =================================================
               VALIDATE APPOINTMENT ID
               ================================================= */

            if (appointmentIdParameter == null
                    || appointmentIdParameter.trim().isEmpty()) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            int appointmentId;

            try {

                appointmentId =
                        Integer.parseInt(
                                appointmentIdParameter
                        );

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /* =================================================
               VALIDATE APPOINTMENT NUMBER
               ================================================= */

            if (appointmentNo == null
                    || appointmentNo.trim().isEmpty()) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            appointmentNo =
                    appointmentNo.trim();


            /* =================================================
               VALIDATE PAYMENT TYPE
               ================================================= */

            if (paymentType == null
                    || paymentType.trim().isEmpty()) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /* =================================================
               VALIDATE PAYMENT METHOD
               ================================================= */

            if (paymentMethod == null
                    || paymentMethod.trim().isEmpty()) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=method"
                );

                return;
            }


            paymentType =
                    paymentType.trim();

            paymentMethod =
                    paymentMethod.trim();


            /* =================================================
               GET APPOINTMENT / PAYMENT INFORMATION
               ================================================= */

            Payment payment =
                    paymentService.getAppointment(
                            appointmentNo
                    );


            /* =================================================
               SECURITY VALIDATION
               ================================================= */

            if (payment == null) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /*
             * Make sure this appointment belongs
             * to the currently logged-in patient.
             */
            if (payment.getPatientId()
                    != patientId) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /*
             * Make sure the appointment ID
             * also matches.
             */
            if (payment.getAppointmentId()
                    != appointmentId) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /* =================================================
               SET PAYMENT INFORMATION
               ================================================= */

            payment.setPatientId(
                    patientId
            );

            payment.setAppointmentId(
                    appointmentId
            );

            payment.setPaymentMethod(
                    paymentMethod
            );


            /* =================================================
               PROCESS PAYMENT
               ================================================= */

            boolean success;


            if ("CONSULTATION".equalsIgnoreCase(
                    paymentType
            )) {

                success =
                        paymentService.payConsultation(
                                payment
                        );

            } else if ("TREATMENT".equalsIgnoreCase(
                    paymentType
            )) {

                success =
                        paymentService.payTreatment(
                                payment
                        );

            } else {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }


            /* =================================================
               PAYMENT SUCCESS
               ================================================= */

            if (success) {

                String readableType;


                if ("CONSULTATION".equalsIgnoreCase(
                        paymentType
                )) {

                    readableType =
                            "Consultation Fee";

                } else {

                    readableType =
                            "Treatment Payment";
                }


                String message =
                        "Payment received from "
                        + patientName
                        + ". Appointment: "
                        + appointmentNo
                        + ". Payment Type: "
                        + readableType
                        + ". Amount Paid: Rs. "
                        + payment.getAmount()
                        + ". Payment Method: "
                        + paymentMethod
                        + ".";


                /* =============================================
                   NOTIFY CASHIERS
                   ============================================= */

                /*
                 * We use the Notification Service instead
                 * of directly accessing NotificationDAO.
                 *
                 * The service layer is also wrapped with
                 * the Decorator Pattern.
                 */
                notificationService.create(
                        0,
                        "cashier",
                        "New Patient Payment Received",
                        message,
                        appointmentId
                );


                /* =============================================
                   PATIENT SUCCESS
                   ============================================= */

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=success"
                );

            } else {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=failed"
                );
            }


        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patient-dashboard.jsp"
                    + "?payment=invalid"
            );


        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patient-dashboard.jsp"
                    + "?payment=error"
            );
        }
    }
}