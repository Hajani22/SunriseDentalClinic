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
import java.util.List;

@WebServlet("/PatientBillsServlet")
public class PatientBillsServlet extends HttpServlet {

    private final PaymentService paymentService
            = new PaymentServiceImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /* =====================================================
           CHECK LOGIN
           ===================================================== */
        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }


        /* =====================================================
           CHECK PATIENT ROLE
           ===================================================== */
        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            /* =================================================
               GET PATIENT ID
               ================================================= */
            int patientId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );


            /* =================================================
               GET PAYMENT HISTORY
               ================================================= */
            List<Payment> payments
                    = paymentService.getPatientPayments(
                            patientId
                    );

            request.setAttribute(
                    "payments",
                    payments
            );


            /* =================================================
               FORWARD TO JSP
               ================================================= */
            request.getRequestDispatcher(
                    "/patient-bills.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/patient-dashboard.jsp?payment=error"
            );

        }

    }

}
