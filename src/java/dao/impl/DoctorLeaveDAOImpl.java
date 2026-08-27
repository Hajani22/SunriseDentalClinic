package dao.impl;

import dao.DoctorLeaveDAO;
import model.DoctorLeave;
import util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class DoctorLeaveDAOImpl
        implements DoctorLeaveDAO {

    @Override
    public List<DoctorLeave> getAllLeaves()
            throws SQLException {

        List<DoctorLeave> leaves
                = new ArrayList<>();

        String sql
                = "SELECT dl.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_leaves dl "
                + "INNER JOIN doctors d "
                + "ON dl.doctor_id = d.id "
                + "ORDER BY dl.leave_date DESC, "
                + "doctor_name ASC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                leaves.add(
                        mapRow(rs)
                );
            }
        }

        return leaves;
    }

    @Override
    public List<DoctorLeave> getLeavesByDoctor(
            int doctorId)
            throws SQLException {

        List<DoctorLeave> leaves
                = new ArrayList<>();

        String sql
                = "SELECT dl.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_leaves dl "
                + "INNER JOIN doctors d "
                + "ON dl.doctor_id = d.id "
                + "WHERE dl.doctor_id=? "
                + "ORDER BY dl.leave_date DESC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    doctorId
            );

            try (ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    leaves.add(
                            mapRow(rs)
                    );
                }
            }
        }

        return leaves;
    }

    @Override
    public DoctorLeave getById(
            int id)
            throws SQLException {

        String sql
                = "SELECT dl.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_leaves dl "
                + "INNER JOIN doctors d "
                + "ON dl.doctor_id=d.id "
                + "WHERE dl.id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs
                    = ps.executeQuery()) {

                if (rs.next()) {

                    return mapRow(rs);
                }
            }
        }

        return null;
    }

    @Override
    public boolean addLeave(
            DoctorLeave leave)
            throws SQLException {

        String sql
                = "INSERT INTO doctor_leaves "
                + "(doctor_id, leave_date, reason, status) "
                + "VALUES (?, ?, ?, 'ACTIVE')";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    leave.getDoctorId()
            );

            ps.setDate(
                    2,
                    leave.getLeaveDate()
            );

            ps.setString(
                    3,
                    leave.getReason()
            );

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean cancelLeave(
            int id)
            throws SQLException {

        String sql
                = "UPDATE doctor_leaves "
                + "SET status='CANCELLED' "
                + "WHERE id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean isDoctorOnLeave(
            int doctorId,
            Date leaveDate)
            throws SQLException {

        String sql
                = "SELECT COUNT(*) "
                + "FROM doctor_leaves "
                + "WHERE doctor_id=? "
                + "AND leave_date=? "
                + "AND status='ACTIVE'";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    doctorId
            );

            ps.setDate(
                    2,
                    leaveDate
            );

            try (ResultSet rs
                    = ps.executeQuery()) {

                rs.next();

                return rs.getInt(1) > 0;
            }
        }
    }

    private DoctorLeave mapRow(
            ResultSet rs)
            throws SQLException {

        DoctorLeave leave
                = new DoctorLeave();

        leave.setId(
                rs.getInt("id")
        );

        leave.setDoctorId(
                rs.getInt("doctor_id")
        );

        leave.setDoctorName(
                rs.getString("doctor_name")
        );

        leave.setLeaveDate(
                rs.getDate("leave_date")
        );

        leave.setReason(
                rs.getString("reason")
        );

        leave.setStatus(
                rs.getString("status")
        );

        return leave;
    }
}
