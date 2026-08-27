package service.treatment;

import model.Treatment;

import java.math.BigDecimal;

public interface TreatmentPricingStrategy {

    BigDecimal calculateTotal(
            Treatment treatment
    );
}
