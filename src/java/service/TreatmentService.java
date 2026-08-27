package service;

import model.Treatment;

import java.sql.SQLException;
import java.util.List;

public interface TreatmentService {

    List<Treatment> getAll()
            throws SQLException;

    List<Treatment> getActive()
            throws SQLException;

    Treatment getById(int id)
            throws SQLException;

    boolean add(Treatment treatment)
            throws SQLException;

    boolean update(Treatment treatment)
            throws SQLException;

    boolean setActive(
            int id,
            boolean active)
            throws SQLException;
}
