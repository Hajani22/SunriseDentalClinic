package dao.impl;

import dao.AppointmentDAO;
import model.Appointment;
import model.DoctorOption;
import util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;

import java.util.ArrayList;
import java.util.List;

public class AppointmentDAOImpl
        implements AppointmentDAO {

    @Override
    public List<DoctorOption> getDoctors()
            throws SQLException {

        List<DoctorOption> doctors
                = new ArrayList<>();

        String sql
                = "SELECT id, "
                + "CONCAT(first_name,' ',last_name) AS doctor_name, "
                + "COALESCE(specialization,'') AS specialization "
                + "FROM doctors "
                + "ORDER BY first_name,last_name";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql); ResultSet rs
                = ps.executeQuery()) {

            while (rs.next()) {

                DoctorOption doctor
                        = new DoctorOption(
                                rs.getInt("id"),
                                rs.getString("doctor_name"),
                                rs.getString("specialization")
                        );

                doctors.add(doctor);
            }
        }

        return doctors;
    }

    @Override
    public boolean isSlotBooked(
            int doctorId,
            String date,
            String time)
            throws SQLException {

        String sql
                = "SELECT COUNT(*) "
                + "FROM appointments "
                + "WHERE doctor_id=? "
                + "AND appointment_date=? "
                + "AND appointment_time=? "
                + "AND status IN "
                + "('PENDING_DOCTOR',"
                + "'PENDING_ADMIN',"
                + "'CONFIRMED')";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            ps.setDate(
                    2,
                    Date.valueOf(date)
            );

            ps.setTime(
                    3,
                    Time.valueOf(time + ":00")
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
    public boolean createAppointment(
            Appointment appointment)
            throws SQLException {

        String sql
                = "INSERT INTO appointments "
                + "(appointment_no,"
                + "patient_id,"
                + "doctor_id,"
                + "patient_name,"
                + "patient_phone,"
                + "patient_address,"
                + "treatment_type,"
                + "appointment_date,"
                + "appointment_time,"
                + "status) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?)";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )) {

            ps.setString(
                    1,
                    appointment.getAppointmentNo()
            );

            ps.setInt(
                    2,
                    appointment.getPatientId()
            );

            ps.setInt(
                    3,
                    appointment.getDoctorId()
            );

            ps.setString(
                    4,
                    appointment.getPatientName()
            );

            ps.setString(
                    5,
                    appointment.getPatientPhone()
            );

            ps.setString(
                    6,
                    appointment.getPatientAddress()
            );

            ps.setString(
                    7,
                    appointment.getTreatmentType()
            );

            ps.setDate(
                    8,
                    Date.valueOf(
                            appointment.getAppointmentDate()
                    )
            );

            ps.setTime(
                    9,
                    Time.valueOf(
                            appointment.getAppointmentTime()
                            + ":00"
                    )
            );

            ps.setString(
                    10,
                    "PENDING_DOCTOR"
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
                    appointment.setId(
                            keys.getInt(1)
                    );
                }
            }

            return true;
        }
    }

    private String selectSQL() {

        return "SELECT a.*, "
                + "CONCAT("
                + "d.first_name,' ',d.last_name"
                + ") AS doctor_name, "
                + "COALESCE(d.specialization,'') "
                + "AS specialization "
                + "FROM appointments a "
                + "LEFT JOIN doctors d "
                + "ON a.doctor_id=d.id ";
    }

    @Override
    public List<Appointment> getPatientAppointments(
            int patientId)
            throws SQLException {

        return getList(
                selectSQL()
                + "WHERE a.patient_id=? "
                + "ORDER BY a.appointment_date DESC,"
                + "a.appointment_time DESC",
                patientId
        );
    }

    @Override
    public List<Appointment> getDoctorAppointments(
            int doctorId)
            throws SQLException {

        return getList(
                selectSQL()
                + "WHERE a.doctor_id=? "
                + "ORDER BY a.appointment_date ASC,"
                + "a.appointment_time ASC",
                doctorId
        );
    }

    @Override
    public List<Appointment> getAdminAppointments()
            throws SQLException {

        return getList(
                selectSQL()
                + "WHERE a.status='PENDING_ADMIN' "
                + "ORDER BY a.appointment_date ASC,"
                + "a.appointment_time ASC"
        );
    }

    @Override
    public Appointment getById(
            int id)
            throws SQLException {

        List<Appointment> list
                = getList(
                        selectSQL()
                        + "WHERE a.id=?",
                        id
                );

        return list.isEmpty()
                ? null
                : list.get(0);
    }

    private List<Appointment> getList(
            String sql,
            Object... values)
            throws SQLException {

        List<Appointment> list
                = new ArrayList<>();

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            for (int i = 0;
                    i < values.length;
                    i++) {

                ps.setObject(
                        i + 1,
                        values[i]
                );
            }

            try (
                    ResultSet rs
                    = ps.executeQuery()) {

                while (rs.next()) {

                    Appointment a
                            = new Appointment();

                    a.setId(
                            rs.getInt("id")
                    );

                    a.setAppointmentNo(
                            rs.getString(
                                    "appointment_no"
                            )
                    );

                    a.setPatientId(
                            rs.getInt("patient_id")
                    );

                    a.setDoctorId(
                            rs.getInt("doctor_id")
                    );

                    a.setPatientName(
                            rs.getString(
                                    "patient_name"
                            )
                    );

                    a.setPatientPhone(
                            rs.getString(
                                    "patient_phone"
                            )
                    );

                    a.setPatientAddress(
                            rs.getString(
                                    "patient_address"
                            )
                    );

                    a.setDoctorName(
                            rs.getString(
                                    "doctor_name"
                            )
                    );

                    a.setSpecialization(
                            rs.getString(
                                    "specialization"
                            )
                    );

                    a.setTreatmentType(
                            rs.getString(
                                    "treatment_type"
                            )
                    );

                    a.setAppointmentDate(
                            rs.getString(
                                    "appointment_date"
                            )
                    );

                    a.setAppointmentTime(
                            rs.getString(
                                    "appointment_time"
                            )
                    );

                    a.setStatus(
                            rs.getString(
                                    "status"
                            )
                    );

                    a.setDoctorNote(
                            rs.getString(
                                    "doctor_note"
                            )
                    );

                    a.setAdminNote(
                            rs.getString(
                                    "admin_note"
                            )
                    );

                    a.setCreatedAt(
                            rs.getString(
                                    "created_at"
                            )
                    );

                    list.add(a);
                }
            }
        }

        return list;
    }

    @Override
    public boolean doctorDecision(
            int appointmentId,
            int doctorId,
            boolean approve,
            String note)
            throws SQLException {

        String status
                = approve
                        ? "PENDING_ADMIN"
                        : "REJECTED_BY_DOCTOR";

        String sql
                = "UPDATE appointments "
                + "SET status=?, doctor_note=? "
                + "WHERE id=? "
                + "AND doctor_id=? "
                + "AND status='PENDING_DOCTOR'";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, appointmentId);
            ps.setInt(4, doctorId);

            return ps.executeUpdate() == 1;
        }
    }

    @Override
    public boolean adminDecision(
            int appointmentId,
            boolean approve,
            String note)
            throws SQLException {

        String status
                = approve
                        ? "CONFIRMED"
                        : "REJECTED_BY_ADMIN";

        String sql
                = "UPDATE appointments "
                + "SET status=?, admin_note=? "
                + "WHERE id=? "
                + "AND status='PENDING_ADMIN'";

        try (
                Connection con
                = DBConnection.getConnection(); PreparedStatement ps
                = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, note);
            ps.setInt(3, appointmentId);

            return ps.executeUpdate() == 1;
        }
    }
}
