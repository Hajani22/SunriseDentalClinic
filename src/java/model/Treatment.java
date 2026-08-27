package model;

import java.math.BigDecimal;

public class Treatment {

    private int id;

    private String treatmentName;

    private BigDecimal treatmentPrice;

    private BigDecimal consultationFee;

    private boolean active;


    public Treatment() {
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getTreatmentName() {
        return treatmentName;
    }

    public void setTreatmentName(
            String treatmentName) {

        this.treatmentName =
                treatmentName;
    }


    public BigDecimal getTreatmentPrice() {
        return treatmentPrice;
    }

    public void setTreatmentPrice(
            BigDecimal treatmentPrice) {

        this.treatmentPrice =
                treatmentPrice;
    }


    public BigDecimal getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(
            BigDecimal consultationFee) {

        this.consultationFee =
                consultationFee;
    }


    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}