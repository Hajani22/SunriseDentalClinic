package service.billing;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class StandardDentalBillingStrategy
        implements BillingCalculationStrategy {

    @Override
    public BigDecimal calculateTotal(
            BigDecimal treatmentAmount,
            BigDecimal consultationFee,
            BigDecimal discount) {

        if (treatmentAmount == null) {
            treatmentAmount = BigDecimal.ZERO;
        }

        if (consultationFee == null) {
            consultationFee = BigDecimal.ZERO;
        }

        if (discount == null) {
            discount = BigDecimal.ZERO;
        }

        if (discount.compareTo(BigDecimal.ZERO) < 0) {
            discount = BigDecimal.ZERO;
        }

        BigDecimal total
                = treatmentAmount
                        .add(consultationFee)
                        .subtract(discount);

        if (total.compareTo(BigDecimal.ZERO) < 0) {
            total = BigDecimal.ZERO;
        }

        return total.setScale(
                2,
                RoundingMode.HALF_UP
        );
    }
}

