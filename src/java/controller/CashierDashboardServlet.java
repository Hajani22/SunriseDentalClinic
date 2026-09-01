package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Payment;

import service.PaymentService;
import service.impl.PaymentServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CashierDashboardServlet")
public class CashierDashboardServlet extends HttpServlet {

    private final PaymentService paymentService
            = new PaymentServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );
            return;
        }

        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"cashier".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );
            return;
        }

        List<Payment> payments = new ArrayList<>();

        try {
            payments = paymentService.getAllPayments();
        } catch (Exception e) {
            log("Unable to load payment records.", e);
        }

        int totalPayments = payments.size();
        int paidPayments = 0;

        BigDecimal totalRevenue = BigDecimal.ZERO;

        for (Payment payment : payments) {

            if (payment == null) {
                continue;
            }

            String status = payment.getPaymentStatus();

            if ("PAID".equalsIgnoreCase(status)
                    || "COMPLETED".equalsIgnoreCase(status)) {

                paidPayments++;

                if (payment.getAmount() != null) {
                    totalRevenue
                            = totalRevenue.add(
                                    payment.getAmount()
                            );
                }
            }
        }

        request.setAttribute(
                "paymentRecords",
                payments
        );

        request.setAttribute(
                "totalPayments",
                totalPayments
        );

        request.setAttribute(
                "paidPayments",
                paidPayments
        );

        request.setAttribute(
                "totalRevenue",
                totalRevenue
        );

        request.getRequestDispatcher(
                "/cashier-dashboard.jsp"
        ).forward(
                request,
                response
        );
    }
}
