package service.impl;

import dao.BillingDAO;
import dao.impl.BillingDAOImpl;

import model.Bill;

import service.BillingService;
import service.billing.BillingCalculationStrategy;
import service.billing.BillingStrategyFactory;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class BillingServiceImpl
        implements BillingService {

    private final BillingDAO dao
            = new BillingDAOImpl();

    private final BillingCalculationStrategy calculationStrategy
            = BillingStrategyFactory.getStrategy("STANDARD");

    @Override
    public Bill findAppointmentForBilling(
            String appointmentNo)
            throws SQLException {

        if (appointmentNo == null
                || appointmentNo.trim().isEmpty()) {

            return null;
        }

        return dao.findConfirmedAppointment(
                appointmentNo.trim()
        );
    }

    @Override
    public Bill prepareBill(
            String appointmentNo,
            BigDecimal discount)
            throws SQLException {

        Bill bill
                = findAppointmentForBilling(
                        appointmentNo
                );

        if (bill == null) {
            return null;
        }

        /*
         * Do not prepare another bill if one
         * already exists for this appointment.
         */
        if (dao.billExistsForAppointment(
                bill.getAppointmentId())) {

            return null;
        }

        BigDecimal treatmentAmount
                = dao.getTreatmentPrice(
                        bill.getTreatmentType()
                );

        BigDecimal consultationFee
                = dao.getConsultationFee(
                        bill.getTreatmentType()
                );

        if (treatmentAmount == null) {
            treatmentAmount = BigDecimal.ZERO;
        }

        if (consultationFee == null) {
            consultationFee = BigDecimal.ZERO;
        }

        if (discount == null) {
            discount = BigDecimal.ZERO;
        }

        if (discount.compareTo(
                BigDecimal.ZERO
        ) < 0) {

            discount = BigDecimal.ZERO;
        }

        BigDecimal total
                = calculationStrategy.calculateTotal(
                        treatmentAmount,
                        consultationFee,
                        discount
                );

        bill.setTreatmentAmount(
                treatmentAmount
        );

        bill.setConsultationFee(
                consultationFee
        );

        bill.setDiscount(
                discount
        );

        bill.setTotalAmount(
                total
        );

        bill.setPaidAmount(
                BigDecimal.ZERO
        );

        return bill;
    }

    @Override
    public boolean createBill(
            Bill bill)
            throws SQLException {

        if (bill == null) {
            return false;
        }

        if (bill.getAppointmentId() <= 0) {
            return false;
        }

        if (bill.getCashierId() <= 0) {
            return false;
        }

        if (bill.getTotalAmount() == null) {
            return false;
        }

        if (bill.getPaymentMethod() == null
                || bill.getPaymentMethod()
                        .trim()
                        .isEmpty()) {

            return false;
        }

        if (dao.billExistsForAppointment(
                bill.getAppointmentId())) {

            return false;
        }

        bill.setBillNo(
                "BILL-"
                + UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase()
        );

        bill.setPaymentStatus(
                "PAID"
        );

        return dao.createBill(
                bill
        );
    }

    @Override
    public Bill getBillById(
            int id)
            throws SQLException {

        return dao.getBillById(id);
    }

    @Override
    public Bill getBillByAppointmentId(
            int appointmentId)
            throws SQLException {

        if (appointmentId <= 0) {
            return null;
        }

        return dao.getBillByAppointmentId(
                appointmentId
        );
    }

    @Override
    public List<Bill> getRecentBills(
            int limit)
            throws SQLException {

        if (limit <= 0) {
            limit = 10;
        }

        return dao.getRecentBills(
                limit
        );
    }
}
