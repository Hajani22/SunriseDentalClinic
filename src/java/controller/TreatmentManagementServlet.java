package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Treatment;

import service.TreatmentService;
import service.impl.TreatmentServiceImpl;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/TreatmentManagementServlet")
public class TreatmentManagementServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TreatmentService treatmentService;

    @Override
    public void init()
            throws ServletException {

        treatmentService
                = new TreatmentServiceImpl();
    }


    /* =========================================================
       GET
       ========================================================= */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            List<Treatment> treatments
                    = treatmentService.getAll();

            request.setAttribute(
                    "treatments",
                    treatments
            );

            request.getRequestDispatcher(
                    "/treatment-management.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Unable to load treatments.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-dashboard.jsp?error=database"
            );
        }
    }


    /* =========================================================
       POST
       ========================================================= */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(
                "UTF-8"
        );

        if (!isAdmin(request)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        String action
                = clean(
                        request.getParameter("action")
                );

        if (action == null) {

            redirectError(
                    request,
                    response,
                    "Invalid action."
            );

            return;
        }

        try {

            switch (action.toLowerCase()) {

                case "add":

                    addTreatment(
                            request,
                            response
                    );

                    break;

                case "update":

                    updateTreatment(
                            request,
                            response
                    );

                    break;

                case "toggle":

                    toggleTreatment(
                            request,
                            response
                    );

                    break;

                default:

                    redirectError(
                            request,
                            response,
                            "Invalid treatment action."
                    );
            }

        } catch (IllegalArgumentException e) {

            redirectError(
                    request,
                    response,
                    e.getMessage()
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Treatment database operation failed.",
                    e
            );

            redirectDatabaseError(
                    request,
                    response
            );
        }
    }


    /* =========================================================
       ADD TREATMENT
       ========================================================= */
    private void addTreatment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String treatmentName
                = clean(
                        request.getParameter(
                                "treatmentName"
                        )
                );

        BigDecimal treatmentPrice
                = parseAmount(
                        request.getParameter(
                                "treatmentPrice"
                        ),
                        "Treatment price"
                );

        BigDecimal consultationFee
                = parseAmount(
                        request.getParameter(
                                "consultationFee"
                        ),
                        "Consultation fee"
                );

        validateName(
                treatmentName
        );

        Treatment treatment
                = new Treatment();

        treatment.setTreatmentName(
                treatmentName
        );

        treatment.setTreatmentPrice(
                treatmentPrice
        );

        treatment.setConsultationFee(
                consultationFee
        );

        treatment.setActive(
                true
        );

        treatmentService.add(
                treatment
        );

        response.sendRedirect(
                request.getContextPath()
                + "/TreatmentManagementServlet?success=added"
        );
    }


    /* =========================================================
       UPDATE TREATMENT
       ========================================================= */
    private void updateTreatment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        int id
                = parseId(
                        request.getParameter("id")
                );

        String treatmentName
                = clean(
                        request.getParameter(
                                "treatmentName"
                        )
                );

        BigDecimal treatmentPrice
                = parseAmount(
                        request.getParameter(
                                "treatmentPrice"
                        ),
                        "Treatment price"
                );

        BigDecimal consultationFee
                = parseAmount(
                        request.getParameter(
                                "consultationFee"
                        ),
                        "Consultation fee"
                );

        validateName(
                treatmentName
        );

        Treatment existing
                = treatmentService.getById(
                        id
                );

        if (existing == null) {

            throw new IllegalArgumentException(
                    "Treatment was not found."
            );
        }

        existing.setTreatmentName(
                treatmentName
        );

        existing.setTreatmentPrice(
                treatmentPrice
        );

        existing.setConsultationFee(
                consultationFee
        );

        treatmentService.update(
                existing
        );

        response.sendRedirect(
                request.getContextPath()
                + "/TreatmentManagementServlet?success=updated"
        );
    }


    /* =========================================================
       ACTIVATE / DEACTIVATE
       ========================================================= */
    private void toggleTreatment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        int id
                = parseId(
                        request.getParameter("id")
                );

        String activeValue
                = clean(
                        request.getParameter("active")
                );

        if (activeValue == null) {

            throw new IllegalArgumentException(
                    "Treatment status is required."
            );
        }

        boolean active;

        if ("true".equalsIgnoreCase(activeValue)
                || "1".equals(activeValue)) {

            active = true;

        } else if ("false".equalsIgnoreCase(activeValue)
                || "0".equals(activeValue)) {

            active = false;

        } else {

            throw new IllegalArgumentException(
                    "Invalid treatment status."
            );
        }

        Treatment existing
                = treatmentService.getById(
                        id
                );

        if (existing == null) {

            throw new IllegalArgumentException(
                    "Treatment was not found."
            );
        }

        treatmentService.setActive(
                id,
                active
        );

        if (active) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/TreatmentManagementServlet?success=activated"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/TreatmentManagementServlet?success=deactivated"
            );
        }
    }


    /* =========================================================
       VALIDATION
       ========================================================= */
    private void validateName(
            String name) {

        if (name == null
                || name.isEmpty()) {

            throw new IllegalArgumentException(
                    "Treatment name is required."
            );
        }

        if (name.length() > 150) {

            throw new IllegalArgumentException(
                    "Treatment name is too long."
            );
        }
    }

    private BigDecimal parseAmount(
            String value,
            String fieldName) {

        value = clean(value);

        if (value == null) {

            throw new IllegalArgumentException(
                    fieldName
                    + " is required."
            );
        }

        try {

            BigDecimal amount
                    = new BigDecimal(value);

            if (amount.compareTo(
                    BigDecimal.ZERO
            ) < 0) {

                throw new IllegalArgumentException(
                        fieldName
                        + " cannot be negative."
                );
            }

            return amount;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid "
                    + fieldName
                    + "."
            );
        }
    }

    private int parseId(
            String value) {

        value = clean(value);

        if (value == null) {

            throw new IllegalArgumentException(
                    "Treatment ID is required."
            );
        }

        try {

            int id
                    = Integer.parseInt(value);

            if (id <= 0) {

                throw new IllegalArgumentException(
                        "Invalid treatment ID."
                );
            }

            return id;

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Invalid treatment ID."
            );
        }
    }


    /* =========================================================
       ADMIN SECURITY
       ========================================================= */
    private boolean isAdmin(
            HttpServletRequest request) {

        HttpSession session
                = request.getSession(false);

        if (session == null) {

            return false;
        }

        if (session.getAttribute("user")
                == null) {

            return false;
        }

        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        return "admin".equalsIgnoreCase(
                role
        );
    }


    /* =========================================================
       HELPERS
       ========================================================= */
    private String clean(
            String value) {

        if (value == null) {

            return null;
        }

        value
                = value.trim();

        return value.isEmpty()
                ? null
                : value;
    }

    private void redirectError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws IOException {

        String encoded;

        if (message == null
                || message.trim().isEmpty()) {

            encoded
                    = "Invalid request.";

        } else {

            encoded
                    = URLEncoder.encode(
                            message,
                            StandardCharsets.UTF_8
                    );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/TreatmentManagementServlet?error="
                + encoded
        );
    }

    private void redirectDatabaseError(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/TreatmentManagementServlet?error=database"
        );
    }
}
