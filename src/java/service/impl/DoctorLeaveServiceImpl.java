package service.impl;

import dao.DoctorLeaveDAO;
import dao.impl.DoctorLeaveDAOImpl;

import model.DoctorLeave;

import service.DoctorLeaveService;

import java.sql.Date;
import java.sql.SQLException;

import java.time.LocalDate;

import java.util.List;

public class DoctorLeaveServiceImpl
        implements DoctorLeaveService {

    private final DoctorLeaveDAO dao
            = new DoctorLeaveDAOImpl();

    @Override
    public List<DoctorLeave> getAllLeaves()
            throws SQLException {

        return dao.getAllLeaves();
    }

    @Override
    public List<DoctorLeave> getLeavesByDoctor(
            int doctorId)
            throws SQLException {

        if (doctorId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid doctor."
            );
        }

        return dao.getLeavesByDoctor(
                doctorId
        );
    }

    @Override
    public boolean addLeave(
            DoctorLeave leave)
            throws SQLException {

        if (leave == null) {

            throw new IllegalArgumentException(
                    "Leave details are required."
            );
        }

        if (leave.getDoctorId() <= 0) {

            throw new IllegalArgumentException(
                    "Please select a doctor."
            );
        }

        if (leave.getLeaveDate() == null) {

            throw new IllegalArgumentException(
                    "Please select a leave date."
            );
        }

        LocalDate date
                = leave.getLeaveDate()
                        .toLocalDate();

        if (date.isBefore(
                LocalDate.now())) {

            throw new IllegalArgumentException(
                    "Leave date cannot be in the past."
            );
        }

        if (leave.getReason() != null
                && leave.getReason().length() > 500) {

            throw new IllegalArgumentException(
                    "Leave reason is too long."
            );
        }

        if (dao.isDoctorOnLeave(
                leave.getDoctorId(),
                leave.getLeaveDate())) {

            throw new IllegalArgumentException(
                    "Doctor already has leave on this date."
            );
        }

        return dao.addLeave(
                leave
        );
    }

    @Override
    public boolean cancelLeave(
            int id)
            throws SQLException {

        if (id <= 0) {

            return false;
        }

        return dao.cancelLeave(id);
    }

    @Override
    public boolean isDoctorOnLeave(
            int doctorId,
            Date date)
            throws SQLException {

        if (doctorId <= 0
                || date == null) {

            return false;
        }

        return dao.isDoctorOnLeave(
                doctorId,
                date
        );
    }
}
