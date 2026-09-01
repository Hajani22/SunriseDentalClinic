package dao;

import model.DoctorLeave;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public interface DoctorLeaveDAO {

    List<DoctorLeave> getAllLeaves()
            throws SQLException;

    List<DoctorLeave> getLeavesByDoctor(
            int doctorId)
            throws SQLException;

    DoctorLeave getById(
            int id)
            throws SQLException;

    boolean addLeave(
            DoctorLeave leave,
            String status)
            throws SQLException;

    boolean updateStatus(
            int id,
            String status)
            throws SQLException;

    boolean cancelLeave(
            int id)
            throws SQLException;

    boolean isDoctorOnLeave(
            int doctorId,
            Date leaveDate)
            throws SQLException;
}
