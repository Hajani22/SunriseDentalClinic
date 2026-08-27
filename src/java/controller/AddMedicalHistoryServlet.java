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
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/AddMedicalHistoryServlet")
public class AddMedicalHistoryServlet extends HttpServlet {

    private AppointmentService appointmentService;
    private MedicalHistoryService medicalHistoryService;

    @Override
    public void init() throws ServletException {

        appointmentService
                = new AppointmentServiceImpl();

        medicalHistoryService
                = new MedicalHistoryServiceImpl();
    }

    /*
     * =====================================================
     * OPEN FORM
     * =====================================================
     */
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
                    + "/Login.jsp?error=session"
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

        Object userId
                = session.getAttribute("userId");

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }

        try {

            String appointmentIdValue
                    = request.getParameter("appointmentId");

            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=appointment"
                );

                return;
            }

            int appointmentId
                    = Integer.parseInt(
                            appointmentIdValue
                    );

            int doctorId
                    = Integer.parseInt(
                            userId.toString()
                    );

            Appointment appointment
                    = appointmentService.getById(
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
             * Doctor can only create history
             * for their own appointment.
             */
            if (appointment.getDoctorId()
                    != doctorId) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=access"
                );

                return;
            }

            request.setAttribute(
                    "appointment",
                    appointment
            );

            request.getRequestDispatcher(
                    "/add-medical-history.jsp"
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
                    "Database error opening medical history form.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorAppointmentsServlet?error=database"
            );
        }
    }

    /*
     * =====================================================
     * SAVE MEDICAL HISTORY
     * =====================================================
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
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

            Object userId
                    = session.getAttribute("userId");

            if (userId == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }

            int doctorId
                    = Integer.parseInt(
                            userId.toString()
                    );

            String appointmentIdValue
                    = request.getParameter(
                            "appointmentId"
                    );

            if (appointmentIdValue == null
                    || appointmentIdValue.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=appointment"
                );

                return;
            }

            int appointmentId
                    = Integer.parseInt(
                            appointmentIdValue
                    );

            /*
             * Get appointment.
             */
            Appointment appointment
                    = appointmentService.getById(
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
             * Security.
             */
            if (appointment.getDoctorId()
                    != doctorId) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorAppointmentsServlet?error=access"
                );

                return;
            }

            /*
             * Form values.
             */
            String visitDateValue
                    = clean(
                            request.getParameter(
                                    "visitDate"
                            )
                    );

            String symptoms
                    = clean(
                            request.getParameter(
                                    "symptoms"
                            )
                    );

            String diagnosis
                    = clean(
                            request.getParameter(
                                    "diagnosis"
                            )
                    );

            String treatment
                    = clean(
                            request.getParameter(
                                    "treatment"
                            )
                    );

            String allergies
                    = clean(
                            request.getParameter(
                                    "allergies"
                            )
                    );

            String medications
                    = clean(
                            request.getParameter(
                                    "medications"
                            )
                    );

            String medicalConditions
                    = clean(
                            request.getParameter(
                                    "medicalConditions"
                            )
                    );

            String notes
                    = clean(
                            request.getParameter(
                                    "notes"
                            )
                    );

            /*
             * Visit date required.
             */
            if (visitDateValue == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AddMedicalHistoryServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=date"
                );

                return;
            }

            /*
             * At least one clinical field.
             */
            if (symptoms == null
                    && diagnosis == null
                    && treatment == null
                    && notes == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AddMedicalHistoryServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=empty"
                );

                return;
            }

            Date visitDate;

            try {

                visitDate
                        = Date.valueOf(
                                visitDateValue
                        );

            } catch (IllegalArgumentException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AddMedicalHistoryServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=date"
                );

                return;
            }

            /*
             * Create MedicalHistory object.
             */
            MedicalHistory history
                    = new MedicalHistory();

            /*
             * Patient ID automatically comes
             * from appointment.
             */
            history.setPatientId(
                    appointment.getPatientId()
            );

            /*
             * Doctor ID automatically comes
             * from logged-in doctor.
             */
            history.setDoctorId(
                    doctorId
            );

            /*
             * Appointment ID.
             */
            history.setAppointmentId(
                    appointmentId
            );

            history.setVisitDate(
                    visitDate
            );

            history.setSymptoms(
                    symptoms
            );

            history.setDiagnosis(
                    diagnosis
            );

            history.setTreatment(
                    treatment
            );

            history.setAllergies(
                    allergies
            );

            history.setMedications(
                    medications
            );

            history.setMedicalConditions(
                    medicalConditions
            );

            history.setNotes(
                    notes
            );

            /*
             * SAVE
             */
            boolean saved
                    = medicalHistoryService.addHistory(
                            history
                    );

            if (saved) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorPatientDetailsServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&success=history"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/AddMedicalHistoryServlet"
                        + "?appointmentId="
                        + appointmentId
                        + "&error=save"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorAppointmentsServlet?error=invalid"
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Database error saving medical history.",
                    e
            );

            String appointmentId
                    = request.getParameter(
                            "appointmentId"
                    );

            response.sendRedirect(
                    request.getContextPath()
                    + "/AddMedicalHistoryServlet"
                    + "?appointmentId="
                    + appointmentId
                    + "&error=database"
            );
        }
    }

    private String clean(String value) {

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
