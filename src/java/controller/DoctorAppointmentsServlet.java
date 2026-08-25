package controller;

import model.Appointment;
import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/DoctorAppointmentsServlet")
public class DoctorAppointmentsServlet extends HttpServlet {

    private final AppointmentService appointmentService
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
                        session.getAttribute("userRole")
                );

        if (!"doctor".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        Object userIdObject
                = session.getAttribute("userId");

        if (userIdObject == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        try {

            int doctorId
                    = Integer.parseInt(
                            userIdObject.toString()
                    );

            List<Appointment> appointments
                    = appointmentService
                            .getDoctorAppointments(
                                    doctorId
                            );

            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.getRequestDispatcher(
                    "/doctor-appointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/doctor-dashboard.jsp?error=server"
            );
        }
    }
}
