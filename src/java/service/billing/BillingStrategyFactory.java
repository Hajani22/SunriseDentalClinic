package service.billing;

/**
 * Factory Design Pattern.
 *
 * Creates the correct billing calculation strategy.
 */
public final class BillingStrategyFactory {

    private BillingStrategyFactory() {
    }

    public static BillingCalculationStrategy getStrategy(
            String type) {

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
