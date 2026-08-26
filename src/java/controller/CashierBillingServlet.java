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

@WebServlet("/CashierBillingServlet")
public class CashierBillingServlet
        extends HttpServlet {

    private final BillingService service
            = new BillingServiceImpl();

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
                = request.getParameter(
                        "appointmentNo"
                );

        if (appointmentNo != null
                && !appointmentNo.trim().isEmpty()) {

            try {

                appointmentNo
                        = appointmentNo.trim();

                Bill bill
                        = service.findAppointmentForBilling(
                                appointmentNo
                        );

                if (bill == null) {

                    request.setAttribute(
                            "error",
                            "Confirmed appointment not found. "
                            + "Please check the appointment number."
                    );

                } else {

                    BigDecimal discount
                            = BigDecimal.ZERO;

                    String discountParam
                            = request.getParameter(
                                    "discount"
                            );

                    if (discountParam != null
                            && !discountParam.trim().isEmpty()) {

                        try {

                            discount
                                    = new BigDecimal(
                                            discountParam.trim()
                                    );

                        } catch (NumberFormatException ex) {

                            request.setAttribute(
                                    "error",
                                    "Invalid discount amount."
                            );

                            discount
                                    = BigDecimal.ZERO;
                        }
                    }


                    /* =========================================
                       NEGATIVE DISCOUNT
                       ========================================= */
                    if (discount.compareTo(
                            BigDecimal.ZERO
                    ) < 0) {

                        request.setAttribute(
                                "error",
                                "Discount cannot be negative."
                        );

                        discount
                                = BigDecimal.ZERO;
                    }

                    Bill prepared
                            = service.prepareBill(
                                    appointmentNo,
                                    discount
                            );

                    if (prepared == null) {

                        request.setAttribute(
                                "error",
                                "A bill may already exist "
                                + "for this appointment."
                        );

                    } else {

                        request.setAttribute(
                                "bill",
                                prepared
                        );
                    }
                }

            } catch (Exception e) {

                log(
                        "Unable to load billing information.",
                        e
                );

                request.setAttribute(
                        "error",
                        "Unable to load billing information."
                );
            }
        }


        /* =========================================
           RECENT BILLS
           ========================================= */
        try {

            request.setAttribute(
                    "recentBills",
                    service.getRecentBills(10)
            );

        } catch (Exception e) {

            log(
                    "Unable to load recent bills.",
                    e
            );
        }

        request.getRequestDispatcher(
                "/cashier-billing.jsp"
        ).forward(
                request,
                response
        );
    }


    /* =========================================================
       CASHIER ACCESS CHECK
       ========================================================= */
    private boolean isCashier(
            HttpServletRequest request) {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            return false;
        }

        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        return "cashier".equalsIgnoreCase(
                role
        );
    }
}
