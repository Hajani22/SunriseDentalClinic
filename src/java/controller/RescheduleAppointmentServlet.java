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

@WebServlet("/RescheduleAppointmentServlet")
public class RescheduleAppointmentServlet
        extends HttpServlet {

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
                        + "?error=invalid"
                );

                return;
            }

            int appointmentId
                    = Integer.parseInt(
                            idParameter
                    );

            Appointment appointment
                    = appointmentService.getById(
                            appointmentId
                    );

            if (appointment == null
                    || appointment.getPatientId()
                    != patientId) {

                response.sendRedirect(
                        "PatientAppointmentsServlet"
                        + "?error=invalid"
                );

                return;
            }

            request.setAttribute(
                    "appointment",
                    appointment
            );

            request.getRequestDispatcher(
                    "reschedule-appointment.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "PatientAppointmentsServlet"
                    + "?error=server"
            );
        }
    }

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

        int appointmentId = 0;

        try {

            int patientId
                    = Integer.parseInt(
                            String.valueOf(
                                    session.getAttribute(
                                            "userId"
                                    )
                            )
                    );

            appointmentId
                    = Integer.parseInt(
                            request.getParameter(
                                    "appointmentId"
                            )
                    );

            String date
                    = clean(
                            request.getParameter(
                                    "appointmentDate"
                            )
                    );

            String time
                    = clean(
                            request.getParameter(
                                    "appointmentTime"
                            )
                    );

            if (date == null
                    || time == null) {

                response.sendRedirect(
                        "RescheduleAppointmentServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=empty"
                );

                return;
            }

            boolean success
                    = appointmentService
                            .rescheduleAppointment(
                                    appointmentId,
                                    patientId,
                                    date,
                                    time
                            );

            if (success) {

                response.sendRedirect(
                        "PatientAppointmentsServlet"
                        + "?success=rescheduled"
                );

            } else {

                response.sendRedirect(
                        "RescheduleAppointmentServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=slot"
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

    private String clean(
            String value) {

        if (value == null) {
            return null;
        }

        value
                = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }
}
