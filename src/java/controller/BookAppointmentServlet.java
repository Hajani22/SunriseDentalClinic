package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Appointment;
import model.User;
import service.AppointmentService;
import service.impl.AppointmentServiceImpl;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller for patient appointment booking.
 *
 * Design patterns used:
 * - MVC Controller: receives the HTTP request and selects the response.
 * - Service Layer: business validation is delegated to AppointmentService.
 * - DAO: persistence is delegated through AppointmentService -> AppointmentDAO.
 */
@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/Login.jsp?error=session");
            return;
        }

        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"patient".equalsIgnoreCase(role)) {
            response.sendRedirect(
                    request.getContextPath() + "/Login.jsp?error=access");
            return;
        }

        try {
            request.setAttribute(
                    "doctors",
                    appointmentService.getDoctors()
            );

            request.getRequestDispatcher(
                    "/book-appointment.jsp"
            ).forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/patient-dashboard.jsp?error=database"
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/Login.jsp?error=session");
            return;
        }

        String role = String.valueOf(
                session.getAttribute("userRole")
        );

        if (!"patient".equalsIgnoreCase(role)) {
            response.sendRedirect(
                    request.getContextPath() + "/Login.jsp?error=access");
            return;
        }

        try {
            Object idObject = session.getAttribute("userId");

            if (idObject == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );
                return;
            }

            int patientId = Integer.parseInt(
                    idObject.toString()
            );

            User user = (User) session.getAttribute("user");

            String doctorIdValue =
                    request.getParameter("doctorId");

            String treatmentType =
                    clean(request.getParameter("treatmentType"));

            String appointmentDate =
                    clean(request.getParameter("appointmentDate"));

            String appointmentTime =
                    clean(request.getParameter("appointmentTime"));

            String phone =
                    clean(request.getParameter("phone"));

            String address =
                    clean(request.getParameter("address"));

            if (doctorIdValue == null
                    || doctorIdValue.isEmpty()
                    || treatmentType == null
                    || treatmentType.isEmpty()
                    || appointmentDate == null
                    || appointmentDate.isEmpty()
                    || appointmentTime == null
                    || appointmentTime.isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointmentServlet?error=empty"
                );
                return;
            }

            int doctorId;

            try {
                doctorId = Integer.parseInt(doctorIdValue);
            } catch (NumberFormatException e) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointmentServlet?error=doctor"
                );
                return;
            }

            if (phone == null || phone.isEmpty()) {
                phone = user.getPhone();
            }

            String patientName =
                    user.getFirstName()
                    + " "
                    + user.getLastName();

            Appointment appointment = new Appointment();

            appointment.setPatientId(patientId);
            appointment.setDoctorId(doctorId);
            appointment.setPatientName(patientName);
            appointment.setPatientPhone(phone);
            appointment.setPatientAddress(address);
            appointment.setTreatmentType(treatmentType);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setAppointmentTime(appointmentTime);

            boolean created =
                    appointmentService.bookAppointment(
                            appointment
                    );

            if (!created) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/BookAppointmentServlet?error=slot"
                );
                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/PatientAppointmentsServlet?success=booked"
            );

        } catch (IllegalArgumentException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointmentServlet?error=invalid"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/BookAppointmentServlet?error=database"
            );
        }
    }

    private String clean(String value) {

        if (value == null) {
            return null;
        }

        value = value.trim();

        return value.isEmpty() ? null : value;
    }
}
