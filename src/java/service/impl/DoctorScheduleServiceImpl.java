package service.impl;

import dao.DoctorScheduleDAO;
import dao.impl.DoctorScheduleDAOImpl;

import model.DoctorSchedule;

import service.DoctorScheduleService;

import java.sql.SQLException;
import java.time.LocalTime;
import java.util.List;

public class DoctorScheduleServiceImpl
        implements DoctorScheduleService {

    private final DoctorScheduleDAO dao
            = new DoctorScheduleDAOImpl();

    @Override
    public List<DoctorSchedule> getAllSchedules()
            throws SQLException {

        return dao.getAllSchedules();
    }

    @Override
    public List<DoctorSchedule> getSchedulesByDoctor(
            int doctorId)
            throws SQLException {

        if (doctorId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid doctor."
            );
        }

        return dao.getSchedulesByDoctor(
                doctorId
        );
    }

    @Override
    public DoctorSchedule getSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException {

        return dao.getSchedule(
                doctorId,
                dayOfWeek
        );
    }

    @Override
    public boolean saveSchedule(
            DoctorSchedule schedule)
            throws SQLException {

        validateSchedule(schedule);

        return dao.saveSchedule(
                schedule
        );
    }

    @Override
    public boolean deleteSchedule(
            int doctorId,
            String dayOfWeek)
            throws SQLException {

        return dao.deleteSchedule(
                doctorId,
                dayOfWeek
        );
    }

    @Override
    public boolean isDoctorAvailable(
            int doctorId,
            String date,
            String time)
            throws SQLException {

        if (doctorId <= 0) {
            return false;
        }

        if (date == null
                || date.trim().isEmpty()) {

            return false;
        }

        if (time == null
                || time.trim().isEmpty()) {

            return false;
        }

        return dao.isDoctorAvailable(
                doctorId,
                date,
                time
        );
    }

    private void validateSchedule(
            DoctorSchedule schedule) {

        if (schedule == null) {

            throw new IllegalArgumentException(
                    "Schedule details are required."
            );
        }

        if (schedule.getDoctorId() <= 0) {

            throw new IllegalArgumentException(
                    "Please select a doctor."
            );
        }

        if (isBlank(
                schedule.getDayOfWeek())) {

            throw new IllegalArgumentException(
                    "Please select a day."
            );
        }

        if (isBlank(
                schedule.getStartTime())
                || isBlank(
                        schedule.getEndTime())) {

            throw new IllegalArgumentException(
                    "Start and end times are required."
            );
        }

        LocalTime start
                = LocalTime.parse(
                        schedule.getStartTime()
                );

        LocalTime end
                = LocalTime.parse(
                        schedule.getEndTime()
                );

        if (!end.isAfter(start)) {

            throw new IllegalArgumentException(
                    "End time must be after start time."
            );
        }

        if (!isBlank(
                schedule.getBreakStart())
                || !isBlank(
                        schedule.getBreakEnd())) {

            if (isBlank(
                    schedule.getBreakStart())
                    || isBlank(
                            schedule.getBreakEnd())) {

                throw new IllegalArgumentException(
                        "Both break start and break end are required."
                );
            }

            LocalTime breakStart
                    = LocalTime.parse(
                            schedule.getBreakStart()
                    );

            LocalTime breakEnd
                    = LocalTime.parse(
                            schedule.getBreakEnd()
                    );

            if (!breakEnd.isAfter(
                    breakStart)) {

                throw new IllegalArgumentException(
                        "Break end must be after break start."
                );
            }

            if (breakStart.isBefore(start)
                    || breakEnd.isAfter(end)) {

                throw new IllegalArgumentException(
                        "Break time must be inside working hours."
                );
            }
        }
    }

    private boolean isBlank(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}
