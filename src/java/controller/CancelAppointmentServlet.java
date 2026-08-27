package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import java.io.IOException;

@WebServlet("/CancelAppointmentServlet")
public class CancelAppointmentServlet
        extends HttpServlet {

    private final AppointmentService appointmentService
            = new AppointmentServiceImpl();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    "Login.jsp"
            );

            return;
        }

        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    "Login.jsp?error=access"
            );

            return;
        }

        try {

            int patientId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

            String idParameter
                    = request.getParameter(
                            "appointmentId"
                    );

            if (idParameter == null
                    || idParameter.trim().isEmpty()) {

                response.sendRedirect(
                        "PatientAppointmentsServlet"
                        + "?error=cancel"
                );

                return;
            }

            int appointmentId
                    = Integer.parseInt(
                            idParameter
                    );

            String reason
                    = request.getParameter(
                            "reason"
                    );

            if (reason == null
                    || reason.trim().isEmpty()) {

                reason
                        = "Cancelled by patient.";
            }

            reason
                    = reason.trim();

            if (reason.length() > 500) {

                reason
                        = reason.substring(
                                0,
                                500
                        );
            }

            boolean success
                    = appointmentService
                            .cancelAppointment(
                                    appointmentId,
                                    patientId,
                                    reason
                            );

            if (success) {

                response.sendRedirect(
                        "PatientAppointmentsServlet"
                        + "?success=cancelled"
                );

            } else {

                response.sendRedirect(
                        "PatientAppointmentsServlet"
                        + "?error=cancel"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "PatientAppointmentsServlet"
                    + "?error=server"
            );
        }
    }
}
