package service.billing;

/**
 * Factory Pattern. Creates the appropriate billing calculation strategy.
 */
public final class BillingStrategyFactory {

    private BillingStrategyFactory() {
    }

    public static BillingCalculationStrategy
            getStrategy(String type) {

        String normalized
                = type == null
                        ? "STANDARD"
                        : type.trim().toUpperCase();

        switch (normalized) {
            case "STANDARD":
            default:
                return new StandardDentalBillingStrategy();
        }
    }
}
