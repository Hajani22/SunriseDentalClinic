package dao.impl;

import dao.PaymentDAO;
import model.Payment;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import java.util.List;

public class PaymentDAOImpl implements PaymentDAO {


    /* =========================================================
       GET CONFIRMED APPOINTMENT
       ========================================================= */
    @Override
    public Payment getAppointment(
            String appointmentNo)
            throws SQLException {

        String sql
                = "SELECT "
                + "a.id AS appointment_id, "
                + "a.appointment_no, "
                + "a.patient_id, "
                + "a.patient_name, "
                + "a.treatment_type, "
                + "CONCAT("
                + "d.first_name, ' ', d.last_name"
                + ") AS doctor_name "
                + "FROM appointments a "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id = d.id "
                + "WHERE a.appointment_no = ? "
                + "AND a.status = 'CONFIRMED' "
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

                Payment payment
                        = new Payment();

                payment.setAppointmentId(
                        rs.getInt(
                                "appointment_id"
                        )
                );

                payment.setAppointmentNo(
                        rs.getString(
                                "appointment_no"
                        )
                );

                payment.setPatientId(
                        rs.getInt(
                                "patient_id"
                        )
                );

                payment.setPatientName(
                        rs.getString(
                                "patient_name"
                        )
                );

                payment.setDoctorName(
                        rs.getString(
                                "doctor_name"
                        )
                );

                payment.setTreatmentType(
                        rs.getString(
                                "treatment_type"
                        )
                );

                return payment;
            }
        }
    }


    /* =========================================================
       GET TREATMENT AMOUNT
       ========================================================= */
    @Override
    public BigDecimal getTreatmentAmount(
            String treatmentName)
            throws SQLException {

        String sql
                = "SELECT treatment_price "
                + "FROM treatments "
                + "WHERE treatment_name = ? "
                + "AND active = 1 "
                + "LIMIT 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatmentName.trim()
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    BigDecimal amount
                            = rs.getBigDecimal(
                                    "treatment_price"
                            );

                    if (amount != null) {

                        return amount;
                    }
                }
            }
        }

        return BigDecimal.ZERO;
    }


    /* =========================================================
       GET CONSULTATION FEE
       ========================================================= */
    public BigDecimal getConsultationFee(
            String treatmentName)
            throws SQLException {

        String sql
                = "SELECT consultation_fee "
                + "FROM treatments "
                + "WHERE treatment_name = ? "
                + "AND active = 1 "
                + "LIMIT 1";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatmentName.trim()
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    BigDecimal fee
                            = rs.getBigDecimal(
                                    "consultation_fee"
                            );

                    if (fee != null) {

                        return fee;
                    }
                }
            }
        }

        return BigDecimal.ZERO;
    }


    /* =========================================================
       GET CONSULTATION PAID
       ========================================================= */
    @Override
    public BigDecimal getConsultationPaid(
            int appointmentId)
            throws SQLException {

        return getPaidAmount(
                appointmentId,
                "CONSULTATION"
        );
    }


    /* =========================================================
       GET TREATMENT PAID
       ========================================================= */
    @Override
    public BigDecimal getTreatmentPaid(
            int appointmentId)
            throws SQLException {

        return getPaidAmount(
                appointmentId,
                "TREATMENT"
        );
    }


    /* =========================================================
       COMMON PAID AMOUNT
       ========================================================= */
    private BigDecimal getPaidAmount(
            int appointmentId,
            String paymentType)
            throws SQLException {

        String sql
                = "SELECT COALESCE("
                + "SUM(amount), 0) "
                + "FROM payments "
                + "WHERE appointment_id = ? "
                + "AND payment_type = ? "
                + "AND payment_status = 'PAID'";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    appointmentId
            );

            ps.setString(
                    2,
                    paymentType
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    BigDecimal amount
                            = rs.getBigDecimal(1);

                    if (amount != null) {

                        return amount;
                    }
                }
            }
        }

        return BigDecimal.ZERO;
    }


    /* =========================================================
       CREATE PAYMENT
       ========================================================= */
    @Override
    public boolean createPayment(
            Payment payment)
            throws SQLException {

        String sql
                = "INSERT INTO payments "
                + "(payment_no, "
                + "appointment_id, "
                + "patient_id, "
                + "payment_type, "
                + "amount, "
                + "payment_method, "
                + "payment_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    payment.getPaymentNo()
            );

            ps.setInt(
                    2,
                    payment.getAppointmentId()
            );

            ps.setInt(
                    3,
                    payment.getPatientId()
            );

            ps.setString(
                    4,
                    payment.getPaymentType()
            );

            ps.setBigDecimal(
                    5,
                    payment.getAmount()
            );

            ps.setString(
                    6,
                    payment.getPaymentMethod()
            );

            ps.setString(
                    7,
                    "PAID"
            );

            return ps.executeUpdate() == 1;
        }
    }


    /* =========================================================
       PATIENT PAYMENT HISTORY
       ========================================================= */
    @Override
    public List<Payment> getPatientPayments(
            int patientId)
            throws SQLException {

        List<Payment> list
                = new ArrayList<>();

        String sql
                = "SELECT * "
                + "FROM payments "
                + "WHERE patient_id = ? "
                + "ORDER BY created_at DESC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    patientId
            );

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    Payment payment
                            = new Payment();

                    payment.setId(
                            rs.getInt("id")
                    );

                    payment.setPaymentNo(
                            rs.getString(
                                    "payment_no"
                            )
                    );

                    payment.setAppointmentId(
                            rs.getInt(
                                    "appointment_id"
                            )
                    );

                    payment.setPatientId(
                            rs.getInt(
                                    "patient_id"
                            )
                    );

                    payment.setPaymentType(
                            rs.getString(
                                    "payment_type"
                            )
                    );

                    payment.setAmount(
                            rs.getBigDecimal(
                                    "amount"
                            )
                    );

                    payment.setPaymentMethod(
                            rs.getString(
                                    "payment_method"
                            )
                    );

                    payment.setPaymentStatus(
                            rs.getString(
                                    "payment_status"
                            )
                    );

                    payment.setCreatedAt(
                            rs.getString(
                                    "created_at"
                            )
                    );

                    list.add(payment);
                }
            }
        }

        return list;
    }


    /* =========================================================
       GET ALL PAYMENTS
       
       IMPORTANT FIX:
       LEFT JOIN is used instead of JOIN.
       
       This ensures that payment records are NOT hidden
       when appointment/doctor information is unavailable.
       ========================================================= */
    @Override
    public List<Payment> getAllPayments()
            throws SQLException {

        List<Payment> list
                = new ArrayList<>();

        String sql
                = "SELECT "
                + "p.id, "
                + "p.payment_no, "
                + "p.appointment_id, "
                + "p.patient_id, "
                + "p.payment_type, "
                + "p.amount, "
                + "p.payment_method, "
                + "p.payment_status, "
                + "p.created_at, "
                + "a.appointment_no, "
                + "a.patient_name, "
                + "a.treatment_type, "
                + "CONCAT("
                + "d.first_name, ' ', d.last_name"
                + ") AS doctor_name "
                + "FROM payments p "
                + "LEFT JOIN appointments a "
                + "ON p.appointment_id = a.id "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id = d.id "
                + "ORDER BY p.created_at DESC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                Payment payment
                        = new Payment();

                payment.setId(
                        rs.getInt("id")
                );

                payment.setPaymentNo(
                        rs.getString(
                                "payment_no"
                        )
                );

                payment.setAppointmentId(
                        rs.getInt(
                                "appointment_id"
                        )
                );

                payment.setPatientId(
                        rs.getInt(
                                "patient_id"
                        )
                );

                payment.setAppointmentNo(
                        rs.getString(
                                "appointment_no"
                        )
                );

                payment.setPatientName(
                        rs.getString(
                                "patient_name"
                        )
                );

                payment.setDoctorName(
                        rs.getString(
                                "doctor_name"
                        )
                );

                payment.setTreatmentType(
                        rs.getString(
                                "treatment_type"
                        )
                );

                payment.setPaymentType(
                        rs.getString(
                                "payment_type"
                        )
                );

                payment.setAmount(
                        rs.getBigDecimal(
                                "amount"
                        )
                );

                payment.setPaymentMethod(
                        rs.getString(
                                "payment_method"
                        )
                );

                payment.setPaymentStatus(
                        rs.getString(
                                "payment_status"
                        )
                );

                payment.setCreatedAt(
                        rs.getString(
                                "created_at"
                        )
                );

                list.add(payment);
            }
        }

        return list;
    }
}
