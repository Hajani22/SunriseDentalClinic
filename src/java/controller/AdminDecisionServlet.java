package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import java.io.IOException;

@WebServlet("/AdminDecisionServlet")
public class AdminDecisionServlet
        extends HttpServlet {

    private final AppointmentService service
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

            int appointmentId
                    = Integer.parseInt(
                            request.getParameter(
                                    "appointmentId"
                            )
                    );

            String decision
                    = request.getParameter(
                            "decision"
                    );

            String note
                    = request.getParameter(
                            "note"
                    );

            boolean approve
                    = "confirm".equalsIgnoreCase(
                            decision
                    );

            if (!approve
                    && (note == null
                    || note.trim().isEmpty())) {

                note
                        = "Appointment could not be confirmed.";
            }

            boolean success
                    = service.adminDecision(
                            appointmentId,
                            approve,
                            note
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AdminAppointmentsServlet?success="
                        + (approve
                                ? "confirmed"
                                : "rejected")
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AdminAppointmentsServlet?error=decision"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/AdminAppointmentsServlet?error=server"
            );
        }
    }
}
