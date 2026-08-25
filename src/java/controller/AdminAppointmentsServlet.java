package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Appointment;

import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminAppointmentsServlet")
public class AdminAppointmentsServlet
        extends HttpServlet {

    private final AppointmentService service
            = new AppointmentServiceImpl();

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

            List<Appointment> appointments
                    = service.getAdminAppointments();

            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.getRequestDispatcher(
                    "/admin-appointments.jsp"
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
