package controller;

import dao.PaymentDAO;
import dao.impl.PaymentDAOImpl;

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

@WebServlet({
    "/CashierPaymentServlet",
    "/CashierPaymentsServlet"
})
public class CashierPaymentServlet
        extends HttpServlet {

    private final PaymentDAO paymentDAO
            = new PaymentDAOImpl();

    private final BillingService billingService
            = new BillingServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        if (!isCashier(request)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            request.setAttribute(
                    "paymentRecords",
                    paymentDAO.getAllPayments()
            );

            request.getRequestDispatcher(
                    "/cashier-payments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/cashier-dashboard.jsp?error=payments"
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        if (!isCashier(request)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        String appointmentNo
                = clean(
                        request.getParameter(
                                "appointmentNo"
                        )
                );

        String paymentMethod
                = clean(
                        request.getParameter(
                                "paymentMethod"
                        )
                );

        String discountParam
                = clean(
                        request.getParameter(
                                "discountPercent"
                        )
                );

        try {

            if (appointmentNo == null) {

                redirectError(
                        request,
                        response,
                        "missing"
                );

                return;
            }

            /*
             * Find appointment.
             */
            Bill appointment
                    = billingService.findAppointmentForBilling(
                            appointmentNo
                    );

            if (appointment == null) {

                redirectError(
                        request,
                        response,
                        "bill"
                );

                return;
            }

            /*
             * =================================================
             * HARD DUPLICATE BILL CHECK
             * =================================================
             */
            Bill existingBill
                    = billingService.getBillByAppointmentId(
                            appointment.getAppointmentId()
                    );

            if (existingBill != null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/CashierReceiptServlet?id="
                        + existingBill.getId()
                );

                return;
            }

            /*
             * =================================================
             * GET BILL AMOUNTS
             * =================================================
             */
            Bill prepared
                    = billingService.prepareBill(
                            appointmentNo,
                            BigDecimal.ZERO
                    );

            if (prepared == null) {

                redirectError(
                        request,
                        response,
                        "bill"
                );

                return;
            }

            BigDecimal treatment
                    = safe(
                            prepared.getTreatmentAmount()
                    );

            BigDecimal consultation
                    = safe(
                            prepared.getConsultationFee()
                    );

            BigDecimal gross
                    = treatment.add(
                            consultation
                    );

            /*
             * =================================================
             * GET PATIENT PRE-PAYMENT
             * =================================================
             */
            BigDecimal alreadyPaid
                    = getPaidAmount(
                            appointment.getAppointmentId()
                    );

            /*
             * =================================================
             * DISCOUNT
             * =================================================
             */
            BigDecimal discountPercent
                    = parseDiscount(
                            discountParam
                    );

            BigDecimal discount
                    = gross
                            .multiply(
                                    discountPercent
                            )
                            .divide(
                                    new BigDecimal("100"),
                                    2,
                                    RoundingMode.HALF_UP
                            );

            BigDecimal finalAmount
                    = gross.subtract(
                            discount
                    );

            BigDecimal balance
                    = finalAmount.subtract(
                            alreadyPaid
                    );

            if (balance.compareTo(
                    BigDecimal.ZERO
            ) < 0) {

                balance
                        = BigDecimal.ZERO;
            }

            /*
             * =================================================
             * FULLY PAID BY PATIENT
             * =================================================
             */
            if (balance.compareTo(
                    BigDecimal.ZERO
            ) == 0
                    && alreadyPaid.compareTo(
                            BigDecimal.ZERO
                    ) > 0) {

                /*
                 * DO NOT CREATE ANOTHER PAYMENT.
                 *
                 * Send to prepaid receipt.
                 */
                response.sendRedirect(
                        request.getContextPath()
                        + "/CashierReceiptServlet?appointmentNo="
                        + appointmentNo
                );

                return;
            }

            /*
             * Payment method required only if
             * cashier still has a balance to collect.
             */
            if (paymentMethod == null) {

                redirectError(
                        request,
                        response,
                        "payment"
                );

                return;
            }

            /*
             * =================================================
             * CASHIER ID
             * =================================================
             */
            HttpSession session
                    = request.getSession(false);

            int cashierId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

            /*
             * =================================================
             * CREATE BILL
             * =================================================
             */
            Bill bill
                    = new Bill();

            bill.setAppointmentId(
                    appointment.getAppointmentId()
            );

            bill.setPatientId(
                    appointment.getPatientId()
            );

            bill.setCashierId(
                    cashierId
            );

            bill.setAppointmentNo(
                    appointment.getAppointmentNo()
            );

            bill.setPatientName(
                    appointment.getPatientName()
            );

            bill.setPatientPhone(
                    appointment.getPatientPhone()
            );

            bill.setDoctorName(
                    appointment.getDoctorName()
            );

            bill.setTreatmentType(
                    appointment.getTreatmentType()
            );

            bill.setAppointmentDate(
                    appointment.getAppointmentDate()
            );

            bill.setAppointmentTime(
                    appointment.getAppointmentTime()
            );

            bill.setTreatmentAmount(
                    treatment
            );

            bill.setConsultationFee(
                    consultation
            );

            bill.setDiscount(
                    discount
            );

            bill.setPaidAmount(
                    alreadyPaid
            );

            bill.setTotalAmount(
                    balance
            );

            bill.setPaymentMethod(
                    paymentMethod
            );

            bill.setPaymentStatus(
                    "PAID"
            );

            /*
             * createBill() generates bill number.
             */
            boolean saved
                    = billingService.createBill(
                            bill
                    );

            if (!saved) {

                redirectError(
                        request,
                        response,
                        "save"
                );

                return;
            }

            /*
             * =================================================
             * GO TO RECEIPT
             * =================================================
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/CashierReceiptServlet?id="
                    + bill.getId()
            );

        } catch (Exception e) {

            e.printStackTrace();

            redirectError(
                    request,
                    response,
                    "server"
            );
        }
    }

    /*
     * =========================================================
     * GET PAID AMOUNT
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
     * DISCOUNT
     *
     * Allowed:
     * 0
     * 5
     * 10
     * 15
     * =========================================================
     */
    private BigDecimal parseDiscount(
            String value) {

        if (value == null) {

            return BigDecimal.ZERO;
        }

        try {

            BigDecimal discount
                    = new BigDecimal(
                            value
                    );

            if (discount.compareTo(
                    BigDecimal.ZERO
            ) < 0) {

                return BigDecimal.ZERO;
            }

            if (discount.compareTo(
                    new BigDecimal("15")
            ) > 0) {

                return new BigDecimal("15");
            }

            return discount.setScale(
                    2,
                    RoundingMode.HALF_UP
            );

        } catch (NumberFormatException e) {

            return BigDecimal.ZERO;
        }
    }

    private BigDecimal safe(
            BigDecimal value) {

        return value == null
                ? BigDecimal.ZERO
                : value.setScale(
                        2,
                        RoundingMode.HALF_UP
                );
    }

    private String clean(
            String value) {

        if (value == null) {
            return null;
        }

        value
                = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String error)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/CashierBillingServlet?error="
                + error
        );
    }

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
