package service.impl;

import dao.MedicalHistoryDAO;
import dao.impl.MedicalHistoryDAOImpl;

import model.MedicalHistory;

import service.MedicalHistoryService;

import java.sql.SQLException;
import java.util.List;

public class MedicalHistoryServiceImpl
        implements MedicalHistoryService {

    private final MedicalHistoryDAO dao
            = new MedicalHistoryDAOImpl();

    @Override
    public List<MedicalHistory> getPatientHistory(
            int patientId)
            throws SQLException {

        if (patientId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid patient ID."
            );

        }

        return dao.getByPatientId(
                patientId
        );
    }

    @Override
    public List<MedicalHistory> getAppointmentHistory(
            int appointmentId)
            throws SQLException {

        if (appointmentId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid appointment ID."
            );

        }

        return dao.getByAppointmentId(
                appointmentId
        );
    }

    @Override
    public MedicalHistory getById(
            int id)
            throws SQLException {

        if (id <= 0) {

            throw new IllegalArgumentException(
                    "Invalid history ID."
            );

        }

        return dao.getById(
                id
        );
    }

    @Override
    public boolean addHistory(
            MedicalHistory history)
            throws SQLException {

        validate(history);

        return dao.add(
                history
        );
    }

    @Override
    public boolean updateHistory(
            MedicalHistory history)
            throws SQLException {

        if (history == null
                || history.getId() <= 0) {

            throw new IllegalArgumentException(
                    "Invalid medical history."
            );

        }

        validate(history);

        return dao.update(
                history
        );
    }

    private void validate(
            MedicalHistory history) {

        if (history == null) {

            throw new IllegalArgumentException(
                    "Medical history is required."
            );

        }

        if (history.getPatientId() <= 0) {

            throw new IllegalArgumentException(
                    "Patient is required."
            );

        }

        if (history.getDoctorId() <= 0) {

            throw new IllegalArgumentException(
                    "Doctor is required."
            );

        }

        if (history.getVisitDate() == null) {

            throw new IllegalArgumentException(
                    "Visit date is required."
            );

        }

        boolean noClinicalInformation
                = empty(history.getSymptoms())
                && empty(history.getDiagnosis())
                && empty(history.getTreatment())
                && empty(history.getNotes());

        if (noClinicalInformation) {

            throw new IllegalArgumentException(
                    "At least one clinical field is required."
            );

        }
    }

    private boolean empty(
            String value) {

        return value == null
                || value.trim().isEmpty();
    }
}
