package dao.impl;

import dao.TreatmentDAO;
import model.Treatment;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class TreatmentDAOImpl
        implements TreatmentDAO {

    @Override
    public List<Treatment> getAll()
            throws SQLException {

        List<Treatment> treatments
                = new ArrayList<>();

        String sql
                = "SELECT * FROM treatments "
                + "ORDER BY active DESC, "
                + "treatment_name ASC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                treatments.add(
                        mapRow(rs)
                );
            }
        }

        return treatments;
    }

    @Override
    public List<Treatment> getActive()
            throws SQLException {

        List<Treatment> treatments
                = new ArrayList<>();

        String sql
                = "SELECT * FROM treatments "
                + "WHERE active=1 "
                + "ORDER BY treatment_name ASC";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                treatments.add(
                        mapRow(rs)
                );
            }
        }

        return treatments;
    }

    @Override
    public Treatment getById(
            int id)
            throws SQLException {

        String sql
                = "SELECT * FROM treatments "
                + "WHERE id=?";

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
    public boolean add(
            Treatment treatment)
            throws SQLException {

        String sql
                = "INSERT INTO treatments "
                + "(treatment_name, "
                + "treatment_price, "
                + "consultation_fee, "
                + "active) "
                + "VALUES (?, ?, ?, ?)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatment.getTreatmentName()
            );

            ps.setBigDecimal(
                    2,
                    treatment.getTreatmentPrice()
            );

            ps.setBigDecimal(
                    3,
                    treatment.getConsultationFee()
            );

            ps.setBoolean(
                    4,
                    treatment.isActive()
            );

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean update(
            Treatment treatment)
            throws SQLException {

        String sql
                = "UPDATE treatments "
                + "SET treatment_name=?, "
                + "treatment_price=?, "
                + "consultation_fee=? "
                + "WHERE id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(
                    1,
                    treatment.getTreatmentName()
            );

            ps.setBigDecimal(
                    2,
                    treatment.getTreatmentPrice()
            );

            ps.setBigDecimal(
                    3,
                    treatment.getConsultationFee()
            );

            ps.setInt(
                    4,
                    treatment.getId()
            );

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean setActive(
            int id,
            boolean active)
            throws SQLException {

        String sql
                = "UPDATE treatments "
                + "SET active=? "
                + "WHERE id=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setBoolean(1, active);

            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }

    private Treatment mapRow(
            ResultSet rs)
            throws SQLException {

        Treatment treatment
                = new Treatment();

        treatment.setId(
                rs.getInt("id")
        );

        treatment.setTreatmentName(
                rs.getString(
                        "treatment_name"
                )
        );

        treatment.setTreatmentPrice(
                rs.getBigDecimal(
                        "treatment_price"
                )
        );

        treatment.setConsultationFee(
                rs.getBigDecimal(
                        "consultation_fee"
                )
        );

        treatment.setActive(
                rs.getBoolean("active")
        );

        return treatment;
    }
}
