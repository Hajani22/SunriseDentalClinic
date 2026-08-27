package model;

public class ReportItem {

    private String label;
    private double value;
    private int count;

    public ReportItem() {
    }

    public ReportItem(
            String label,
            double value,
            int count) {

        this.label = label;
        this.value = value;
        this.count = count;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
