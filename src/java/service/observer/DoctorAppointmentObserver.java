package service.observer;

import model.Appointment;
import service.NotificationService;

import java.sql.SQLException;

public class DoctorAppointmentObserver
        implements AppointmentObserver {

    private final NotificationService notificationService;

    public DoctorAppointmentObserver(
            NotificationService notificationService) {

        this.notificationService
                = notificationService;
    }

    @Override
    public void update(
            AppointmentEvent event)
            throws SQLException {

        if (event == null
                || event.getType()
                != AppointmentEvent.Type.CREATED) {

            return;
        }

        Appointment appointment
                = event.getAppointment();

        if (appointment == null) {
            return;
        }

        String message
                = "New appointment request from "
                + appointment.getPatientName()
                + " on "
                + appointment.getAppointmentDate()
                + " at "
                + appointment.getAppointmentTime()
                + ".";

        notificationService.create(
                appointment.getDoctorId(),
                "doctor",
                "New Appointment Request",
                message,
                appointment.getId()
        );
    }
}
