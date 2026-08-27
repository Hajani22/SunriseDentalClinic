package service.treatment;

public final class TreatmentStrategyFactory {

    private TreatmentStrategyFactory() {
    }

    public static TreatmentPricingStrategy
            getStrategy(String type) {

        return new StandardTreatmentPricingStrategy();
    }
}
