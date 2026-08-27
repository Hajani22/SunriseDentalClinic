package service;

import model.DoctorLeave;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public interface DoctorLeaveService {

    List<DoctorLeave> getAllLeaves()
            throws SQLException;

    List<DoctorLeave> getLeavesByDoctor(
            int doctorId)
            throws SQLException;

    boolean addLeave(
            DoctorLeave leave)
            throws SQLException;

    boolean cancelLeave(
            int id)
            throws SQLException;

    boolean isDoctorOnLeave(
            int doctorId,
            Date date)
            throws SQLException;
}
