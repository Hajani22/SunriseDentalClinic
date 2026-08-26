package service.impl;

import dao.PaymentDAO;
import dao.impl.PaymentDAOImpl;

import model.Payment;

import service.PaymentService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class PaymentServiceImpl
        implements PaymentService {

    private final PaymentDAO dao
            = new PaymentDAOImpl();

    @Override
    public Payment getAppointment(
            String appointmentNo)
            throws SQLException {

        if (appointmentNo == null
                || appointmentNo.trim().isEmpty()) {

            return null;
        }

        return dao.getAppointment(
                appointmentNo.trim()
        );
    }

    @Override
    public BigDecimal getConsultationPaid(
            int appointmentId)
            throws SQLException {

        return dao.getConsultationPaid(
                appointmentId
        );
    }

    @Override
    public BigDecimal getTreatmentPaid(
            int appointmentId)
            throws SQLException {

        return dao.getTreatmentPaid(
                appointmentId
        );
    }

    @Override
    public BigDecimal getTreatmentAmount(
            String treatmentName)
            throws SQLException {

        if (treatmentName == null
                || treatmentName.trim().isEmpty()) {

            return BigDecimal.ZERO;
        }

        return dao.getTreatmentAmount(
                treatmentName.trim()
        );
    }


    /* =========================================================
       CONSULTATION PAYMENT
       ========================================================= */
    @Override
    public boolean payConsultation(
            Payment payment)
            throws SQLException {

        if (payment == null) {
            return false;
        }

        BigDecimal alreadyPaid
                = dao.getConsultationPaid(
                        payment.getAppointmentId()
                );


        /*
         * Consultation fee has already been paid.
         * Do not allow duplicate payment.
         */
        if (alreadyPaid.compareTo(
                BigDecimal.ZERO
        ) > 0) {

            return false;
        }

        payment.setPaymentType(
                "CONSULTATION"
        );

        payment.setPaymentNo(
                generatePaymentNo()
        );


        /*
         * Current consultation fee
         */
        payment.setAmount(
                new BigDecimal("2000.00")
        );

        payment.setPaymentStatus(
                "PAID"
        );

        return dao.createPayment(
                payment
        );
    }


    /* =========================================================
       TREATMENT PAYMENT
       ========================================================= */
    @Override
    public boolean payTreatment(
            Payment payment)
            throws SQLException {

        if (payment == null) {
            return false;
        }


        /*
         * Get total treatment amount
         */
        BigDecimal treatmentAmount
                = dao.getTreatmentAmount(
                        payment.getTreatmentType()
                );

        if (treatmentAmount == null) {

            treatmentAmount
                    = BigDecimal.ZERO;
        }


        /*
         * Get amount already paid
         */
        BigDecimal alreadyPaid
                = dao.getTreatmentPaid(
                        payment.getAppointmentId()
                );

        if (alreadyPaid == null) {

            alreadyPaid
                    = BigDecimal.ZERO;
        }


        /*
         * Calculate remaining amount
         */
        BigDecimal balance
                = treatmentAmount.subtract(
                        alreadyPaid
                );


        /*
         * Nothing left to pay
         */
        if (balance.compareTo(
                BigDecimal.ZERO
        ) <= 0) {

            return false;
        }

        payment.setPaymentType(
                "TREATMENT"
        );

        payment.setPaymentNo(
                generatePaymentNo()
        );


        /*
         * Patient pays only the
         * remaining treatment balance.
         */
        payment.setAmount(
                balance
        );

        payment.setPaymentStatus(
                "PAID"
        );

        return dao.createPayment(
                payment
        );
    }


    /* =========================================================
       GENERATE PAYMENT NUMBER
       ========================================================= */
    private String generatePaymentNo() {

        return "PAY-"
                + UUID.randomUUID()
                        .toString()
                        .substring(0, 8)
                        .toUpperCase();
    }


    /* =========================================================
       PATIENT PAYMENT HISTORY
       ========================================================= */
    @Override
    public List<Payment> getPatientPayments(
            int patientId)
            throws SQLException {

        return dao.getPatientPayments(
                patientId
        );
    }


    /* =========================================================
       ALL PATIENT PAYMENTS
       USED BY CASHIER DASHBOARD
       ========================================================= */
    @Override
    public List<Payment> getAllPayments()
            throws SQLException {

        return dao.getAllPayments();
    }
}
