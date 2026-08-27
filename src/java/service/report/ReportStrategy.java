package service.report;

import dao.ReportDAO;

import java.sql.SQLException;
import java.util.Map;

public interface ReportStrategy {

    void generateReport(
            ReportDAO reportDAO,
            Map<String, Object> reportData)
            throws SQLException;
}
