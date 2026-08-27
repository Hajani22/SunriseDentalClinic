package service.observer;

import model.Appointment;

public class AppointmentEvent {

    public enum Type {
        CREATED
    }

    private final Type type;
    private final Appointment appointment;

    public AppointmentEvent(
            Type type,
            Appointment appointment) {

        this.type = type;
        this.appointment = appointment;
    }

    public Type getType() {
        return type;
    }

    public Appointment getAppointment() {
        return appointment;
    }
}
