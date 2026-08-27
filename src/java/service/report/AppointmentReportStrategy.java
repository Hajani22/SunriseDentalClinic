package service.report;

import dao.ReportDAO;

import java.sql.SQLException;
import java.util.Map;

public class AppointmentReportStrategy
        implements ReportStrategy {

    @Override
    public void generateReport(
            ReportDAO reportDAO,
            Map<String, Object> reportData)
            throws SQLException {

        reportData.put(
                "appointmentSummary",
                reportDAO.getAppointmentSummary()
        );

        reportData.put(
                "doctorAppointments",
                reportDAO.getDoctorAppointments()
        );
    }
}
