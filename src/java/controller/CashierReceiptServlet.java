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
import java.util.List;
import java.util.UUID;

@WebServlet("/CashierReceiptServlet")
public class CashierReceiptServlet
        extends HttpServlet {

    private final BillingService billingService
            = new BillingServiceImpl();

    private final PaymentDAO paymentDAO
            = new PaymentDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null
                || !"cashier".equalsIgnoreCase(
                        String.valueOf(
                                session.getAttribute(
                                        "userRole"
                                )
                        )
                )) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            Bill bill = null;

            /*
             * =================================================
             * EXISTING BILL BY ID
             * =================================================
             */
            String id
                    = request.getParameter("id");

            if (id != null
                    && !id.trim().isEmpty()) {

                try {

                    bill
                            = billingService.getBillById(
                                    Integer.parseInt(id)
                            );

                } catch (NumberFormatException e) {

                    bill = null;
                }
            }

            /*
             * =================================================
             * RECEIPT BY APPOINTMENT NUMBER
             * =================================================
             */
            if (bill == null) {

                String appointmentNo
                        = request.getParameter(
                                "appointmentNo"
                        );

                if (appointmentNo != null
                        && !appointmentNo.trim().isEmpty()) {

                    Bill appointment
                            = billingService.findAppointmentForBilling(
                                    appointmentNo.trim()
                            );

                    if (appointment != null) {

                        /*
                         * First check whether a real bill
                         * already exists.
                         */
                        bill
                                = billingService.getBillByAppointmentId(
                                        appointment.getAppointmentId()
                                );

                        if (bill == null) {

                            /*
                             * No bill exists.
                             * Build a temporary prepaid receipt.
                             */
                            bill
                                    = buildPrepaidReceipt(
                                            appointmentNo.trim()
                                    );
                        }
                    }
                }
            }

            if (bill == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/CashierBillingServlet?error=receipt"
                );

                return;
            }

            /*
             * =================================================
             * GET TOTAL PAID
             * =================================================
             */
            BigDecimal paid
                    = getPaidAmount(
                            bill.getAppointmentId()
                    );

            bill.setPaidAmount(
                    paid
            );

            if (bill.getPaymentMethod() == null
                    || bill.getPaymentMethod()
                            .trim()
                            .isEmpty()) {

                bill.setPaymentMethod(
                        getPaymentMethod(
                                bill.getAppointmentId()
                        )
                );
            }

            request.setAttribute(
                    "bill",
                    bill
            );

            request.getRequestDispatcher(
                    "/cashier-receipt.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/CashierBillingServlet?error=receipt"
            );
        }
    }

    /*
     * =========================================================
     * PREPAID RECEIPT
     * =========================================================
     */
    private Bill buildPrepaidReceipt(
            String appointmentNo)
            throws Exception {

        Bill appointment
                = billingService.findAppointmentForBilling(
                        appointmentNo
                );

        if (appointment == null) {
            return null;
        }

        /*
         * Temporarily calculate the bill.
         */
        Bill bill
                = new Bill();

        bill.setAppointmentId(
                appointment.getAppointmentId()
        );

        bill.setPatientId(
                appointment.getPatientId()
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

        /*
         * Get treatment and consultation prices
         * using the billing service.
         */
        Bill prepared
                = billingService.prepareBill(
                        appointmentNo,
                        BigDecimal.ZERO
                );

        if (prepared == null) {
            return null;
        }

        bill.setTreatmentAmount(
                prepared.getTreatmentAmount()
        );

        bill.setConsultationFee(
                prepared.getConsultationFee()
        );

        bill.setDiscount(
                BigDecimal.ZERO
        );

        BigDecimal gross
                = safe(
                        prepared.getTreatmentAmount()
                ).add(
                        safe(
                                prepared.getConsultationFee()
                        )
                );

        bill.setTotalAmount(
                gross
        );

        bill.setPaidAmount(
                getPaidAmount(
                        appointment.getAppointmentId()
                )
        );

        bill.setPaymentMethod(
                getPaymentMethod(
                        appointment.getAppointmentId()
                )
        );

        bill.setPaymentStatus(
                "PAID"
        );

        bill.setBillNo(
                "PREPAID-"
                + UUID.randomUUID()
                        .toString()
                        .substring(
                                0,
                                8
                        )
                        .toUpperCase()
        );

        return bill;
    }

    /*
     * =========================================================
     * TOTAL PAID
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
     * PAYMENT METHOD
     * =========================================================
     */
    private String getPaymentMethod(
            int appointmentId)
            throws Exception {

        String method
                = "NOT PAID";

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

    private BigDecimal safe(
            BigDecimal value) {

        return value == null
                ? BigDecimal.ZERO
                : value;
    }
}
