package service;

import model.Payment;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface PaymentService {

    Payment getAppointment(
            String appointmentNo)
            throws SQLException;

    BigDecimal getConsultationPaid(
            int appointmentId)
            throws SQLException;

    BigDecimal getTreatmentPaid(
            int appointmentId)
            throws SQLException;

    BigDecimal getTreatmentAmount(
            String treatmentName)
            throws SQLException;

    boolean payConsultation(
            Payment payment)
            throws SQLException;

    boolean payTreatment(
            Payment payment)
            throws SQLException;

    List<Payment> getPatientPayments(
            int patientId)
            throws SQLException;

    List<Payment> getAllPayments()
            throws SQLException;
}
