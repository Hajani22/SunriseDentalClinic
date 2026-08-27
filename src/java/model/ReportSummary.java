package model;

public class ReportSummary {

    private int totalAppointments;
    private int confirmedAppointments;
    private int pendingAppointments;
    private int rejectedAppointments;
    private int cancelledAppointments;

    private int totalPatients;
    private int totalDoctors;

    private int totalTreatments;

    private double totalRevenue;

    public ReportSummary() {
    }

    public int getTotalAppointments() {
        return totalAppointments;
    }

    public void setTotalAppointments(int totalAppointments) {
        this.totalAppointments = totalAppointments;
    }

    public int getConfirmedAppointments() {
        return confirmedAppointments;
    }

    public void setConfirmedAppointments(int confirmedAppointments) {
        this.confirmedAppointments = confirmedAppointments;
    }

    public int getPendingAppointments() {
        return pendingAppointments;
    }

    public void setPendingAppointments(int pendingAppointments) {
        this.pendingAppointments = pendingAppointments;
    }

    public int getRejectedAppointments() {
        return rejectedAppointments;
    }

    public void setRejectedAppointments(int rejectedAppointments) {
        this.rejectedAppointments = rejectedAppointments;
    }

    public int getCancelledAppointments() {
        return cancelledAppointments;
    }

    public void setCancelledAppointments(int cancelledAppointments) {
        this.cancelledAppointments = cancelledAppointments;
    }

    public int getTotalPatients() {
        return totalPatients;
    }

    public void setTotalPatients(int totalPatients) {
        this.totalPatients = totalPatients;
    }

    public int getTotalDoctors() {
        return totalDoctors;
    }

    public void setTotalDoctors(int totalDoctors) {
        this.totalDoctors = totalDoctors;
    }

    public int getTotalTreatments() {
        return totalTreatments;
    }

    public void setTotalTreatments(int totalTreatments) {
        this.totalTreatments = totalTreatments;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
