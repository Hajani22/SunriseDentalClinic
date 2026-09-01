package service.billing;

import java.math.BigDecimal;

public interface BillingCalculationStrategy {

    BigDecimal calculateTotal(
            BigDecimal treatmentAmount,
            BigDecimal consultationFee,
            BigDecimal discount
    );
}


