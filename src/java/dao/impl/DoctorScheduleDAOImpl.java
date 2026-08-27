package dao.impl;

import dao.DoctorScheduleDAO;
import model.DoctorSchedule;
import util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DoctorScheduleDAOImpl
        implements DoctorScheduleDAO {

    @Override
    public List<DoctorSchedule> getAllSchedules()
            throws SQLException {

        List<DoctorSchedule> schedules
                = new ArrayList<>();

        String sql
                = "SELECT ds.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_schedules ds "
                + "INNER JOIN doctors d "
                + "ON ds.doctor_id = d.id "
                + "ORDER BY d.first_name, "
                + "FIELD(ds.day_of_week,"
                + "'MONDAY','TUESDAY','WEDNESDAY',"
                + "'THURSDAY','FRIDAY','SATURDAY','SUNDAY')";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                schedules.add(mapRow(rs));
            }
        }

        return schedules;
    }

    @Override
    public List<DoctorSchedule> getSchedulesByDoctor(
            int doctorId)
            throws SQLException {

        List<DoctorSchedule> schedules
                = new ArrayList<>();

        String sql
                = "SELECT ds.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_schedules ds "
                + "INNER JOIN doctors d "
                + "ON ds.doctor_id = d.id "
                + "WHERE ds.doctor_id=? "
                + "ORDER BY FIELD(ds.day_of_week,"
                + "'MONDAY','TUESDAY','WEDNESDAY',"
                + "'THURSDAY','FRIDAY','SATURDAY','SUNDAY')";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            try (ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    schedules.add(mapRow(rs));
                }
            }
        }

        return schedules;
    }

    @Override
    public DoctorSchedule getSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException {

        String sql
                = "SELECT ds.*, "
                + "CONCAT(d.first_name, ' ', d.last_name) "
                + "AS doctor_name "
                + "FROM doctor_schedules ds "
                + "INNER JOIN doctors d "
                + "ON ds.doctor_id = d.id "
                + "WHERE ds.doctor_id=? "
                + "AND ds.day_of_week=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setString(2, dayOfWeek);

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
    public boolean saveSchedule(
            DoctorSchedule schedule)
            throws SQLException {

        String sql
                = "INSERT INTO doctor_schedules "
                + "(doctor_id, day_of_week, "
                + "start_time, end_time, "
                + "break_start, break_end, is_available) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE "
                + "start_time=VALUES(start_time), "
                + "end_time=VALUES(end_time), "
                + "break_start=VALUES(break_start), "
                + "break_end=VALUES(break_end), "
                + "is_available=VALUES(is_available)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    schedule.getDoctorId()
            );

            ps.setString(
                    2,
                    schedule.getDayOfWeek()
            );

            ps.setTime(
                    3,
                    Time.valueOf(
                            normalizeTime(
                                    schedule.getStartTime()
                            )
                    )
            );

            ps.setTime(
                    4,
                    Time.valueOf(
                            normalizeTime(
                                    schedule.getEndTime()
                            )
                    )
            );

            if (isBlank(schedule.getBreakStart())) {

                ps.setNull(
                        5,
                        java.sql.Types.TIME
                );

            } else {

                ps.setTime(
                        5,
                        Time.valueOf(
                                normalizeTime(
                                        schedule.getBreakStart()
                                )
                        )
                );
            }

            if (isBlank(schedule.getBreakEnd())) {

                ps.setNull(
                        6,
                        java.sql.Types.TIME
                );

            } else {

                ps.setTime(
                        6,
                        Time.valueOf(
                                normalizeTime(
                                        schedule.getBreakEnd()
                                )
                        )
                );
            }

            ps.setBoolean(
                    7,
                    schedule.isAvailable()
            );

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException {

        String sql
                = "DELETE FROM doctor_schedules "
                + "WHERE doctor_id=? "
                + "AND day_of_week=?";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setString(2, dayOfWeek);

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean isDoctorAvailable(
            int doctorId,
            String date,
            String time)
            throws SQLException {

        LocalDate localDate
                = LocalDate.parse(date);

        DayOfWeek day
                = localDate.getDayOfWeek();

        String dayName
                = day.name();

        String sql
                = "SELECT COUNT(*) "
                + "FROM doctor_schedules "
                + "WHERE doctor_id=? "
                + "AND day_of_week=? "
                + "AND is_available=1 "
                + "AND start_time <= ? "
                + "AND end_time > ? "
                + "AND (break_start IS NULL "
                + "OR break_end IS NULL "
                + "OR NOT (? >= break_start "
                + "AND ? < break_end))";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            Time appointmentTime
                    = Time.valueOf(
                            normalizeTime(time)
                    );

            ps.setInt(1, doctorId);
            ps.setString(2, dayName);
            ps.setTime(3, appointmentTime);
            ps.setTime(4, appointmentTime);
            ps.setTime(5, appointmentTime);
            ps.setTime(6, appointmentTime);

            try (ResultSet rs
                    = ps.executeQuery()) {

                rs.next();

                return rs.getInt(1) > 0;
            }
        }
    }

    private DoctorSchedule mapRow(
            ResultSet rs)
            throws SQLException {

        DoctorSchedule schedule
                = new DoctorSchedule();

        schedule.setId(
                rs.getInt("id")
        );

        schedule.setDoctorId(
                rs.getInt("doctor_id")
        );

        schedule.setDoctorName(
                rs.getString("doctor_name")
        );

        schedule.setDayOfWeek(
                rs.getString("day_of_week")
        );

        schedule.setStartTime(
                formatTime(
                        rs.getTime("start_time")
                )
        );

        schedule.setEndTime(
                formatTime(
                        rs.getTime("end_time")
                )
        );

        Time breakStart
                = rs.getTime("break_start");

        Time breakEnd
                = rs.getTime("break_end");

        schedule.setBreakStart(
                breakStart == null
                        ? ""
                        : formatTime(breakStart)
        );

        schedule.setBreakEnd(
                breakEnd == null
                        ? ""
                        : formatTime(breakEnd)
        );

        schedule.setAvailable(
                rs.getBoolean("is_available")
        );

        return schedule;
    }

    private String formatTime(Time time) {

        if (time == null) {
            return "";
        }

        String value
                = time.toLocalTime()
                        .toString();

        return value.length() >= 5
                ? value.substring(0, 5)
                : value;
    }

    private String normalizeTime(
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Time is required."
            );
        }

        value = value.trim();

        if (value.length() == 5) {
            return value + ":00";
        }

        return value;
    }

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}
