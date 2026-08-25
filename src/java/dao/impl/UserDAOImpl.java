package dao.impl;

import dao.UserDAO;
import model.User;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Database access for Patient, Doctor, Cashier and Admin accounts.
 *
 * This implementation deliberately checks the real columns in the
 * existing MySQL table before inserting. This keeps the application
 * compatible with the sunrise_dental database already created in
 * phpMyAdmin (including the current doctors table).
 */
public class UserDAOImpl implements UserDAO {

    private String tableForRole(String role) {
        if (role == null) {
            throw new IllegalArgumentException("Role cannot be null");
        }

        switch (role.trim().toLowerCase()) {
            case "patient":
                return "patients";
            case "doctor":
                return "doctors";
            case "cashier":
                return "cashiers";
            case "admin":
                return "admins";
            default:
                throw new IllegalArgumentException("Invalid role: " + role);
        }
    }

    @Override
    public boolean registerUser(User user) {
        if (user == null || user.getRole() == null) {
            return false;
        }

        String role = user.getRole().trim().toLowerCase();
        String table;

        try {
            table = tableForRole(role);
        } catch (IllegalArgumentException e) {
            return false;
        }

        try (Connection connection = DBConnection.getConnection()) {

            /*
             * Build the INSERT from columns that actually exist in the
             * user's current database. This fixes the mismatch where the
             * current doctors table has medical_registration, specialization,
             * date_of_birth and gender but does not have qualification/experience.
             */
            Map<String, Object> values = new LinkedHashMap<>();

            values.put("first_name", user.getFirstName());
            values.put("last_name", user.getLastName());
            values.put("email", user.getEmail());
            values.put("phone", user.getPhone());
            values.put("password", user.getPassword());

            addIfColumn(values, connection, table, "date_of_birth", user.getDateOfBirth());
            addIfColumn(values, connection, table, "gender", user.getGender());

            if ("doctor".equals(role)) {
                addIfColumn(values, connection, table,
                        "medical_registration_no", user.getMedicalRegistrationNo());
                addIfColumn(values, connection, table,
                        "medical_registration", user.getMedicalRegistrationNo());
                addIfColumn(values, connection, table,
                        "specialization", user.getSpecialization());
                addIfColumn(values, connection, table,
                        "qualification", user.getQualification());
                addIfColumn(values, connection, table,
                        "experience", user.getExperience());
            }

            if ("cashier".equals(role)) {
                addIfColumn(values, connection, table,
                        "employee_id", user.getEmployeeId());
                addIfColumn(values, connection, table,
                        "department", user.getDepartment());
                addIfColumn(values, connection, table,
                        "cashier_shift", user.getCashierShift());
                addIfColumn(values, connection, table,
                        "pos_id", user.getPosId());
            }

            if ("admin".equals(role)) {
                addIfColumn(values, connection, table,
                        "employee_id", user.getEmployeeId());
                addIfColumn(values, connection, table,
                        "department", user.getDepartment());
            }

            StringBuilder columns = new StringBuilder();
            StringBuilder placeholders = new StringBuilder();
            List<Object> parameters = new ArrayList<>();

            for (Map.Entry<String, Object> entry : values.entrySet()) {
                if (columns.length() > 0) {
                    columns.append(", ");
                    placeholders.append(", ");
                }

                columns.append('`').append(entry.getKey()).append('`');
                placeholders.append('?');
                parameters.add(entry.getValue());
            }

            String sql = "INSERT INTO `" + table + "` ("
                    + columns + ") VALUES (" + placeholders + ")";

            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                for (int i = 0; i < parameters.size(); i++) {
                    Object value = parameters.get(i);
                    int index = i + 1;

                    if (value instanceof java.sql.Date) {
                        ps.setDate(index, (java.sql.Date) value);
                    } else if (value instanceof Integer) {
                        ps.setInt(index, (Integer) value);
                    } else if (value == null) {
                        ps.setNull(index, Types.VARCHAR);
                    } else {
                        ps.setString(index, value.toString());
                    }
                }

                return ps.executeUpdate() == 1;
            }

        } catch (SQLException e) {
            System.err.println("Registration database error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private void addIfColumn(
            Map<String, Object> values,
            Connection connection,
            String table,
            String column,
            Object value) throws SQLException {

        if (hasColumn(connection, table, column)) {
            values.put(column, value);
        }
    }

    private boolean hasColumn(
            Connection connection,
            String table,
            String column) throws SQLException {

        DatabaseMetaData metaData = connection.getMetaData();

        try (ResultSet rs = metaData.getColumns(
                connection.getCatalog(),
                null,
                table,
                column)) {

            return rs.next();
        }
    }

    @Override
    public User loginUser(
            String email,
            String password,
            String role) {

        if (email == null || password == null || role == null) {
            return null;
        }

        String table;

        try {
            table = tableForRole(role);
        } catch (IllegalArgumentException e) {
            return null;
        }

        String sql = "SELECT id, first_name, last_name, email, phone, password "
                + "FROM `" + table + "` "
                + "WHERE LOWER(email)=LOWER(?) LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                String databasePassword = rs.getString("password");
                String hashedPassword = PasswordUtil.hashPassword(password);

                if (!hashedPassword.equals(databasePassword)) {
                    return null;
                }

                User user = new User();
                user.setId(rs.getInt("id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(role.trim().toLowerCase());

                return user;
            }

        } catch (SQLException e) {
            System.err.println("Login database error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        String[] tables = {"patients", "doctors", "cashiers", "admins"};

        try (Connection connection = DBConnection.getConnection()) {

            for (String table : tables) {
                String sql = "SELECT id FROM `" + table + "` "
                        + "WHERE LOWER(email)=LOWER(?) LIMIT 1";

                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    ps.setString(1, email.trim());

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return true;
                        }
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Email check database error: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }
}
