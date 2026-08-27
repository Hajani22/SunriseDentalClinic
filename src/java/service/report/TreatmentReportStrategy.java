package service.report;

import dao.ReportDAO;

import java.sql.SQLException;
import java.util.Map;

public class TreatmentReportStrategy
        implements ReportStrategy {

    @Override
    public void generateReport(
            ReportDAO reportDAO,
            Map<String, Object> reportData)
            throws SQLException {

        reportData.put(
                "treatmentSummary",
                reportDAO.getTreatmentSummary()
        );

        reportData.put(
                "treatmentPerformance",
                reportDAO.getTreatmentPerformance()
        );
    }
}
