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
                + "(user_id, user_role, title, message, "
                + "appointment_id, is_read) "
                + "VALUES (?, ?, ?, ?, ?, 0)";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    userId
            );

            statement.setString(
                    2,
                    role
            );

            statement.setString(
                    3,
                    title
            );

            statement.setString(
                    4,
                    message
            );

            if (appointmentId > 0) {

                statement.setInt(
                        5,
                        appointmentId
                );

            } else {

                statement.setNull(
                        5,
                        java.sql.Types.INTEGER
                );
            }

            return statement.executeUpdate() > 0;
        }
    }


    @Override
    public List<String[]> getForUser(
            int userId,
            String role)
            throws SQLException {

        List<String[]> notifications =
                new ArrayList<>();

        String sql =
                "SELECT id, title, message, "
                + "appointment_id, is_read, created_at "
                + "FROM notifications "
                + "WHERE user_id = ? "
                + "AND user_role = ? "
                + "ORDER BY created_at DESC";

        try (
            Connection connection =
                    DBConnection.getConnection();

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(
                    1,
                    userId
            );

            statement.setString(
                    2,
                    role
            );

            try (
                ResultSet resultSet =
                        statement.executeQuery()
            ) {

                while (resultSet.next()) {

                    String[] notification =
                            new String[6];

                    notification[0] =
                            String.valueOf(
                                    resultSet.getInt("id")
                            );

                    notification[1] =
                            resultSet.getString("title");

                    notification[2] =
                            resultSet.getString("message");

                    notification[3] =
                            String.valueOf(
                                    resultSet.getInt(
                                            "appointment_id"
                                    )
                            );

                    notification[4] =
                            String.valueOf(
                                    resultSet.getBoolean(
                                            "is_read"
                                    )
                            );

                    notification[5] =
                            String.valueOf(
                                    resultSet.getTimestamp(
                                            "created_at"
                                    )
                            );

                    notifications.add(
                            notification
                    );
                }
            }
        }

        return notifications;
    }
}