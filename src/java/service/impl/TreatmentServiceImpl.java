package service.impl;

import dao.TreatmentDAO;
import dao.impl.TreatmentDAOImpl;

import model.Treatment;

import service.TreatmentService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class TreatmentServiceImpl
        implements TreatmentService {

    private final TreatmentDAO treatmentDAO;

    public TreatmentServiceImpl() {

        this.treatmentDAO
                = new TreatmentDAOImpl();
    }


    /* =========================================================
       GET ALL TREATMENTS
       ========================================================= */
    @Override
    public List<Treatment> getAll()
            throws SQLException {

        return treatmentDAO.getAll();
    }


    /* =========================================================
       GET ACTIVE TREATMENTS
       ========================================================= */
    @Override
    public List<Treatment> getActive()
            throws SQLException {

        return treatmentDAO.getActive();
    }


    /* =========================================================
       GET TREATMENT BY ID
       ========================================================= */
    @Override
    public Treatment getById(
            int id)
            throws SQLException {

        if (id <= 0) {

            throw new IllegalArgumentException(
                    "Invalid treatment ID."
            );
        }

        return treatmentDAO.getById(id);
    }


    /* =========================================================
       ADD TREATMENT
       ========================================================= */
    @Override
    public boolean add(
            Treatment treatment)
            throws SQLException {

        validateTreatment(
                treatment
        );

        return treatmentDAO.add(
                treatment
        );
    }


    /* =========================================================
       UPDATE TREATMENT
       ========================================================= */
    @Override
    public boolean update(
            Treatment treatment)
            throws SQLException {

        if (treatment == null) {

            throw new IllegalArgumentException(
                    "Treatment details are required."
            );
        }

        if (treatment.getId() <= 0) {

            throw new IllegalArgumentException(
                    "Invalid treatment ID."
            );
        }

        validateTreatment(
                treatment
        );

        return treatmentDAO.update(
                treatment
        );
    }


    /* =========================================================
       ACTIVATE / DEACTIVATE
       ========================================================= */
    @Override
    public boolean setActive(
            int id,
            boolean active)
            throws SQLException {

        if (id <= 0) {

            throw new IllegalArgumentException(
                    "Invalid treatment ID."
            );
        }

        Treatment treatment
                = treatmentDAO.getById(id);

        if (treatment == null) {

            throw new IllegalArgumentException(
                    "Treatment not found."
            );
        }

        return treatmentDAO.setActive(
                id,
                active
        );
    }


    /* =========================================================
       VALIDATION
       ========================================================= */
    private void validateTreatment(
            Treatment treatment) {

        if (treatment == null) {

            throw new IllegalArgumentException(
                    "Treatment details are required."
            );
        }

        String name
                = treatment.getTreatmentName();

        if (name == null
                || name.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Treatment name is required."
            );
        }

        name
                = name.trim();

        if (name.length() > 150) {

            throw new IllegalArgumentException(
                    "Treatment name cannot exceed 150 characters."
            );
        }

        BigDecimal treatmentPrice
                = treatment.getTreatmentPrice();

        if (treatmentPrice == null) {

            throw new IllegalArgumentException(
                    "Treatment price is required."
            );
        }

        if (treatmentPrice.compareTo(
                BigDecimal.ZERO
        ) < 0) {

            throw new IllegalArgumentException(
                    "Treatment price cannot be negative."
            );
        }

        BigDecimal consultationFee
                = treatment.getConsultationFee();

        if (consultationFee == null) {

            throw new IllegalArgumentException(
                    "Consultation fee is required."
            );
        }

        if (consultationFee.compareTo(
                BigDecimal.ZERO
        ) < 0) {

            throw new IllegalArgumentException(
                    "Consultation fee cannot be negative."
            );
        }

        treatment.setTreatmentName(
                name
        );
    }
}
