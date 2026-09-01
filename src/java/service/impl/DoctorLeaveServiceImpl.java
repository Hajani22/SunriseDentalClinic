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
            DoctorLeave leave,
            String status)
            throws SQLException {

        if (leave == null) {

            throw new IllegalArgumentException(
                    "Leave details are required."
            );
        }

        if (leave.getDoctorId() <= 0) {

            throw new IllegalArgumentException(
                    "Invalid doctor."
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
                    "Leave reason cannot exceed 500 characters."
            );
        }

        if (status == null
                || (!"PENDING".equals(status)
                && !"APPROVED".equals(status))) {

            throw new IllegalArgumentException(
                    "Invalid leave status."
            );
        }

        /*
         * Do not allow duplicate leave requests
         * except cancelled/rejected requests.
         */
        if (dao.isDoctorOnLeave(
                leave.getDoctorId(),
                leave.getLeaveDate())) {

            throw new IllegalArgumentException(
                    "Doctor already has approved leave on this date."
            );
        }

        return dao.addLeave(
                leave,
                status
        );
    }

    @Override
    public boolean approveLeave(
            int id)
            throws SQLException {

        if (id <= 0) {
            return false;
        }

        DoctorLeave leave
                = dao.getById(id);

        if (leave == null) {
            return false;
        }

        if (!"PENDING".equalsIgnoreCase(
                leave.getStatus())) {

            return false;
        }

        return dao.updateStatus(
                id,
                "APPROVED"
        );
    }

    @Override
    public boolean rejectLeave(
            int id)
            throws SQLException {

        if (id <= 0) {
            return false;
        }

        DoctorLeave leave
                = dao.getById(id);

        if (leave == null) {
            return false;
        }

        if (!"PENDING".equalsIgnoreCase(
                leave.getStatus())) {

            return false;
        }

        return dao.updateStatus(
                id,
                "REJECTED"
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
