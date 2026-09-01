package service;

import model.Bill;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public interface BillingService {

    Bill findAppointmentForBilling(
            String appointmentNo)
            throws SQLException;

    Bill prepareBill(
            String appointmentNo,
            BigDecimal discount)
            throws SQLException;

    boolean createBill(
            Bill bill)
            throws SQLException;

    Bill getBillById(
            int id)
            throws SQLException;

    Bill getBillByAppointmentId(
            int appointmentId)
            throws SQLException;

    List<Bill> getRecentBills(
            int limit)
            throws SQLException;
}
