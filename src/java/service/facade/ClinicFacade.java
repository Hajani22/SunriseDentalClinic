package service.facade;

import model.Appointment;
import model.Bill;
import model.DoctorOption;

import service.AppointmentService;
import service.BillingService;

import service.impl.AppointmentServiceImpl;
import service.impl.BillingServiceImpl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Facade Design Pattern.
 *
 * Provides one simple entry point for controllers.
 */
public class ClinicFacade {

    private final AppointmentService appointmentService;
    private final BillingService billingService;

    public ClinicFacade() {

        this(
                new AppointmentServiceImpl(),
                new BillingServiceImpl()
        );
    }

    public ClinicFacade(
            AppointmentService appointmentService,
            BillingService billingService) {

        this.appointmentService
                = appointmentService;

        this.billingService
                = billingService;
    }

    public List<DoctorOption> getDoctors()
            throws SQLException {

        return appointmentService.getDoctors();
    }
    public boolean bookAppointment(
            Appointment appointment)
            throws SQLException {

        return appointmentService.bookAppointment(
                appointment
        );
    }
    public Bill findAppointmentForBilling(
            String appointmentNo)
            throws SQLException {

        return billingService.findAppointmentForBilling(
                appointmentNo
        );
    }

    public Bill prepareBill(
            String appointmentNo,
            BigDecimal discount)
            throws SQLException {

        return billingService.prepareBill(
                appointmentNo,
                discount
        );
    }

    public boolean createBill(
            Bill bill)
            throws SQLException {

        return billingService.createBill(bill);
    }

    public Bill getBillById(int id)
            throws SQLException {

        return billingService.getBillById(id);
    }

    public List<Bill> getRecentBills(int limit)
            throws SQLException {

        return billingService.getRecentBills(limit);
    }
}
