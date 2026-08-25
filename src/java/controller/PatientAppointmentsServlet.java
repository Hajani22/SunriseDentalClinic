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

@WebServlet("/PatientAppointmentsServlet")
public class PatientAppointmentsServlet extends HttpServlet {

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

            response.sendRedirect("Login.jsp");
            return;
        }

        String role
                = (String) session.getAttribute("userRole");

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }

        Object userIdObject
                = session.getAttribute("userId");

        /*
         * If userId is not available,
         * do not continue to database.
         */
        if (userIdObject == null) {

            response.sendRedirect(
                    "Login.jsp?error=session"
            );

            return;
        }

        try {

            int patientId
                    = Integer.parseInt(
                            userIdObject.toString()
                    );

            List<Appointment> appointments
                    = appointmentService
                            .getPatientAppointments(
                                    patientId
                            );

            request.setAttribute(
                    "appointments",
                    appointments
            );

            request.getRequestDispatcher(
                    "patient-appointments.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "patient-dashboard.jsp?error=server"
            );
        }
    }
}
