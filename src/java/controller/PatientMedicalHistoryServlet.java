package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.MedicalHistory;
import service.MedicalHistoryService;
import service.impl.MedicalHistoryServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/PatientMedicalHistoryServlet")
public class PatientMedicalHistoryServlet
        extends HttpServlet {

    private MedicalHistoryService service;

    @Override
    public void init()
            throws ServletException {

        service
                = new MedicalHistoryServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);


        /*
         * =====================================================
         * LOGIN CHECK
         * =====================================================
         */
        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }


        /*
         * =====================================================
         * ROLE CHECK
         * =====================================================
         */
        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }

        try {

            Object userId
                    = session.getAttribute(
                            "userId"
                    );

            if (userId == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=session"
                );

                return;
            }

            int patientId
                    = Integer.parseInt(
                            userId.toString()
                    );

            List<MedicalHistory> history
                    = service.getPatientHistory(
                            patientId
                    );

            request.setAttribute(
                    "medicalHistory",
                    history
            );

            request.getRequestDispatcher(
                    "/PatientMedicalHistory.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute(
                    "errorMessage",
                    "Unable to load medical history."
            );

            request.getRequestDispatcher(
                    "/PatientMedicalHistory.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }
}
