package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Bill;

import service.BillingService;
import service.impl.BillingServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/CashierPaymentServlet")
public class CashierPaymentServlet
        extends HttpServlet {

    private final BillingService billingService
            = new BillingServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);


        /* =========================================
           LOGIN CHECK
           ========================================= */
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp"
            );

            return;
        }


        /* =========================================
           ROLE CHECK
           ========================================= */
        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"cashier".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            /* =====================================
               CASHIER ID
               ===================================== */
            Object userIdObject
                    = session.getAttribute(
                            "userId"
                    );

            int cashierId;

            if (userIdObject instanceof Integer) {

                cashierId
                        = (Integer) userIdObject;

            } else {

                try {

                    cashierId
                            = Integer.parseInt(
                                    String.valueOf(
                                            userIdObject
                                    )
                            );

                } catch (Exception ex) {

                    redirectWithError(
                            request,
                            response,
                            null,
                            "Invalid cashier session."
                    );

                    return;
                }
            }

            if (cashierId <= 0) {

                redirectWithError(
                        request,
                        response,
                        null,
                        "Invalid cashier session."
                );

                return;
            }


            /* =====================================
               FORM VALUES
               ===================================== */
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

            String discountValue
                    = clean(
                            request.getParameter(
                                    "discount"
                            )
                    );


            /* =====================================
               APPOINTMENT VALIDATION
               ===================================== */
            if (appointmentNo == null
                    || appointmentNo.isEmpty()) {

                redirectWithError(
                        request,
                        response,
                        null,
                        "Appointment number is required."
                );

                return;
            }


            /* =====================================
               PAYMENT METHOD
               ===================================== */
            if (!isValidPaymentMethod(
                    paymentMethod
            )) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Please select a valid payment method."
                );

                return;
            }


            /* =====================================
               DISCOUNT
               ===================================== */
            BigDecimal discount
                    = BigDecimal.ZERO;

            if (discountValue != null
                    && !discountValue.isEmpty()) {

                try {

                    discount
                            = new BigDecimal(
                                    discountValue
                            ).setScale(
                                    2,
                                    RoundingMode.HALF_UP
                            );

                } catch (NumberFormatException ex) {

                    redirectWithError(
                            request,
                            response,
                            appointmentNo,
                            "Invalid discount amount."
                    );

                    return;
                }
            }

            if (discount.compareTo(
                    BigDecimal.ZERO
            ) < 0) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Discount cannot be negative."
                );

                return;
            }


            /* =====================================
               PREPARE BILL
               ===================================== */
            Bill bill
                    = billingService.prepareBill(
                            appointmentNo,
                            discount
                    );

            if (bill == null) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Unable to prepare the bill. "
                        + "The appointment may already have a bill."
                );

                return;
            }


            /* =====================================
               BILL VALUES
               ===================================== */
            BigDecimal treatment
                    = safe(
                            bill.getTreatmentAmount()
                    );

            BigDecimal consultation
                    = safe(
                            bill.getConsultationFee()
                    );

            BigDecimal gross
                    = treatment.add(
                            consultation
                    );

            if (discount.compareTo(
                    gross
            ) > 0) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Discount cannot exceed "
                        + "the bill amount."
                );

                return;
            }

            BigDecimal total
                    = gross.subtract(
                            discount
                    ).setScale(
                            2,
                            RoundingMode.HALF_UP
                    );

            if (total.compareTo(
                    BigDecimal.ZERO
            ) <= 0) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Bill total must be greater than zero."
                );

                return;
            }


            /* =====================================
               SET FINAL PAYMENT INFORMATION
               ===================================== */
            bill.setCashierId(
                    cashierId
            );

            bill.setDiscount(
                    discount
            );

            bill.setTotalAmount(
                    total
            );

            bill.setPaymentMethod(
                    paymentMethod.toUpperCase()
            );

            bill.setPaymentStatus(
                    "PAID"
            );


            /* =====================================
               SAVE BILL
               ===================================== */
            boolean saved
                    = billingService.createBill(
                            bill
                    );

            if (!saved) {

                redirectWithError(
                        request,
                        response,
                        appointmentNo,
                        "Payment could not be completed. "
                        + "A bill may already exist."
                );

                return;
            }


            /* =====================================
               RECEIPT
               ===================================== */
            response.sendRedirect(
                    request.getContextPath()
                    + "/CashierReceiptServlet?id="
                    + bill.getId()
            );

        } catch (Exception ex) {

            log(
                    "Cashier payment processing failed.",
                    ex
            );

            redirectWithError(
                    request,
                    response,
                    null,
                    "Unexpected error occurred "
                    + "while processing the payment."
            );
        }
    }


    /* =========================================================
       PAYMENT METHODS
       ========================================================= */
    private boolean isValidPaymentMethod(
            String method) {

        if (method == null) {
            return false;
        }

        return "CASH".equalsIgnoreCase(method)
                || "CARD".equalsIgnoreCase(method)
                || "BANK_TRANSFER"
                        .equalsIgnoreCase(method);
    }


    /* =========================================================
       SAFE DECIMAL
       ========================================================= */
    private BigDecimal safe(
            BigDecimal value) {

        return value == null
                ? BigDecimal.ZERO
                : value;
    }


    /* =========================================================
       CLEAN STRING
       ========================================================= */
    private String clean(
            String value) {

        if (value == null) {
            return null;
        }

        return value.trim();
    }


    /* =========================================================
       ERROR REDIRECT
       ========================================================= */
    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String appointmentNo,
            String message)
            throws IOException {

        StringBuilder url
                = new StringBuilder();

        url.append(
                request.getContextPath()
        );

        url.append(
                "/CashierBillingServlet?error="
        );

        url.append(
                URLEncoder.encode(
                        message,
                        StandardCharsets.UTF_8
                )
        );

        if (appointmentNo != null
                && !appointmentNo.isEmpty()) {

            url.append(
                    "&appointmentNo="
            );

            url.append(
                    URLEncoder.encode(
                            appointmentNo,
                            StandardCharsets.UTF_8
                    )
            );
        }

        response.sendRedirect(
                url.toString()
        );
    }
}
