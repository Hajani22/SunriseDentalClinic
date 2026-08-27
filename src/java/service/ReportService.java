package service;

import java.sql.SQLException;
import java.util.Map;

public interface ReportService {

    Map<String, Object>
            getDashboardReport()
            throws SQLException;
}
