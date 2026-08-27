package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import service.ReportService;
import service.impl.ReportServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/AdminReportsServlet")
public class AdminReportsServlet
        extends HttpServlet {

    private ReportService reportService;

    @Override
    public void init()
            throws ServletException {

        reportService
                = new ReportServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        /*
         * =====================================================
         * SESSION CHECK
         * =====================================================
         */
        HttpSession session
                = request.getSession(false);

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
         * ADMIN ROLE CHECK
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
         * LOAD REPORTS
         * =====================================================
         */
        try {

            Map<String, Object> reportData
                    = reportService
                            .getDashboardReport();


            /*
             * Put each report into request scope.
             */
            request.setAttribute(
                    "appointmentSummary",
                    reportData.get(
                            "appointmentSummary"
                    )
            );

            request.setAttribute(
                    "revenueSummary",
                    reportData.get(
                            "revenueSummary"
                    )
            );

            request.setAttribute(
                    "treatmentSummary",
                    reportData.get(
                            "treatmentSummary"
                    )
            );

            request.setAttribute(
                    "monthlyRevenue",
                    reportData.get(
                            "monthlyRevenue"
                    )
            );

            request.setAttribute(
                    "treatmentPerformance",
                    reportData.get(
                            "treatmentPerformance"
                    )
            );

            request.setAttribute(
                    "doctorAppointments",
                    reportData.get(
                            "doctorAppointments"
                    )
            );


            /*
             * =================================================
             * FORWARD
             * =================================================
             */
            request.getRequestDispatcher(
                    "/admin-reports.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Unable to generate admin reports.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-dashboard.jsp?error=reports"
            );
        }
    }
}
