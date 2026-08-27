package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Appointment;
import model.MedicalHistory;

import service.AppointmentService;
import service.MedicalHistoryService;

import service.impl.AppointmentServiceImpl;
import service.impl.MedicalHistoryServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/DoctorPatientDetailsServlet")
public class DoctorPatientDetailsServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private MedicalHistoryService medicalHistoryService;

    @Override
    public void init() throws ServletException {

        appointmentService = new AppointmentServiceImpl();

        medicalHistoryService = new MedicalHistoryServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * =====================================================
         * LOGIN CHECK
         * =====================================================
         */

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        /*
         * =====================================================
         * DOCTOR ROLE CHECK
         * =====================================================
         */

        String role =
                String.valueOf(
                        session.getAttribute("userRole")
                );

        if (!"doctor".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        /*
         * =====================================================
         * GET DOCTOR ID
         * =====================================================
         */

        Object userIdObject =
                session.getAttribute("userId");

        if (userIdObject == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        try {

            int doctorId =
                    Integer.parseInt(
                            userIdObject.toString()
                    );

            /*
             * =================================================
             * GET APPOINTMENT ID
             * =================================================
             */

            String appointmentIdParameter =
                    request.getParameter("appointmentId");

            if (appointmentIdParameter == null
                    || appointmentIdParameter.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=appointment"
                );

                return;
            }

            int appointmentId =
                    Integer.parseInt(
                            appointmentIdParameter
                    );

            /*
             * =================================================
             * GET APPOINTMENT
             * =================================================
             */

            Appointment appointment =
                    appointmentService.getById(
                            appointmentId
                    );

            if (appointment == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=notfound"
                );

                return;
            }

            /*
             * =================================================
             * SECURITY CHECK
             *
             * Doctor can only see patients belonging to
             * his/her own appointment.
             * =================================================
             */

            if (appointment.getDoctorId() != doctorId) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=access"
                );

                return;
            }

            /*
             * =================================================
             * GET PATIENT MEDICAL HISTORY
             * =================================================
             */

            List<MedicalHistory> historyList =
                    medicalHistoryService
                            .getPatientHistory(
                                    appointment.getPatientId()
                            );

            /*
             * =================================================
             * SEND DATA TO JSP
             * =================================================
             */

            request.setAttribute(
                    "appointment",
                    appointment
            );

            request.setAttribute(
                    "medicalHistory",
                    historyList
            );

            /*
             * =================================================
             * FORWARD TO JSP
             *
             * IMPORTANT:
             * doctor-patient-details.jsp MUST be directly
             * inside the web folder.
             * =================================================
             */

            request.getRequestDispatcher(
                    "/doctor-patient-details.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorAppointmentsServlet?error=invalid"
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Database error while loading patient details.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorAppointmentsServlet?error=database"
            );
        }
    }
}