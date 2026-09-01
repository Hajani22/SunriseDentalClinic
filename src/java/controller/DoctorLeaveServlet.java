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
import java.net.URLEncoder;
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

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp"
            );

            return;
        }

        String role
                = String.valueOf(
                        session.getAttribute("userRole")
                );

        try {

            /*
             * ============================
             * ADMIN
             * ============================
             */
            if ("admin".equalsIgnoreCase(role)) {

                List<DoctorOption> doctors
                        = appointmentService.getDoctors();

                List<DoctorLeave> leaves
                        = leaveService.getAllLeaves();

                request.setAttribute(
                        "doctors",
                        doctors
                );

                request.setAttribute(
                        "leaves",
                        leaves
                );

                request.setAttribute(
                        "pageRole",
                        "admin"
                );

                request.getRequestDispatcher(
                        "/doctor-leave.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            /*
             * ============================
             * DOCTOR
             * ============================
             */
            if ("doctor".equalsIgnoreCase(role)) {

                Object userId
                        = session.getAttribute("userId");

                if (userId == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/Login.jsp?error=session"
                    );

                    return;
                }

                int doctorId
                        = Integer.parseInt(
                                userId.toString()
                        );

                List<DoctorLeave> leaves
                        = leaveService.getLeavesByDoctor(
                                doctorId
                        );

                request.setAttribute(
                        "leaves",
                        leaves
                );

                request.setAttribute(
                        "pageRole",
                        "doctor"
                );

                request.getRequestDispatcher(
                        "/doctor-leave.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }


            /*
             * ============================
             * OTHER USERS
             * ============================
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

        } catch (SQLException
                | NumberFormatException e) {

            getServletContext().log(
                    "Error loading doctor leave data.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=database"
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp"
            );

            return;
        }

        request.setCharacterEncoding(
                "UTF-8"
        );

        String role
                = String.valueOf(
                        session.getAttribute("userRole")
                );

        String action
                = request.getParameter("action");

        try {

            /*
             * =====================================
             * DOCTOR SUBMITS LEAVE
             * =====================================
             */
            if ("add".equalsIgnoreCase(action)) {

                if (!"doctor".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/Login.jsp?error=access"
                    );

                    return;
                }

                Object userId
                        = session.getAttribute("userId");

                if (userId == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/Login.jsp?error=session"
                    );

                    return;
                }

                int doctorId
                        = Integer.parseInt(
                                userId.toString()
                        );

                String leaveDateValue
                        = request.getParameter(
                                "leaveDate"
                        );

                if (leaveDateValue == null
                        || leaveDateValue.trim().isEmpty()) {

                    throw new IllegalArgumentException(
                            "Please select a leave date."
                    );
                }

                Date leaveDate
                        = Date.valueOf(
                                leaveDateValue
                        );

                String reason
                        = request.getParameter(
                                "reason"
                        );

                if (reason != null) {
                    reason = reason.trim();
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

                /*
                 * Doctor requests are ALWAYS PENDING.
                 */
                leaveService.addLeave(
                        leave,
                        "PENDING"
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/DoctorLeaveServlet?success=requested"
                );

                return;
            }


            /*
             * =====================================
             * ADMIN APPROVES LEAVE
             * =====================================
             */
            if ("approve".equalsIgnoreCase(action)) {

                if (!"admin".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/Login.jsp?error=access"
                    );

                    return;
                }

                int id
                        = Integer.parseInt(
                                request.getParameter("id")
                        );

                boolean success
                        = leaveService.approveLeave(id);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?success=approved"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?error=approve"
                    );
                }

                return;
            }


            /*
             * =====================================
             * ADMIN REJECTS LEAVE
             * =====================================
             */
            if ("reject".equalsIgnoreCase(action)) {

                if (!"admin".equalsIgnoreCase(role)) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/Login.jsp?error=access"
                    );

                    return;
                }

                int id
                        = Integer.parseInt(
                                request.getParameter("id")
                        );

                boolean success
                        = leaveService.rejectLeave(id);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?success=rejected"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?error=reject"
                    );
                }

                return;
            }


            /*
             * =====================================
             * CANCEL LEAVE
             * =====================================
             */
            if ("cancel".equalsIgnoreCase(action)) {

                int id
                        = Integer.parseInt(
                                request.getParameter("id")
                        );

                DoctorLeave leave
                        = leaveService
                                .getAllLeaves()
                                .stream()
                                .filter(
                                        l -> l.getId() == id
                                )
                                .findFirst()
                                .orElse(null);

                if (leave == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?error=notfound"
                    );

                    return;
                }

                /*
                 * Doctor can cancel ONLY their own leave.
                 */
                if ("doctor".equalsIgnoreCase(role)) {

                    Object userId
                            = session.getAttribute("userId");

                    int doctorId
                            = Integer.parseInt(
                                    userId.toString()
                            );

                    if (leave.getDoctorId()
                            != doctorId) {

                        response.sendRedirect(
                                request.getContextPath()
                                + "/DoctorLeaveServlet?error=access"
                        );

                        return;
                    }

                    /*
                     * Doctor can cancel pending/approved leave.
                     */
                    leaveService.cancelLeave(id);

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?success=cancelled"
                    );

                    return;
                }


                /*
                 * Admin can cancel approved/pending leave.
                 */
                if ("admin".equalsIgnoreCase(role)) {

                    leaveService.cancelLeave(id);

                    response.sendRedirect(
                            request.getContextPath()
                            + "/DoctorLeaveServlet?success=cancelled"
                    );

                    return;
                }

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=access"
                );

                return;
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorLeaveServlet?error=action"
            );

        } catch (IllegalArgumentException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorLeaveServlet?error="
                    + URLEncoder.encode(
                            e.getMessage(),
                            "UTF-8"
                    )
            );

        } catch (SQLException e) {

            getServletContext().log(
                    "Error processing doctor leave.",
                    e
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorLeaveServlet?error=database"
            );
        }
    }
}
