package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.PatientFeedbackService;
import service.impl.PatientFeedbackServiceImpl;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AdminFeedbackServlet")
public class AdminFeedbackServlet
        extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientFeedbackService feedbackService;

    @Override
    public void init()
            throws ServletException {

        feedbackService
                = new PatientFeedbackServiceImpl();
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
         * SESSION SECURITY
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
         * ADMIN ROLE SECURITY
         * =====================================================
         */
        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"admin".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }


        /*
         * =====================================================
         * LOAD ALL FEEDBACK
         * =====================================================
         */
        try {

            request.setAttribute(
                    "feedbackList",
                    feedbackService.getAllFeedback()
            );

            request.getRequestDispatcher(
                    "/admin-feedback.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error loading administrator feedback.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-dashboard.jsp?error=database"
            );
        }
    }
}
