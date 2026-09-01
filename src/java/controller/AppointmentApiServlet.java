package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Appointment;
import service.AppointmentService;
import service.impl.AppointmentServiceImpl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(
        name = "AppointmentApiServlet",
        urlPatterns = {
            "/api/appointments",
            "/api/appointments/all"
        }
)
public class AppointmentApiServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AppointmentService appointmentService
            = new AppointmentServiceImpl();


  
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setCharacterEncoding("UTF-8");
        response.setContentType(
                "application/json;charset=UTF-8"
        );
        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();

        if (requestURI.endsWith("/appointments/all")) {

            getAllAppointments(response);

            return;
        }
        String appointmentNo
                = request.getParameter(
                        "appointmentNo"
                );


        /*
         * -----------------------------------------------------
         * VALIDATE APPOINTMENT NUMBER
         * -----------------------------------------------------
         */
        if (appointmentNo == null
                || appointmentNo.trim().isEmpty()) {

            sendError(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Appointment number is required. "
                    + "Use /api/appointments/all "
                    + "to retrieve all appointments."
            );
            return;
        }
        appointmentNo
                = appointmentNo.trim();
        
        getSingleAppointment(
                response,
                appointmentNo
        );
    }


    /*
     * =========================================================
     * GET ALL APPOINTMENTS
     * =========================================================
     */
    private void getAllAppointments(
            HttpServletResponse response)
            throws IOException {
        try {
            List<Appointment> appointments
                    = appointmentService
                            .getAllAppointments();
            response.setStatus(
                    HttpServletResponse.SC_OK
            );
            writeAllAppointmentsJson(
                    response,
                    appointments
            );
        } catch (SQLException e) {
            getServletContext().log(
                    "Error retrieving all appointments.",
                    e
            );

            sendError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve appointments."
            );
        }
    }


    /*
     * =========================================================
     * GET SINGLE APPOINTMENT
     * =========================================================
     */
    private void getSingleAppointment(
            HttpServletResponse response,
            String appointmentNo)
            throws IOException {


        /*
         * -----------------------------------------------------
         * VALIDATE FORMAT
         *
         * Example:
         * SDC-A1B2C3D4
         * -----------------------------------------------------
         */
        if (!appointmentNo.matches(
                "SDC-[A-Za-z0-9]{8}"
        )) {

            sendError(
                    response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment number format."
            );

            return;
        }

        try {

            Appointment appointment
                    = appointmentService
                            .getByAppointmentNo(
                                    appointmentNo
                            );


            /*
             * -------------------------------------------------
             * NOT FOUND
             * -------------------------------------------------
             */
            if (appointment == null) {

                sendError(
                        response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "Appointment not found."
                );

                return;
            }


            /*
             * -------------------------------------------------
             * SUCCESS
             * -------------------------------------------------
             */
            response.setStatus(
                    HttpServletResponse.SC_OK
            );

            writeAppointmentJson(
                    response,
                    appointment
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Appointment API database error.",
                    e
            );

            sendError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to retrieve appointment details."
            );
        }
    }


    /*
     * =========================================================
     * WRITE ALL APPOINTMENTS JSON
     * =========================================================
     */
    private void writeAllAppointmentsJson(
            HttpServletResponse response,
            List<Appointment> appointments)
            throws IOException {

        StringBuilder json
                = new StringBuilder();

        json.append("{");

        json.append(
                "\"success\":true,"
        );

        json.append(
                "\"count\":"
        );

        json.append(
                appointments == null
                        ? 0
                        : appointments.size()
        );

        json.append(",");

        json.append(
                "\"data\":["
        );

        if (appointments != null) {

            for (Appointment appointment
                    : appointments) {

                json.append("{");

                appendString(
                        json,
                        "appointmentNumber",
                        appointment.getAppointmentNo()
                );

                appendInteger(
                        json,
                        "patientId",
                        appointment.getPatientId()
                );

                appendInteger(
                        json,
                        "doctorId",
                        appointment.getDoctorId()
                );

                appendString(
                        json,
                        "patientName",
                        appointment.getPatientName()
                );

                appendString(
                        json,
                        "address",
                        appointment.getPatientAddress()
                );

                appendString(
                        json,
                        "contactNumber",
                        appointment.getPatientPhone()
                );

                appendString(
                        json,
                        "dentistName",
                        appointment.getDoctorName()
                );

                appendString(
                        json,
                        "specialization",
                        appointment.getSpecialization()
                );

                appendString(
                        json,
                        "treatmentType",
                        appointment.getTreatmentType()
                );

                appendString(
                        json,
                        "appointmentDate",
                        appointment.getAppointmentDate()
                );

                appendString(
                        json,
                        "appointmentTime",
                        appointment.getAppointmentTime()
                );

                appendString(
                        json,
                        "status",
                        appointment.getStatus()
                );

                appendString(
                        json,
                        "doctorNote",
                        appointment.getDoctorNote()
                );

                appendString(
                        json,
                        "adminNote",
                        appointment.getAdminNote()
                );

                appendString(
                        json,
                        "cancellationReason",
                        appointment.getCancellationReason()
                );

                appendString(
                        json,
                        "createdAt",
                        appointment.getCreatedAt()
                );

                appendString(
                        json,
                        "updatedAt",
                        appointment.getUpdatedAt()
                );


                /*
                 * Remove final comma inside appointment object.
                 */
                if (json.length() > 0
                        && json.charAt(
                                json.length() - 1
                        ) == ',') {

                    json.deleteCharAt(
                            json.length() - 1
                    );
                }

                json.append("}");

                /*
                 * Add comma between appointments.
                 */
                if (appointment
                        != appointments.get(
                                appointments.size() - 1
                        )) {

                    json.append(",");
                }
            }
        }

        json.append("]");

        json.append("}");

        response.getWriter().write(
                json.toString()
        );
    }


    /*
     * =========================================================
     * WRITE SINGLE APPOINTMENT JSON
     * =========================================================
     */
    private void writeAppointmentJson(
            HttpServletResponse response,
            Appointment appointment)
            throws IOException {

        StringBuilder json
                = new StringBuilder();

        json.append("{");

        json.append(
                "\"success\":true,"
        );

        json.append(
                "\"data\":{"
        );

        appendString(
                json,
                "appointmentNumber",
                appointment.getAppointmentNo()
        );

        appendInteger(
                json,
                "patientId",
                appointment.getPatientId()
        );

        appendInteger(
                json,
                "doctorId",
                appointment.getDoctorId()
        );

        appendString(
                json,
                "patientName",
                appointment.getPatientName()
        );

        appendString(
                json,
                "address",
                appointment.getPatientAddress()
        );

        appendString(
                json,
                "contactNumber",
                appointment.getPatientPhone()
        );

        appendString(
                json,
                "dentistName",
                appointment.getDoctorName()
        );

        appendString(
                json,
                "specialization",
                appointment.getSpecialization()
        );

        appendString(
                json,
                "treatmentType",
                appointment.getTreatmentType()
        );

        appendString(
                json,
                "appointmentDate",
                appointment.getAppointmentDate()
        );

        appendString(
                json,
                "appointmentTime",
                appointment.getAppointmentTime()
        );

        appendString(
                json,
                "status",
                appointment.getStatus()
        );

        appendString(
                json,
                "doctorNote",
                appointment.getDoctorNote()
        );

        appendString(
                json,
                "adminNote",
                appointment.getAdminNote()
        );

        appendString(
                json,
                "cancellationReason",
                appointment.getCancellationReason()
        );

        appendString(
                json,
                "createdAt",
                appointment.getCreatedAt()
        );

        appendString(
                json,
                "updatedAt",
                appointment.getUpdatedAt()
        );


        /*
         * Remove final comma.
         */
        if (json.length() > 0
                && json.charAt(
                        json.length() - 1
                ) == ',') {

            json.deleteCharAt(
                    json.length() - 1
            );
        }

        json.append("}");

        json.append("}");

        response.getWriter().write(
                json.toString()
        );
    }


    /*
     * =========================================================
     * APPEND STRING
     * =========================================================
     */
    private void appendString(
            StringBuilder json,
            String key,
            String value) {

        json.append("\"")
                .append(
                        escapeJson(key)
                )
                .append("\":");

        if (value == null) {

            json.append("null,");

        } else {

            json.append("\"")
                    .append(
                            escapeJson(value)
                    )
                    .append("\",");
        }
    }


    /*
     * =========================================================
     * APPEND INTEGER
     * =========================================================
     */
    private void appendInteger(
            StringBuilder json,
            String key,
            int value) {

        json.append("\"")
                .append(
                        escapeJson(key)
                )
                .append("\":")
                .append(value)
                .append(",");
    }


    /*
     * =========================================================
     * ERROR RESPONSE
     * =========================================================
     */
    private void sendError(
            HttpServletResponse response,
            int status,
            String message)
            throws IOException {

        response.setStatus(status);

        response.setContentType(
                "application/json;charset=UTF-8"
        );

        String json
                = "{"
                + "\"success\":false,"
                + "\"message\":\""
                + escapeJson(message)
                + "\""
                + "}";

        response.getWriter().write(
                json
        );
    }


    /*
     * =========================================================
     * ESCAPE JSON
     * =========================================================
     */
    private String escapeJson(
            String value) {

        if (value == null) {

            return "";
        }

        return value
                .replace(
                        "\\",
                        "\\\\"
                )
                .replace(
                        "\"",
                        "\\\""
                )
                .replace(
                        "\r",
                        "\\r"
                )
                .replace(
                        "\n",
                        "\\n"
                )
                .replace(
                        "\t",
                        "\\t"
                )
                .replace(
                        "\b",
                        "\\b"
                )
                .replace(
                        "\f",
                        "\\f"
                );
    }
}
