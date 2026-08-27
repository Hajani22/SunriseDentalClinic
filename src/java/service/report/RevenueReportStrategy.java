package service.report;

import dao.ReportDAO;

import java.sql.SQLException;
import java.util.Map;

public class RevenueReportStrategy
        implements ReportStrategy {

    @Override
    public void generateReport(
            ReportDAO reportDAO,
            Map<String, Object> reportData)
            throws SQLException {

        reportData.put(
                "revenueSummary",
                reportDAO.getRevenueSummary()
        );

        reportData.put(
                "monthlyRevenue",
                reportDAO.getMonthlyRevenue()
        );
    }
}
