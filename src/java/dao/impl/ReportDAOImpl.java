package dao.impl;

import dao.ReportDAO;

import model.ReportItem;
import model.ReportSummary;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class ReportDAOImpl implements ReportDAO {

    /*
     * =========================================================
     * APPOINTMENT SUMMARY
     * =========================================================
     */
    @Override
    public ReportSummary getAppointmentSummary()
            throws SQLException {

        ReportSummary summary
                = new ReportSummary();

        String sql
                = "SELECT "
                + "COUNT(*) AS total, "
                + "SUM(CASE "
                + "WHEN status = 'CONFIRMED' "
                + "THEN 1 ELSE 0 END) AS confirmed, "
                + "SUM(CASE "
                + "WHEN status IN ('PENDING_DOCTOR','PENDING_ADMIN') "
                + "THEN 1 ELSE 0 END) AS pending, "
                + "SUM(CASE "
                + "WHEN status LIKE 'REJECTED%' "
                + "THEN 1 ELSE 0 END) AS rejected, "
                + "SUM(CASE "
                + "WHEN status = 'CANCELLED' "
                + "THEN 1 ELSE 0 END) AS cancelled "
                + "FROM appointments";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            if (rs.next()) {

                summary.setTotalAppointments(
                        rs.getInt("total")
                );

                summary.setConfirmedAppointments(
                        rs.getInt("confirmed")
                );

                summary.setPendingAppointments(
                        rs.getInt("pending")
                );

                summary.setRejectedAppointments(
                        rs.getInt("rejected")
                );

                summary.setCancelledAppointments(
                        rs.getInt("cancelled")
                );
            }
        }

        return summary;
    }


    /*
     * =========================================================
     * REVENUE SUMMARY
     * =========================================================
     */
    @Override
    public ReportSummary getRevenueSummary()
            throws SQLException {

        ReportSummary summary
                = new ReportSummary();

        String sql
                = "SELECT "
                + "COALESCE(SUM(total_amount), 0) AS revenue "
                + "FROM bills "
                + "WHERE payment_status = 'PAID'";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            if (rs.next()) {

                summary.setTotalRevenue(
                        rs.getDouble("revenue")
                );
            }
        }

        return summary;
    }


    /*
     * =========================================================
     * TREATMENT SUMMARY
     * =========================================================
     */
    @Override
    public ReportSummary getTreatmentSummary()
            throws SQLException {

        ReportSummary summary
                = new ReportSummary();

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM treatments "
                + "WHERE active = 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            if (rs.next()) {

                summary.setTotalTreatments(
                        rs.getInt("total")
                );
            }
        }

        return summary;
    }


    /*
     * =========================================================
     * MONTHLY REVENUE
     * =========================================================
     */
    @Override
    public List<ReportItem> getMonthlyRevenue()
            throws SQLException {

        List<ReportItem> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "MONTH(created_at) AS month_no, "
                + "MONTHNAME(created_at) AS month_name, "
                + "COALESCE(SUM(total_amount),0) AS revenue "
                + "FROM bills "
                + "WHERE payment_status = 'PAID' "
                + "AND YEAR(created_at) = YEAR(CURDATE()) "
                + "GROUP BY MONTH(created_at), MONTHNAME(created_at) "
                + "ORDER BY MONTH(created_at)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                ReportItem item
                        = new ReportItem();

                item.setLabel(
                        rs.getString("month_name")
                );

                item.setValue(
                        rs.getDouble("revenue")
                );

                list.add(item);
            }
        }

        return list;
    }


    /*
     * =========================================================
     * TREATMENT PERFORMANCE
     * =========================================================
     */
    @Override
    public List<ReportItem> getTreatmentPerformance()
            throws SQLException {

        List<ReportItem> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "treatment_type, "
                + "COUNT(*) AS total "
                + "FROM appointments "
                + "GROUP BY treatment_type "
                + "ORDER BY total DESC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                ReportItem item
                        = new ReportItem();

                item.setLabel(
                        rs.getString(
                                "treatment_type"
                        )
                );

                item.setCount(
                        rs.getInt("total")
                );

                list.add(item);
            }
        }

        return list;
    }


    /*
     * =========================================================
     * DOCTOR APPOINTMENTS
     * =========================================================
     */
    @Override
    public List<ReportItem> getDoctorAppointments()
            throws SQLException {

        List<ReportItem> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, "
                + "COUNT(a.id) AS total "
                + "FROM doctors d "
                + "LEFT JOIN appointments a "
                + "ON d.id = a.doctor_id "
                + "GROUP BY d.id, d.first_name, d.last_name "
                + "ORDER BY total DESC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                ReportItem item
                        = new ReportItem();

                item.setLabel(
                        rs.getString(
                                "doctor_name"
                        )
                );

                item.setCount(
                        rs.getInt("total")
                );

                list.add(item);
            }
        }

        return list;
    }
}
