package service.impl;

import service.ReportService;
import service.report.ReportFacade;

import java.sql.SQLException;
import java.util.Map;

public class ReportServiceImpl
        implements ReportService {

    private final ReportFacade reportFacade;

    public ReportServiceImpl() {

        reportFacade
                = new ReportFacade();
    }

    @Override
    public Map<String, Object>
            getDashboardReport()
            throws SQLException {

        return reportFacade
                .generateDashboardReport();
    }
}
