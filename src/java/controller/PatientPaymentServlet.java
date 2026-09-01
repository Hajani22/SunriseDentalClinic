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

    private final PaymentService paymentService
            = new PaymentServiceImpl();

    private final NotificationService notificationService
            = new LoggingNotificationServiceDecorator(
                    new NotificationServiceImpl()
            );

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session
                = request.getSession(false);

        /*
         * =====================================================
         * SESSION VALIDATION
         * =====================================================
         */
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    "Login.jsp?error=session"
            );

            return;
        }

        /*
         * =====================================================
         * ROLE VALIDATION
         * =====================================================
         */
        String userRole
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(
                userRole)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }

        try {

            int patientId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

            String patientName
                    = String.valueOf(
                            session.getAttribute(
                                    "userName"
                            )
                    );

            String appointmentIdParam
                    = request.getParameter(
                            "appointmentId"
                    );

            String appointmentNo
                    = clean(
                            request.getParameter(
                                    "appointmentNo"
                            )
                    );

            String paymentType
                    = clean(
                            request.getParameter(
                                    "paymentType"
                            )
                    );

            String paymentMethod
                    = clean(
                            request.getParameter(
                                    "paymentMethod"
                            )
                    );

            String cardNumber
                    = clean(
                            request.getParameter(
                                    "cardNumber"
                            )
                    );

            String expiry
                    = clean(
                            request.getParameter(
                                    "expiry"
                            )
                    );

            String cvv
                    = clean(
                            request.getParameter(
                                    "cvv"
                            )
                    );


            /*
             * =================================================
             * REQUIRED FIELDS
             * =================================================
             */
            if (appointmentIdParam == null
                    || appointmentNo == null
                    || paymentType == null
                    || paymentMethod == null
                    || cardNumber == null
                    || expiry == null
                    || cvv == null) {

                redirect(
                        request,
                        response,
                        "invalid"
                );

                return;
            }

            int appointmentId;

            try {

                appointmentId
                        = Integer.parseInt(
                                appointmentIdParam
                        );

            } catch (NumberFormatException e) {

                redirect(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            /*
             * =================================================
             * CARD ONLY
             * =================================================
             */
            if (!"CARD".equalsIgnoreCase(
                    paymentMethod)) {

                redirect(
                        request,
                        response,
                        "method"
                );

                return;
            }


            /*
             * =================================================
             * CARD VALIDATION
             *
             * IMPORTANT:
             * We validate the format only.
             * We do NOT store card number/CVV.
             * =================================================
             */
            String normalizedCard
                    = cardNumber.replace(
                            " ",
                            ""
                    );

            if (!normalizedCard.matches(
                    "\\d{16}"
            )) {

                redirect(
                        request,
                        response,
                        "card"
                );

                return;
            }

            if (!expiry.matches(
                    "\\d{2}/\\d{2}"
            )) {

                redirect(
                        request,
                        response,
                        "card"
                );

                return;
            }

            if (!cvv.matches(
                    "\\d{3,4}"
            )) {

                redirect(
                        request,
                        response,
                        "card"
                );

                return;
            }


            /*
             * =================================================
             * VALID PAYMENT TYPE
             * =================================================
             */
            if (!"CONSULTATION".equalsIgnoreCase(
                    paymentType)
                    && !"TREATMENT".equalsIgnoreCase(
                            paymentType)) {

                redirect(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            /*
             * =================================================
             * GET APPOINTMENT
             * =================================================
             */
            Payment payment
                    = paymentService.getAppointment(
                            appointmentNo
                    );

            if (payment == null) {

                redirect(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            /*
             * =================================================
             * SECURITY CHECK
             * =================================================
             */
            if (payment.getPatientId()
                    != patientId
                    || payment.getAppointmentId()
                    != appointmentId) {

                redirect(
                        request,
                        response,
                        "invalid"
                );

                return;
            }


            /*
             * =================================================
             * SET PAYMENT DATA
             * =================================================
             */
            payment.setPatientId(
                    patientId
            );

            payment.setAppointmentId(
                    appointmentId
            );

            payment.setPaymentMethod(
                    "CARD"
            );


            /*
             * =================================================
             * PROCESS PAYMENT
             *
             * PaymentService itself checks whether
             * the selected payment type has already
             * been paid.
             * =================================================
             */
            boolean success;

            if ("CONSULTATION".equalsIgnoreCase(
                    paymentType)) {

                success
                        = paymentService
                                .payConsultation(
                                        payment
                                );

            } else {

                success
                        = paymentService
                                .payTreatment(
                                        payment
                                );
            }


            /*
             * =================================================
             * FAILED / DUPLICATE PAYMENT
             * =================================================
             */
            if (!success) {

                /*
                 * IMPORTANT:
                 * Go back through PageServlet.
                 *
                 * It will re-check database status.
                 */
                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientPaymentPageServlet?payment=already"
                );

                return;
            }


            /*
             * =================================================
             * NOTIFICATION
             * =================================================
             */
            String readableType;

            if ("CONSULTATION".equalsIgnoreCase(
                    paymentType)) {

                readableType
                        = "Consultation Fee";

            } else {

                readableType
                        = "Treatment Payment";
            }

            String notificationMessage
                    = "Payment received from "
                    + patientName
                    + ". Appointment: "
                    + appointmentNo
                    + ". Payment Type: "
                    + readableType
                    + ". Amount Paid: Rs. "
                    + payment.getAmount()
                    + ". Payment Method: CARD.";

            try {

                notificationService.create(
                        0,
                        "cashier",
                        "New Patient Payment Received",
                        notificationMessage,
                        appointmentId
                );

            } catch (Exception notificationError) {

                /*
                 * Notification failure should NOT
                 * make the successful payment fail.
                 */
                notificationError.printStackTrace();
            }


            /*
             * =================================================
             * SUCCESS
             *
             * IMPORTANT:
             * Return to PageServlet so it reloads
             * payment status from MySQL.
             * =================================================
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/PatientPaymentPageServlet?success=payment"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/PatientPaymentPageServlet?payment=error"
            );
        }
    }


    /*
     * =========================================================
     * REDIRECT HELPER
     * =========================================================
     */
    private void redirect(
            HttpServletRequest request,
            HttpServletResponse response,
            String error)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/PatientPaymentPageServlet?payment="
                + error
        );
    }


    /*
     * =========================================================
     * CLEAN INPUT
     * =========================================================
     */
    private String clean(
            String value) {

        if (value == null) {
            return null;
        }

        String result
                = value.trim();

        return result.isEmpty()
                ? null
                : result;
    }
}
