package dao;

import model.DoctorSchedule;

import java.sql.SQLException;
import java.util.List;

public interface DoctorScheduleDAO {

    List<DoctorSchedule> getAllSchedules()
            throws SQLException;

    List<DoctorSchedule> getSchedulesByDoctor(
            int doctorId)
            throws SQLException;

    DoctorSchedule getSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException;

    boolean saveSchedule(
            DoctorSchedule schedule)
            throws SQLException;

    boolean deleteSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException;

    boolean isDoctorAvailable(
            int doctorId,
            String date,
            String time)
            throws SQLException;
}
