package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Appointment;

import service.AppointmentService;
import service.PaymentService;

import service.impl.AppointmentServiceImpl;
import service.impl.PaymentServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/PatientPaymentPageServlet")
public class PatientPaymentPageServlet
        extends HttpServlet {

    private final AppointmentService appointmentService
            = new AppointmentServiceImpl();

    private final PaymentService paymentService
            = new PaymentServiceImpl();

    /*
     * Consultation fee used by the current
     * PaymentService implementation.
     */
    private static final BigDecimal CONSULTATION_FEE
            = new BigDecimal("2000.00");

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session
                = request.getSession(false);

        /*
         * =====================================================
         * SESSION CHECK
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
         * ROLE CHECK
         * =====================================================
         */
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

            int patientId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

            /*
             * =================================================
             * GET PATIENT APPOINTMENTS
             * =================================================
             */
            List<Appointment> appointments
                    = appointmentService
                            .getPatientAppointments(
                                    patientId
                            );

            /*
             * Maps used by JSP.
             *
             * appointmentId -> consultation paid
             * appointmentId -> treatment paid
             * appointmentId -> treatment price
             */
            Map<Integer, BigDecimal> consultationPaidMap
                    = new HashMap<>();

            Map<Integer, BigDecimal> treatmentPaidMap
                    = new HashMap<>();

            Map<Integer, BigDecimal> treatmentAmountMap
                    = new HashMap<>();

            /*
             * =================================================
             * CHECK PAYMENT STATUS FOR EVERY APPOINTMENT
             * =================================================
             */
            if (appointments != null) {

                for (Appointment appointment
                        : appointments) {

                    if (appointment == null) {
                        continue;
                    }

                    String status
                            = appointment.getStatus();

                    /*
                     * Only confirmed appointments
                     * are eligible for payment.
                     */
                    if (!"CONFIRMED".equalsIgnoreCase(
                            status)) {

                        continue;
                    }

                    int appointmentId
                            = appointment.getId();

                    /*
                     * Consultation already paid.
                     */
                    BigDecimal consultationPaid
                            = paymentService
                                    .getConsultationPaid(
                                            appointmentId
                                    );

                    if (consultationPaid == null) {

                        consultationPaid
                                = BigDecimal.ZERO;
                    }

                    /*
                     * Treatment already paid.
                     */
                    BigDecimal treatmentPaid
                            = paymentService
                                    .getTreatmentPaid(
                                            appointmentId
                                    );

                    if (treatmentPaid == null) {

                        treatmentPaid
                                = BigDecimal.ZERO;
                    }

                    /*
                     * Treatment total amount.
                     */
                    BigDecimal treatmentAmount
                            = paymentService
                                    .getTreatmentAmount(
                                            appointment
                                                    .getTreatmentType()
                                    );

                    if (treatmentAmount == null) {

                        treatmentAmount
                                = BigDecimal.ZERO;
                    }

                    consultationPaidMap.put(
                            appointmentId,
                            consultationPaid
                    );

                    treatmentPaidMap.put(
                            appointmentId,
                            treatmentPaid
                    );

                    treatmentAmountMap.put(
                            appointmentId,
                            treatmentAmount
                    );
                }
            }

            /*
             * =================================================
             * SEND DATA TO JSP
             * =================================================
             */
            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.setAttribute(
                    "consultationPaidMap",
                    consultationPaidMap
            );

            request.setAttribute(
                    "treatmentPaidMap",
                    treatmentPaidMap
            );

            request.setAttribute(
                    "treatmentAmountMap",
                    treatmentAmountMap
            );

            request.setAttribute(
                    "consultationFee",
                    CONSULTATION_FEE
            );

            /*
             * =================================================
             * FORWARD
             * =================================================
             */
            request.getRequestDispatcher(
                    "/patient-payment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patient-dashboard.jsp?payment=error"
            );
        }
    }
}
