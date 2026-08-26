package dao.impl;

import dao.BillingDAO;
import model.Bill;
import util.DBConnection;

import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.List;

public class BillingDAOImpl
        implements BillingDAO {

    @Override
    public Bill findConfirmedAppointment(
            String appointmentNo)
            throws SQLException {

        String sql
                = "SELECT "
                + "a.id AS appointment_id, "
                + "a.appointment_no, "
                + "a.patient_id, "
                + "a.patient_name, "
                + "a.patient_phone, "
                + "a.treatment_type, "
                + "a.appointment_date, "
                + "a.appointment_time, "
                + "CONCAT("
                + "d.first_name,' ',d.last_name"
                + ") AS doctor_name "
                + "FROM appointments a "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id=d.id "
                + "WHERE a.appointment_no=? "
                + "AND a.status='CONFIRMED' "
                + "LIMIT 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    appointmentNo.trim()
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                Bill bill
                        = new Bill();

                bill.setAppointmentId(
                        rs.getInt("appointment_id")
                );

                bill.setAppointmentNo(
                        rs.getString("appointment_no")
                );

                bill.setPatientId(
                        rs.getInt("patient_id")
                );

                bill.setPatientName(
                        rs.getString("patient_name")
                );

                bill.setPatientPhone(
                        rs.getString("patient_phone")
                );

                bill.setDoctorName(
                        rs.getString("doctor_name")
                );

                bill.setTreatmentType(
                        rs.getString("treatment_type")
                );

                bill.setAppointmentDate(
                        rs.getString("appointment_date")
                );

                bill.setAppointmentTime(
                        rs.getString("appointment_time")
                );

                return bill;
            }
        }
    }

    @Override
    public BigDecimal getTreatmentPrice(
            String treatmentName)
            throws SQLException {

        String sql
                = "SELECT treatment_price "
                + "FROM treatments "
                + "WHERE treatment_name=? "
                + "AND active=1 "
                + "LIMIT 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatmentName
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getBigDecimal(
                            "treatment_price"
                    );
                }
            }
        }

        return BigDecimal.ZERO;
    }

    @Override
    public BigDecimal getConsultationFee(
            String treatmentName)
            throws SQLException {

        String sql
                = "SELECT consultation_fee "
                + "FROM treatments "
                + "WHERE treatment_name=? "
                + "AND active=1 "
                + "LIMIT 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatmentName
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getBigDecimal(
                            "consultation_fee"
                    );
                }
            }
        }

        return BigDecimal.ZERO;
    }

    @Override
    public boolean billExistsForAppointment(
            int appointmentId)
            throws SQLException {

        String sql
                = "SELECT COUNT(*) "
                + "FROM bills "
                + "WHERE appointment_id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    appointmentId
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                rs.next();

                return rs.getInt(1) > 0;
            }
        }
    }

    @Override
    public boolean createBill(
            Bill bill)
            throws SQLException {

        String sql
                = "INSERT INTO bills "
                + "(bill_no,"
                + "appointment_id,"
                + "patient_id,"
                + "cashier_id,"
                + "treatment_type,"
                + "treatment_amount,"
                + "consultation_fee,"
                + "discount,"
                + "total_amount,"
                + "payment_method,"
                + "payment_status) "
                + "VALUES "
                + "(?,?,?,?,?,?,?,?,?,?,?)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )) {

            ps.setString(
                    1,
                    bill.getBillNo()
            );

            ps.setInt(
                    2,
                    bill.getAppointmentId()
            );

            ps.setInt(
                    3,
                    bill.getPatientId()
            );

            ps.setInt(
                    4,
                    bill.getCashierId()
            );

            ps.setString(
                    5,
                    bill.getTreatmentType()
            );

            ps.setBigDecimal(
                    6,
                    bill.getTreatmentAmount()
            );

            ps.setBigDecimal(
                    7,
                    bill.getConsultationFee()
            );

            ps.setBigDecimal(
                    8,
                    bill.getDiscount()
            );

            ps.setBigDecimal(
                    9,
                    bill.getTotalAmount()
            );

            ps.setString(
                    10,
                    bill.getPaymentMethod()
            );

            ps.setString(
                    11,
                    bill.getPaymentStatus()
            );

            int rows
                    = ps.executeUpdate();

            if (rows != 1) {
                return false;
            }

            try (
                    ResultSet keys
                    = ps.getGeneratedKeys()) {

                if (keys.next()) {

                    bill.setId(
                            keys.getInt(1)
                    );
                }
            }

            return true;
        }
    }

    @Override
    public Bill getBillById(
            int id)
            throws SQLException {

        String sql
                = "SELECT "
                + "b.*, "
                + "a.appointment_no, "
                + "a.patient_name, "
                + "a.patient_phone, "
                + "a.appointment_date, "
                + "a.appointment_time, "
                + "CONCAT("
                + "d.first_name,' ',d.last_name"
                + ") AS doctor_name "
                + "FROM bills b "
                + "JOIN appointments a "
                + "ON b.appointment_id=a.id "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id=d.id "
                + "WHERE b.id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    id
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                return mapBill(rs);
            }
        }
    }

    @Override
    public List<Bill> getRecentBills(
            int limit)
            throws SQLException {

        List<Bill> bills
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "b.*, "
                + "a.appointment_no, "
                + "a.patient_name, "
                + "a.patient_phone, "
                + "a.appointment_date, "
                + "a.appointment_time, "
                + "CONCAT("
                + "d.first_name,' ',d.last_name"
                + ") AS doctor_name "
                + "FROM bills b "
                + "JOIN appointments a "
                + "ON b.appointment_id=a.id "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id=d.id "
                + "ORDER BY b.created_at DESC "
                + "LIMIT ?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    limit
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    bills.add(
                            mapBill(rs)
                    );
                }
            }
        }

        return bills;
    }

    private Bill mapBill(
            ResultSet rs)
            throws SQLException {

        Bill bill
                = new Bill();

        bill.setId(
                rs.getInt("id")
        );

        bill.setBillNo(
                rs.getString("bill_no")
        );

        bill.setAppointmentId(
                rs.getInt("appointment_id")
        );

        bill.setPatientId(
                rs.getInt("patient_id")
        );

        bill.setCashierId(
                rs.getInt("cashier_id")
        );

        bill.setAppointmentNo(
                rs.getString("appointment_no")
        );

        bill.setPatientName(
                rs.getString("patient_name")
        );

        bill.setPatientPhone(
                rs.getString("patient_phone")
        );

        bill.setDoctorName(
                rs.getString("doctor_name")
        );

        bill.setTreatmentType(
                rs.getString("treatment_type")
        );

        bill.setAppointmentDate(
                rs.getString("appointment_date")
        );

        bill.setAppointmentTime(
                rs.getString("appointment_time")
        );

        bill.setTreatmentAmount(
                rs.getBigDecimal(
                        "treatment_amount"
                )
        );

        bill.setConsultationFee(
                rs.getBigDecimal(
                        "consultation_fee"
                )
        );

        bill.setDiscount(
                rs.getBigDecimal(
                        "discount"
                )
        );

        bill.setTotalAmount(
                rs.getBigDecimal(
                        "total_amount"
                )
        );

        bill.setPaymentMethod(
                rs.getString(
                        "payment_method"
                )
        );

        bill.setPaymentStatus(
                rs.getString(
                        "payment_status"
                )
        );

        bill.setCreatedAt(
                rs.getString(
                        "created_at"
                )
        );

        return bill;
    }
}
