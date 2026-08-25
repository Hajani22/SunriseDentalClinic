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

@WebServlet("/AdminNotificationsServlet")
public class AdminNotificationsServlet
        extends HttpServlet {

    private final NotificationDAO notificationDAO
            = new NotificationDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

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

        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"admin".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            int userId
                    = Integer.parseInt(
                            session.getAttribute(
                                    "userId"
                            ).toString()
                    );

            request.setAttribute(
                    "notifications",
                    notificationDAO.getForUser(
                            userId,
                            "admin"
                    )
            );

            request.getRequestDispatcher(
                    "/admin-notifications.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-dashboard.jsp?error=server"
            );
        }
    }
}
