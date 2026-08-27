package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.DoctorOption;
import model.DoctorSchedule;

import service.AppointmentService;
import service.DoctorScheduleService;

import service.impl.AppointmentServiceImpl;
import service.impl.DoctorScheduleServiceImpl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/DoctorScheduleServlet")
public class DoctorScheduleServlet
        extends HttpServlet {

    private AppointmentService appointmentService;

    private DoctorScheduleService scheduleService;

    @Override
    public void init()
            throws ServletException {

        appointmentService
                = new AppointmentServiceImpl();

        scheduleService
                = new DoctorScheduleServiceImpl();
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
                    = appointmentService.getDoctors();

            List<DoctorSchedule> schedules
                    = scheduleService.getAllSchedules();

            request.setAttribute(
                    "doctors",
                    doctors
            );

            request.setAttribute(
                    "schedules",
                    schedules
            );

            request.getRequestDispatcher(
                    "/doctor-schedules.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (SQLException e) {

            e.printStackTrace();

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

        request.setCharacterEncoding("UTF-8");

        try {

            int doctorId
                    = Integer.parseInt(
                            request.getParameter(
                                    "doctorId"
                            )
                    );

            String day
                    = request.getParameter(
                            "dayOfWeek"
                    );

            String start
                    = request.getParameter(
                            "startTime"
                    );

            String end
                    = request.getParameter(
                            "endTime"
                    );

            String breakStart
                    = request.getParameter(
                            "breakStart"
                    );

            String breakEnd
                    = request.getParameter(
                            "breakEnd"
                    );

            boolean available
                    = "1".equals(
                            request.getParameter(
                                    "available"
                            )
                    );

            DoctorSchedule schedule
                    = new DoctorSchedule();

            schedule.setDoctorId(
                    doctorId
            );

            schedule.setDayOfWeek(
                    day
            );

            schedule.setStartTime(
                    start
            );

            schedule.setEndTime(
                    end
            );

            schedule.setBreakStart(
                    breakStart
            );

            schedule.setBreakEnd(
                    breakEnd
            );

            schedule.setAvailable(
                    available
            );

            scheduleService.saveSchedule(
                    schedule
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorScheduleServlet?success=saved"
            );

        } catch (IllegalArgumentException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorScheduleServlet?error="
                    + java.net.URLEncoder.encode(
                            e.getMessage(),
                            "UTF-8"
                    )
            );

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/DoctorScheduleServlet?error=database"
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

        Object user
                = session.getAttribute("user");

        if (user == null) {
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
