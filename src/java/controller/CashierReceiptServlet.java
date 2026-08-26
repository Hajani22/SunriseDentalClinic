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


@WebServlet("/CashierReceiptServlet")
public class CashierReceiptServlet
        extends HttpServlet {


    private final BillingService service =
            new BillingServiceImpl();


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session =
                request.getSession(false);


        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp"
            );

            return;
        }


        String role =
                String.valueOf(
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

            int id =
                    Integer.parseInt(
                            request.getParameter("id")
                    );


            Bill bill =
                    service.getBillById(id);


            if (bill == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/CashierBillingServlet"
                        + "?error=receipt"
                );

                return;
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
                    + "/CashierBillingServlet"
                    + "?error=receipt"
            );
        }
    }
}