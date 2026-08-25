package dao.impl;

import dao.NotificationDAO;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class NotificationDAOImpl
        implements NotificationDAO {

    @Override
    public boolean create(
            int userId,
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        String sql =
                "INSERT INTO notifications "
                + "(user_id,user_role,title,"
                + "message,appointment_id,is_read) "
                + "VALUES (?,?,?,?,?,0)";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setString(2, role);
            ps.setString(3, title);
            ps.setString(4, message);
            ps.setInt(5, appointmentId);

            return ps.executeUpdate() == 1;
        }
    }

    /*
     * Create notification for all users
     * with the selected role.
     *
     * Example:
     * role = admin
     */
    @Override
    public boolean createForRole(
            String role,
            String title,
            String message,
            int appointmentId)
            throws SQLException {

        String sql =
                "INSERT INTO notifications "
                + "(user_id,user_role,title,message,"
                + "appointment_id,is_read) "
                + "SELECT id,?,?,?,?,0 "
                + "FROM ";

        String table;

        switch (role.toLowerCase()) {

            case "admin":
                table = "admins";
                break;

            case "doctor":
                table = "doctors";
                break;

            case "patient":
                table = "patients";
                break;

            case "cashier":
                table = "cashiers";
                break;

            default:
                throw new IllegalArgumentException(
                        "Invalid role: " + role
                );
        }

        sql += table;

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setString(1, role);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.setInt(4, appointmentId);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<String[]> getForUser(
            int userId,
            String role)
            throws SQLException {

        List<String[]> list =
                new ArrayList<>();

        String sql =
                "SELECT id,title,message,"
                + "is_read,created_at "
                + "FROM notifications "
                + "WHERE user_id=? "
                + "AND user_role=? "
                + "ORDER BY created_at DESC";

        try (
                Connection con =
                        DBConnection.getConnection();

                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);
            ps.setString(2, role);

            try (
                    ResultSet rs =
                            ps.executeQuery()
            ) {

                while (rs.next()) {

                    list.add(
                            new String[]{
                                String.valueOf(
                                        rs.getInt("id")
                                ),

                                rs.getString("title"),

                                rs.getString("message"),

                                String.valueOf(
                                        rs.getInt("is_read")
                                ),

                                rs.getString("created_at")
                            }
                    );
                }
            }
        }

        return list;
    }
}