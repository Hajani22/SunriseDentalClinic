package dao;

import model.Bill;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface BillingDAO {

    Bill findConfirmedAppointment(
            String appointmentNo)
            throws SQLException;

    BigDecimal getTreatmentPrice(
            String treatmentName)
            throws SQLException;

    BigDecimal getConsultationFee(
            String treatmentName)
            throws SQLException;

    boolean billExistsForAppointment(
            int appointmentId)
            throws SQLException;

    boolean createBill(
            Bill bill)
            throws SQLException;

    Bill getBillById(
            int id)
            throws SQLException;

    List<Bill> getRecentBills(
            int limit)
            throws SQLException;
}
