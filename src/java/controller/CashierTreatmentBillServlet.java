package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Payment;

import service.PaymentService;
import service.impl.PaymentServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/CashierTreatmentBillServlet")
public class CashierTreatmentBillServlet
        extends HttpServlet {

    private final PaymentService service
            = new PaymentServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!"cashier".equals(
                request.getSession()
                        .getAttribute("userRole")
        )) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }

        String appointmentNo
                = request.getParameter(
                        "appointmentNo"
                );

        if (appointmentNo != null
                && !appointmentNo.trim().isEmpty()) {

            try {

                Payment appointment
                        = service.getAppointment(
                                appointmentNo
                        );

                if (appointment == null) {

                    request.setAttribute(
                            "error",
                            "Confirmed appointment not found."
                    );

                } else {

                    BigDecimal treatment
                            = service.getTreatmentAmount(
                                    appointment.getTreatmentType()
                            );

                    BigDecimal consultationPaid
                            = service.getConsultationPaid(
                                    appointment.getAppointmentId()
                            );

                    BigDecimal treatmentPaid
                            = service.getTreatmentPaid(
                                    appointment.getAppointmentId()
                            );

                    BigDecimal balance
                            = treatment.subtract(
                                    treatmentPaid
                            );

                    request.setAttribute(
                            "appointment",
                            appointment
                    );

                    request.setAttribute(
                            "treatmentAmount",
                            treatment
                    );

                    request.setAttribute(
                            "consultationPaid",
                            consultationPaid
                    );

                    request.setAttribute(
                            "treatmentPaid",
                            treatmentPaid
                    );

                    request.setAttribute(
                            "balance",
                            balance
                    );
                }

            } catch (Exception e) {

                e.printStackTrace();

                request.setAttribute(
                        "error",
                        "Unable to load treatment billing."
                );
            }
        }

        request.getRequestDispatcher(
                "/cashier-treatment-bill.jsp"
        ).forward(
                request,
                response
        );
    }
}
