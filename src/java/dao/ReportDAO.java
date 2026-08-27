package dao;

import model.ReportItem;
import model.ReportSummary;

import java.sql.SQLException;
import java.util.List;

public interface ReportDAO {

    ReportSummary getAppointmentSummary()
            throws SQLException;

    ReportSummary getRevenueSummary()
            throws SQLException;

    ReportSummary getTreatmentSummary()
            throws SQLException;

    List<ReportItem> getMonthlyRevenue()
            throws SQLException;

    List<ReportItem> getTreatmentPerformance()
            throws SQLException;

    List<ReportItem> getDoctorAppointments()
            throws SQLException;
}
