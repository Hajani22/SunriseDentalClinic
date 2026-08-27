package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.DoctorLeave;
import model.DoctorOption;

import service.AppointmentService;
import service.DoctorLeaveService;

import service.impl.AppointmentServiceImpl;
import service.impl.DoctorLeaveServiceImpl;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

import java.util.List;

@WebServlet("/DoctorLeaveServlet")
public class DoctorLeaveServlet
        extends HttpServlet {

    private DoctorLeaveService leaveService;

    private AppointmentService appointmentService;

    @Override
    public void init()
            throws ServletException {

        leaveService
                = new DoctorLeaveServiceImpl();

        appointmentService
                = new AppointmentServiceImpl();
    }

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

            List<DoctorOption> doctors
                    = appointmentService
                            .getDoctors();

            List<DoctorLeave> leaves
                    = leaveService
                            .getAllLeaves();

            request.setAttribute(
                    "doctors",
                    doctors
            );

            request.setAttribute(
                    "leaves",
                    leaves
            );

            request.getRequestDispatcher(
                    "/doctor-leave.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error loading doctor leave data.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-dashboard.jsp?error=database"
            );
        }
    }

    @Override
    protected void doPost(
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

        request.setCharacterEncoding(
                "UTF-8"
        );

        String action
                = request.getParameter("action");

        try {

            if ("add".equalsIgnoreCase(
                    action)) {

                int doctorId
                        = Integer.parseInt(
                                request.getParameter(
                                        "doctorId"
                                )
                        );

                Date leaveDate
                        = Date.valueOf(
                                request.getParameter(
                                        "leaveDate"
                                )
                        );

                String reason
                        = request.getParameter(
                                "reason"
                        );

                if (reason != null) {

                    reason
                            = reason.trim();
                }

                DoctorLeave leave
                        = new DoctorLeave();

                leave.setDoctorId(
                        doctorId
                );

                leave.setLeaveDate(
                        leaveDate
                );

                leave.setReason(
                        reason
                );

                leaveService.addLeave(
                        leave
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorLeaveServlet?success=added"
                );

            } else if ("cancel".equalsIgnoreCase(
                    action)) {

                int id
                        = Integer.parseInt(
                                request.getParameter(
                                        "id"
                                )
                        );

                leaveService.cancelLeave(
                        id
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorLeaveServlet?success=cancelled"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorLeaveServlet?error=action"
                );
            }

        } catch (IllegalArgumentException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorLeaveServlet?error="
                    + java.net.URLEncoder.encode(
                            e.getMessage(),
                            "UTF-8"
                    )
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error updating doctor leave.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorLeaveServlet?error=database"
            );
        }
    }

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
}
