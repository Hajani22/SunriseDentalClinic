package service.treatment;

import model.Treatment;

import java.math.BigDecimal;

public class StandardTreatmentPricingStrategy
        implements TreatmentPricingStrategy {

    @Override
    public BigDecimal calculateTotal(
            Treatment treatment) {

        if (treatment == null) {

            return BigDecimal.ZERO;
        }

        BigDecimal treatmentPrice
                = treatment.getTreatmentPrice();

        BigDecimal consultationFee
                = treatment.getConsultationFee();

        if (treatmentPrice == null) {

            treatmentPrice
                    = BigDecimal.ZERO;
        }

        if (consultationFee == null) {

            consultationFee
                    = BigDecimal.ZERO;
        }

        return treatmentPrice.add(
                consultationFee
        );
    }
}
