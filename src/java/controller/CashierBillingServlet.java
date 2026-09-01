package controller;

import dao.PaymentDAO;
import dao.impl.PaymentDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Bill;
import model.Payment;

import service.BillingService;
import service.impl.BillingServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@WebServlet("/CashierBillingServlet")
public class CashierBillingServlet extends HttpServlet {

    private final BillingService billingService
            = new BillingServiceImpl();

    private final PaymentDAO paymentDAO
            = new PaymentDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCashier(request)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );
            return;
        }

        String appointmentNo
                = clean(request.getParameter("appointmentNo"));

        if (appointmentNo != null) {

            try {

                Bill appointment
                        = billingService.findAppointmentForBilling(
                                appointmentNo
                        );

                if (appointment == null) {

                    request.setAttribute(
                            "error",
                            "Confirmed appointment not found. Please check the appointment number."
                    );

                } else {

                    /*
                     * FIRST CHECK:
                     * Is there already a bill?
                     *
                     * If yes, NEVER allow another payment.
                     */
                    Bill existingBill
                            = billingService.getBillByAppointmentId(
                                    appointment.getAppointmentId()
                            );

                    if (existingBill != null) {

                        existingBill.setPaymentStatus("PAID");

                        request.setAttribute(
                                "bill",
                                existingBill
                        );

                        request.setAttribute(
                                "alreadyPaid",
                                true
                        );

                    } else {

                        /*
                         * Get treatment + consultation prices.
                         */
                        Bill prepared
                                = billingService.prepareBill(
                                        appointmentNo,
                                        BigDecimal.ZERO
                                );

                        if (prepared == null) {

                            request.setAttribute(
                                    "error",
                                    "Unable to prepare billing information."
                            );

                        } else {

                            BigDecimal treatment
                                    = safe(prepared.getTreatmentAmount());

                            BigDecimal consultation
                                    = safe(prepared.getConsultationFee());

                            BigDecimal gross
                                    = treatment.add(consultation);

                            /*
                             * Get all PAID payments for this appointment.
                             */
                            BigDecimal alreadyPaid
                                    = getPaidAmount(
                                            appointment.getAppointmentId()
                                    );

                            String paymentMethod
                                    = getPaymentMethod(
                                            appointment.getAppointmentId()
                                    );

                            /*
                             * IMPORTANT:
                             * If paid amount >= gross amount,
                             * this appointment is FULLY PAID.
                             */
                            if (alreadyPaid.compareTo(gross) >= 0) {

                                prepared.setPaidAmount(
                                        alreadyPaid
                                );

                                prepared.setDiscount(
                                        BigDecimal.ZERO
                                );

                                prepared.setTotalAmount(
                                        gross
                                );

                                prepared.setPaymentMethod(
                                        paymentMethod
                                );

                                prepared.setPaymentStatus(
                                        "PAID"
                                );

                                request.setAttribute(
                                        "bill",
                                        prepared
                                );

                                request.setAttribute(
                                        "alreadyPaid",
                                        true
                                );

                            } else {

                                /*
                                 * Remaining balance.
                                 */
                                BigDecimal balance
                                        = gross.subtract(
                                                alreadyPaid
                                        );

                                if (balance.compareTo(
                                        BigDecimal.ZERO
                                ) < 0) {

                                    balance
                                            = BigDecimal.ZERO;
                                }

                                prepared.setPaidAmount(
                                        alreadyPaid
                                );

                                prepared.setTotalAmount(
                                        balance
                                );

                                prepared.setPaymentMethod(
                                        paymentMethod
                                );

                                prepared.setPaymentStatus(
                                        "DUE"
                                );

                                request.setAttribute(
                                        "bill",
                                        prepared
                                );

                                request.setAttribute(
                                        "alreadyPaid",
                                        false
                                );
                            }
                        }
                    }
                }

            } catch (Exception e) {

                e.printStackTrace();

                request.setAttribute(
                        "error",
                        "Unable to load billing information."
                );
            }
        }

        /*
         * Recent bills.
         */
        try {

            request.setAttribute(
                    "recentBills",
                    billingService.getRecentBills(10)
            );

        } catch (Exception e) {

            e.printStackTrace();
        }

        request.getRequestDispatcher(
                "/cashier-billing.jsp"
        ).forward(
                request,
                response
        );
    }

    /*
     * =========================================================
     * GET TOTAL PAID FOR APPOINTMENT
     * =========================================================
     */
    private BigDecimal getPaidAmount(
            int appointmentId)
            throws Exception {

        BigDecimal total
                = BigDecimal.ZERO;

        List<Payment> payments
                = paymentDAO.getAllPayments();

        for (Payment payment : payments) {

            if (payment.getAppointmentId()
                    == appointmentId
                    && "PAID".equalsIgnoreCase(
                            payment.getPaymentStatus()
                    )) {

                if (payment.getAmount() != null) {

                    total
                            = total.add(
                                    payment.getAmount()
                            );
                }
            }
        }

        return total;
    }

    /*
     * =========================================================
     * GET PAYMENT METHOD
     * =========================================================
     */
    private String getPaymentMethod(
            int appointmentId)
            throws Exception {

        String method = "NOT PAID";

        List<Payment> payments
                = paymentDAO.getAllPayments();

        for (Payment payment : payments) {

            if (payment.getAppointmentId()
                    == appointmentId
                    && "PAID".equalsIgnoreCase(
                            payment.getPaymentStatus()
                    )) {

                if (payment.getPaymentMethod() != null) {

                    method
                            = payment.getPaymentMethod();
                }
            }
        }

        return method;
    }

    /*
     * =========================================================
     * SAFE BIG DECIMAL
     * =========================================================
     */
    private BigDecimal safe(BigDecimal value) {

        if (value == null) {
            return BigDecimal.ZERO;
        }

        return value.setScale(
                2,
                RoundingMode.HALF_UP
        );
    }

    /*
     * =========================================================
     * CLEAN INPUT
     * =========================================================
     */
    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }

    /*
     * =========================================================
     * CASHIER SECURITY
     * =========================================================
     */
    private boolean isCashier(
            HttpServletRequest request) {

        HttpSession session
                = request.getSession(false);

        if (session == null) {
            return false;
        }

        if (session.getAttribute("user") == null) {
            return false;
        }

        return "cashier".equalsIgnoreCase(
                String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                )
        );
    }
}
