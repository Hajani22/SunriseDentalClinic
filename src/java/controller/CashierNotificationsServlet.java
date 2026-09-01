package controller;

import dao.NotificationDAO;
import dao.impl.NotificationDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/CashierNotificationsServlet")
public class CashierNotificationsServlet
        extends HttpServlet {

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /* =========================================
           SESSION CHECK
           ========================================= */
        HttpSession session
                = request.getSession(false);

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


        /* =========================================
           GET CASHIER USER ID
           ========================================= */
        try {

            Object userIdObject
                    = session.getAttribute(
                            "userId"
                    );

            if (userIdObject == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }

            int cashierId
                    = Integer.parseInt(
                            String.valueOf(
                                    userIdObject
                            )
                    );

            if (cashierId <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }


            /* =====================================
               LOAD NOTIFICATIONS
               ===================================== */
            request.setAttribute(
                    "notifications",
                    notificationDAO.getForUser(
                            cashierId,
                            "cashier"
                    )
            );


            /* =====================================
               OPEN NOTIFICATION PAGE
               ===================================== */
            request.getRequestDispatcher(
                    "/cashier-notifications.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/cashier-dashboard.jsp?error=notifications"
            );
        }
    }
}
