package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.NotificationDAO;
import dao.impl.NotificationDAOImpl;

import model.Payment;

import service.PaymentService;
import service.impl.PaymentServiceImpl;

import java.io.IOException;

@WebServlet("/PatientPaymentServlet")
public class PatientPaymentServlet
        extends HttpServlet {

    private final PaymentService service
            = new PaymentServiceImpl();

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session
                = request.getSession(false);


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

        String role
                = String.valueOf(
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
            int patientId
                    = (Integer) session.getAttribute(
                            "userId"
                    );

            String patientName
                    = String.valueOf(
                            session.getAttribute(
                                    "userName"
                            )
                    );


            /* =================================================
               FORM DATA
               ================================================= */
            int appointmentId
                    = Integer.parseInt(
                            request.getParameter(
                                    "appointmentId"
                            )
                    );

            String appointmentNo
                    = request.getParameter(
                            "appointmentNo"
                    );

            String paymentType
                    = request.getParameter(
                            "paymentType"
                    );

            String paymentMethod
                    = request.getParameter(
                            "paymentMethod"
                    );

            if (paymentMethod == null
                    || paymentMethod.trim().isEmpty()) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=method"
                );

                return;
            }


            /* =================================================
               GET APPOINTMENT
               ================================================= */
            Payment payment
                    = service.getAppointment(
                            appointmentNo
                    );

            if (payment == null
                    || payment.getPatientId()
                    != patientId
                    || payment.getAppointmentId()
                    != appointmentId) {

                response.sendRedirect(
                        "patient-dashboard.jsp"
                        + "?payment=invalid"
                );

                return;
            }

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

                success
                        = service.payConsultation(
                                payment
                        );

            } else if ("TREATMENT".equalsIgnoreCase(
                    paymentType
            )) {

                success
                        = service.payTreatment(
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

                    readableType
                            = "Consultation Fee";

                } else {

                    readableType
                            = "Treatment Payment";
                }

                String message
                        = "Payment received from "
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
                   SEND NOTIFICATION TO ALL CASHIERS
                   ============================================= */
                notificationDAO.createForRole(
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

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patient-dashboard.jsp"
                    + "?payment=error"
            );
        }
    }
}
