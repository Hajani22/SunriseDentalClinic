package service.report;

import dao.ReportDAO;
import dao.impl.ReportDAOImpl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class ReportFacade {

    private final ReportDAO reportDAO;

    private final ReportStrategy appointmentStrategy;

    private final ReportStrategy revenueStrategy;

    private final ReportStrategy treatmentStrategy;


    /*
     * =========================================================
     * CONSTRUCTOR
     * =========================================================
     */
    public ReportFacade() {

        reportDAO
                = new ReportDAOImpl();

        appointmentStrategy
                = new AppointmentReportStrategy();

        revenueStrategy
                = new RevenueReportStrategy();

        treatmentStrategy
                = new TreatmentReportStrategy();
    }


    /*
     * =========================================================
     * GENERATE COMPLETE DASHBOARD REPORT
     * =========================================================
     */
    public Map<String, Object>
            generateDashboardReport()
            throws SQLException {

        Map<String, Object> data
                = new HashMap<>();


        /*
         * Appointment reports
         */
        appointmentStrategy.generateReport(
                reportDAO,
                data
        );


        /*
         * Revenue reports
         */
        revenueStrategy.generateReport(
                reportDAO,
                data
        );


        /*
         * Treatment reports
         */
        treatmentStrategy.generateReport(
                reportDAO,
                data
        );

        return data;
    }
}
