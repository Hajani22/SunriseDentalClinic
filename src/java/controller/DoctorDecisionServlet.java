package controller;

import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/DoctorDecisionServlet")
public class DoctorDecisionServlet extends HttpServlet {

    private final AppointmentService appointmentService
            = new AppointmentServiceImpl();

    @Override
    protected void doPost(
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

        try {

            int doctorId
                    = Integer.parseInt(
                            session.getAttribute(
                                    "userId"
                            ).toString()
                    );

            int appointmentId
                    = Integer.parseInt(
                            request.getParameter(
                                    "appointmentId"
                            )
                    );

            String decision
                    = request.getParameter("decision");

            String note
                    = request.getParameter("note");

            boolean approve
                    = "accept".equalsIgnoreCase(
                            decision
                    );

            if (!approve
                    && (note == null
                    || note.trim().isEmpty())) {

                note
                        = "Doctor is not available.";
            }

            boolean success
                    = appointmentService.doctorDecision(
                            appointmentId,
                            doctorId,
                            approve,
                            note
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?success="
                        + (approve
                                ? "accepted"
                                : "rejected")
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=decision"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorAppointmentsServlet?error=server"
            );
        }
    }
}
