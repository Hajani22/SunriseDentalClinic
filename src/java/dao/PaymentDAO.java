package dao;

import model.Payment;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface PaymentDAO {

    Payment getAppointment(
            String appointmentNo)
            throws SQLException;

    BigDecimal getTreatmentAmount(
            String treatmentName)
            throws SQLException;

    BigDecimal getConsultationPaid(
            int appointmentId)
            throws SQLException;

    BigDecimal getTreatmentPaid(
            int appointmentId)
            throws SQLException;

    boolean createPayment(
            Payment payment)
            throws SQLException;

    List<Payment> getPatientPayments(
            int patientId)
            throws SQLException;

    List<Payment> getAllPayments()
            throws SQLException;
}
