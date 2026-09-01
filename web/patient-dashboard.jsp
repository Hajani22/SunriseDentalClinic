<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="service.AppointmentService"%>
<%@page import="service.impl.AppointmentServiceImpl"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="dao.impl.NotificationDAOImpl"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /* =========================================================
       PATIENT SESSION VALIDATION
       ========================================================= */

    if (session.getAttribute("user") == null) {
        response.sendRedirect(
                request.getContextPath() + "/Login.jsp"
        );
        return;
    }

    String role = String.valueOf(
            session.getAttribute("userRole")
    );

    if (!"patient".equalsIgnoreCase(role)) {
        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );
        return;
    }


    /* =========================================================
       PATIENT ID
       ========================================================= */
    Object userIdObject
            = session.getAttribute("userId");

    if (userIdObject == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=session"
        );
        return;
    }

    int patientId;

    try {
        patientId = Integer.parseInt(
                userIdObject.toString()
        );
    } catch (NumberFormatException e) {
        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=session"
        );
        return;
    }


    /* =========================================================
       PATIENT NAME
       ========================================================= */
    String patientName
            = (String) session.getAttribute("userName");

    if (patientName == null
            || patientName.trim().isEmpty()) {

        patientName = "Patient";
    }


    /* =========================================================
       SERVICES
       ========================================================= */
    AppointmentService appointmentService
            = new AppointmentServiceImpl();

    NotificationDAO notificationDAO
            = new NotificationDAOImpl();


    /* =========================================================
       DATA
       ========================================================= */
    List<Appointment> appointments = null;

    List<String[]> notifications = null;

    try {

        appointments
                = appointmentService
                        .getPatientAppointments(
                                patientId
                        );

        notifications
                = notificationDAO.getForUser(
                        patientId,
                        "patient"
                );

    } catch (Exception e) {

        e.printStackTrace();
    }


    /* =========================================================
       DASHBOARD STATISTICS
       ========================================================= */
    int totalAppointments = 0;
    int pendingAppointments = 0;
    int confirmedAppointments = 0;
    int completedAppointments = 0;
    int cancelledAppointments = 0;
    int unreadNotifications = 0;

    Appointment nextAppointment = null;

    if (appointments != null) {

        totalAppointments
                = appointments.size();

        for (Appointment appointment
                : appointments) {

            String status
                    = appointment.getStatus();

            if ("PENDING_DOCTOR".equalsIgnoreCase(status)
                    || "PENDING_ADMIN".equalsIgnoreCase(status)
                    || "PENDING".equalsIgnoreCase(status)) {

                pendingAppointments++;
            }

            if ("CONFIRMED".equalsIgnoreCase(status)) {

                confirmedAppointments++;

                if (nextAppointment == null) {
                    nextAppointment
                            = appointment;
                }
            }

            if ("COMPLETED".equalsIgnoreCase(status)) {

                completedAppointments++;
            }

            if ("CANCELLED".equalsIgnoreCase(status)
                    || "CANCELED".equalsIgnoreCase(status)) {

                cancelledAppointments++;
            }
        }
    }


    /* =========================================================
       UNREAD NOTIFICATIONS
       ========================================================= */
    if (notifications != null) {

        for (String[] notification
                : notifications) {

            if (notification != null
                    && notification.length > 4
                    && "0".equals(
                            notification[4]
                    )) {

                unreadNotifications++;
            }
        }
    }

%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width,
              initial-scale=1.0">

        <title>
            Patient Dashboard | Sunrise Dental Clinic
        </title>


        <!-- =====================================================
             GOOGLE FONT
             ===================================================== -->

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <!-- =====================================================
             FONT AWESOME
             ===================================================== -->

        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /* =====================================================
               RESET
               ===================================================== */

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }


            body {
                font-family:
                    "Open Sans",
                    sans-serif;

                background: #f5f8fc;

                color: #475569;
            }


            a {
                text-decoration: none;
            }


            /* =====================================================
               MAIN LAYOUT
               ===================================================== */

            .dashboard {
                display: flex;
                min-height: 100vh;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                width: 255px;

                position: fixed;

                top: 0;
                left: 0;
                bottom: 0;

                background:
                    linear-gradient(
                    180deg,
                    #071d3a 0%,
                    #0b2b50 100%
                    );

                color: white;

                padding: 25px 16px;

                z-index: 1000;

                overflow-y: auto;
            }


            .brand {

                display: flex;

                align-items: center;

                gap: 12px;

                padding:
                    8px 12px 28px;

                margin-bottom: 22px;

                border-bottom:
                    1px solid
                    rgba(255,255,255,.08);
            }


            .brand-icon {

                width: 44px;
                height: 44px;

                border-radius: 12px;

                background: #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 20px;
            }


            .brand-text {

                font-family: "Jost",
                    sans-serif;

                font-size: 20px;

                font-weight: 700;

                color: white;
            }


            .brand-text span {

                display: block;

                font-size: 11px;

                font-weight: 500;

                color:
                    rgba(255,255,255,.65);

                margin-top: 2px;
            }


            /* =====================================================
               MENU TITLE
               ===================================================== */

            .menu-title {

                font-size: 11px;

                text-transform: uppercase;

                letter-spacing: 1px;

                color:
                    rgba(255,255,255,.45);

                padding:
                    0 12px 10px;
            }


            /* =====================================================
               NAVIGATION
               ===================================================== */

            .menu {

                display: flex;

                flex-direction: column;

                gap: 6px;
            }


            .nav-link {

                display: flex;

                align-items: center;

                gap: 13px;

                padding:
                    12px 14px;

                color:
                    rgba(255,255,255,.75);

                border-radius: 9px;

                font-size: 14px;

                transition: .2s;
            }


            .nav-link i {

                width: 20px;

                text-align: center;

                font-size: 15px;
            }


            .nav-link:hover {

                background:
                    rgba(255,255,255,.08);

                color: white;
            }


            .nav-link.active {

                background: #06a3da;

                color: white;

                box-shadow:
                    0 6px 18px
                    rgba(6,163,218,.25);
            }


            /* =====================================================
               LOGOUT
               ===================================================== */

            .logout {

                position: absolute;

                left: 16px;
                right: 16px;
                bottom: 20px;

                border-top:
                    1px solid
                    rgba(255,255,255,.08);

                padding-top: 15px;
            }


            .logout a {

                display: flex;

                align-items: center;

                gap: 13px;

                padding:
                    12px 14px;

                border-radius: 9px;

                color:
                    rgba(255,255,255,.75);

                font-size: 14px;
            }


            .logout a:hover {

                background:
                    rgba(255,255,255,.08);

                color: white;
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left: 255px;

                width:
                    calc(100% - 255px);

                min-height: 100vh;
            }


            /* =====================================================
               TOP BAR
               ===================================================== */

            .topbar {

                height: 76px;

                background: white;

                border-bottom:
                    1px solid #e8edf3;

                display: flex;

                align-items: center;

                justify-content: space-between;

                padding:
                    0 35px;

                position: sticky;

                top: 0;

                z-index: 900;
            }


            .topbar h2 {

                font-family: "Jost",
                    sans-serif;

                color: #172b4d;

                font-size: 22px;
            }


            .user-area {

                display: flex;

                align-items: center;

                gap: 12px;
            }


            .user-info {

                text-align: right;
            }


            .user-info strong {

                display: block;

                color: #172b4d;

                font-size: 14px;
            }


            .user-info small {

                color: #82909e;

                font-size: 12px;
            }


            .avatar {

                width: 42px;
                height: 42px;

                border-radius: 50%;

                background:
                    #e8f7fc;

                color: #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 18px;
            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding: 32px;
            }


            .welcome {

                margin-bottom: 28px;
            }


            .welcome h1 {

                font-family: "Jost",
                    sans-serif;

                color: #172b4d;

                font-size: 28px;

                margin-bottom: 5px;
            }


            .welcome p {

                color: #82909e;

                font-size: 14px;
            }


            /* =====================================================
               STATISTICS
               ===================================================== */

            .stats {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 18px;

                margin-bottom: 28px;
            }


            .stat-card {

                background: white;

                border:
                    1px solid #e8edf3;

                border-radius: 12px;

                padding: 22px;

                display: flex;

                align-items: center;

                gap: 16px;

                box-shadow:
                    0 3px 12px
                    rgba(15,23,42,.03);
            }


            .stat-icon {

                width: 48px;
                height: 48px;

                border-radius: 12px;

                display: flex;

                align-items: center;

                justify-content: center;

                background: #e8f7fc;

                color: #06a3da;

                font-size: 19px;
            }


            .stat-card h3 {

                font-family: "Jost",
                    sans-serif;

                font-size: 25px;

                color: #172b4d;
            }


            .stat-card p {

                font-size: 12px;

                color: #82909e;

                margin-top: 2px;
            }


            /* =====================================================
               GRID
               ===================================================== */

            .dashboard-grid {

                display: grid;

                grid-template-columns:
                    minmax(0, 2fr)
                    minmax(300px, 1fr);

                gap: 22px;
            }


            /* =====================================================
               PANEL
               ===================================================== */

            .panel {

                background: white;

                border:
                    1px solid #e8edf3;

                border-radius: 12px;

                box-shadow:
                    0 3px 12px
                    rgba(15,23,42,.03);

                overflow: hidden;

                margin-bottom: 22px;
            }


            .panel-header {

                padding:
                    20px 22px;

                border-bottom:
                    1px solid #edf1f5;

                display: flex;

                align-items: center;

                justify-content: space-between;
            }


            .panel-title {

                font-family: "Jost",
                    sans-serif;

                font-size: 18px;

                color: #172b4d;

                font-weight: 700;
            }


            .view-all {

                font-size: 12px;

                color: #06a3da;

                font-weight: 600;
            }


            /* =====================================================
               NEXT APPOINTMENT
               ===================================================== */

            .next-appointment {

                padding: 22px;
            }


            .appointment-highlight {

                border:
                    1px solid #dceff7;

                background:
                    #f6fcfe;

                border-radius: 10px;

                padding: 20px;
            }


            .appointment-highlight-top {

                display: flex;

                align-items: center;

                justify-content: space-between;

                gap: 15px;
            }


            .doctor-name {

                font-family: "Jost",
                    sans-serif;

                color: #172b4d;

                font-size: 19px;

                font-weight: 700;
            }


            .treatment {

                color: #82909e;

                font-size: 13px;

                margin-top: 4px;
            }


            .appointment-meta {

                display: flex;

                flex-wrap: wrap;

                gap: 18px;

                margin-top: 18px;

                padding-top: 16px;

                border-top:
                    1px solid #dceff7;
            }


            .meta-item {

                display: flex;

                align-items: center;

                gap: 7px;

                color: #475569;

                font-size: 13px;
            }


            .meta-item i {

                color: #06a3da;
            }


            /* =====================================================
               STATUS
               ===================================================== */

            .status {

                display: inline-block;

                padding:
                    6px 11px;

                border-radius: 20px;

                font-size: 11px;

                font-weight: 700;
            }


            .status-confirmed {

                background: #e4f8ed;

                color: #16834b;
            }


            .status-pending {

                background: #fff4d6;

                color: #9a6a00;
            }


            .status-rejected {

                background: #ffe7e7;

                color: #c62828;
            }


            .status-completed {

                background: #e6f0ff;

                color: #1769aa;
            }


            .status-cancelled {

                background: #f1f3f5;

                color: #667085;
            }


            .status-default {

                background: #f1f5f9;

                color: #475569;
            }


            /* =====================================================
               APPOINTMENT LIST
               ===================================================== */

            .appointment-list {

                padding: 0 22px;
            }


            .appointment-item {

                padding: 18px 0;

                border-bottom:
                    1px solid #edf1f5;

                display: flex;

                align-items: center;

                justify-content: space-between;

                gap: 15px;
            }


            .appointment-item:last-child {

                border-bottom: none;
            }


            .appointment-left {

                display: flex;

                align-items: center;

                gap: 13px;

                min-width: 0;
            }


            .appointment-icon {

                width: 42px;
                height: 42px;

                flex-shrink: 0;

                border-radius: 10px;

                background: #e8f7fc;

                color: #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;
            }


            .appointment-doctor {

                color: #172b4d;

                font-weight: 600;

                font-size: 14px;
            }


            .appointment-service {

                color: #82909e;

                font-size: 12px;

                margin-top: 3px;
            }


            .appointment-right {

                text-align: right;

                flex-shrink: 0;
            }


            .appointment-date {

                color: #475569;

                font-size: 12px;

                margin-bottom: 6px;
            }


            /* =====================================================
               QUICK ACTIONS
               ===================================================== */

            .quick-actions {

                padding: 10px 22px 18px;
            }


            .quick-action {

                display: flex;

                align-items: center;

                gap: 13px;

                padding: 13px 0;

                border-bottom:
                    1px solid #edf1f5;
            }


            .quick-action:last-child {

                border-bottom: none;
            }


            .quick-action-icon {

                width: 40px;
                height: 40px;

                border-radius: 9px;

                background: #e8f7fc;

                color: #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                flex-shrink: 0;
            }


            .quick-action-text strong {

                display: block;

                color: #172b4d;

                font-size: 13px;
            }


            .quick-action-text span {

                display: block;

                color: #82909e;

                font-size: 11px;

                margin-top: 3px;
            }


            .quick-action:hover
            .quick-action-text strong {

                color: #06a3da;
            }


            /* =====================================================
               NOTIFICATIONS
               ===================================================== */

            .notification-list {

                padding: 8px 22px 15px;
            }


            .notification-item {

                display: flex;

                gap: 12px;

                padding: 13px 0;

                border-bottom:
                    1px solid #edf1f5;
            }


            .notification-item:last-child {

                border-bottom: none;
            }


            .notification-icon {

                width: 35px;
                height: 35px;

                flex-shrink: 0;

                border-radius: 50%;

                background: #e8f7fc;

                color: #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 13px;
            }


            .notification-title {

                color: #172b4d;

                font-size: 12px;

                font-weight: 700;

                margin-bottom: 3px;
            }


            .notification-message {

                color: #82909e;

                font-size: 11px;

                line-height: 1.5;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                text-align: center;

                padding: 35px 20px;

                color: #98a2b3;
            }


            .empty i {

                font-size: 32px;

                margin-bottom: 10px;
            }


            .empty p {

                font-size: 13px;
            }


            /* =====================================================
               FEEDBACK PROMOTION
               ===================================================== */

            .feedback-card {

                padding: 22px;

                background:
                    linear-gradient(
                    135deg,
                    #eefaff,
                    #ffffff
                    );
            }


            .feedback-card-inner {

                display: flex;

                align-items: center;

                gap: 15px;
            }


            .feedback-icon {

                width: 48px;
                height: 48px;

                border-radius: 12px;

                background: #06a3da;

                color: white;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 19px;

                flex-shrink: 0;
            }


            .feedback-text {

                flex: 1;
            }


            .feedback-text h3 {

                font-family: "Jost",
                    sans-serif;

                color: #172b4d;

                font-size: 16px;

                margin-bottom: 3px;
            }


            .feedback-text p {

                color: #82909e;

                font-size: 12px;

                line-height: 1.5;
            }


            .feedback-btn {

                background: #06a3da;

                color: white;

                padding:
                    10px 14px;

                border-radius: 7px;

                font-size: 12px;

                font-weight: 700;

                white-space: nowrap;
            }


            .feedback-btn:hover {

                background: #0589b8;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media (max-width: 1100px) {

                .stats {

                    grid-template-columns:
                        repeat(2, 1fr);
                }


                .dashboard-grid {

                    grid-template-columns: 1fr;
                }
            }


            @media (max-width: 800px) {

                .sidebar {

                    width: 70px;

                    padding:
                        20px 10px;
                }


                .brand {

                    justify-content: center;

                    padding:
                        8px 0 25px;
                }


                .brand-text,
                .menu-title,
                .nav-link span,
                .logout span {

                    display: none;
                }


                .nav-link {

                    justify-content: center;

                    padding:
                        12px 5px;
                }


                .logout {

                    left: 10px;
                    right: 10px;
                }


                .logout a {

                    justify-content: center;
                }


                .main {

                    margin-left: 70px;

                    width:
                        calc(100% - 70px);
                }


                .topbar {

                    padding:
                        0 20px;
                }


                .content {

                    padding: 20px;
                }
            }


            @media (max-width: 550px) {

                .stats {

                    grid-template-columns: 1fr;
                }


                .appointment-highlight-top {

                    align-items: flex-start;

                    flex-direction: column;
                }


                .appointment-item {

                    align-items: flex-start;

                    flex-direction: column;
                }


                .appointment-right {

                    text-align: left;
                }


                .feedback-card-inner {

                    align-items: flex-start;

                    flex-direction: column;
                }


                .feedback-btn {

                    display: inline-block;
                }


                .user-info {

                    display: none;
                }
            }

        </style>

    </head>


    <body>


        <div class="dashboard">


            <!-- =====================================================
                 SIDEBAR
                 ===================================================== -->

            <aside class="sidebar">


                <!-- BRAND -->

                <div class="brand">

                    <div class="brand-icon">

                        <i class="fa-solid fa-tooth"></i>

                    </div>


                    <div class="brand-text">

                        Sunrise Dental

                        <span>
                            Patient Portal
                        </span>

                    </div>

                </div>


                <div class="menu-title">
                    Patient Menu
                </div>


                <!-- NAVIGATION -->

                <nav class="menu">


                    <!-- DASHBOARD -->

                    <a href="<%=request.getContextPath()%>/patient-dashboard.jsp"
                       class="nav-link active">

                        <i class="fa-solid fa-gauge"></i>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <!-- BOOK APPOINTMENT -->

                    <a href="<%=request.getContextPath()%>/BookAppointmentServlet"
                       class="nav-link">

                        <i class="fa-solid fa-calendar-plus"></i>

                        <span>
                            Book Appointment
                        </span>

                    </a>


                    <!-- MY APPOINTMENTS -->

                    <a href="<%=request.getContextPath()%>/PatientAppointmentsServlet"
                       class="nav-link">

                        <i class="fa-solid fa-calendar-check"></i>

                        <span>
                            My Appointments
                        </span>

                    </a>


                    <!-- MY BILLS -->

                    <a href="<%=request.getContextPath()%>/PatientBillsServlet"
                       class="nav-link">

                        <i class="fa-solid fa-file-invoice-dollar"></i>

                        <span>
                            My Bills
                        </span>

                    </a>


                    <!-- NOTIFICATIONS -->

                    <a href="<%=request.getContextPath()%>/PatientNotificationsServlet"
                       class="nav-link">

                        <i class="fa-solid fa-bell"></i>

                        <span>
                            Notifications
                            <%
                                if (unreadNotifications > 0) {
                            %>

                            (<%=unreadNotifications%>)

                            <%
                                }
                            %>
                        </span>

                    </a>


                    <!-- MEDICAL HISTORY -->

                    <a href="<%=request.getContextPath()%>/PatientMedicalHistoryServlet"
                       class="nav-link">

                        <i class="fa-solid fa-file-medical"></i>

                        <span>
                            Medical History
                        </span>

                    </a>


                    <!-- =================================================
                         PATIENT FEEDBACK
                         ================================================= -->

                    <a href="<%=request.getContextPath()%>/PatientFeedbackServlet"
                       class="nav-link">

                        <i class="fa-solid fa-comment-dots"></i>

                        <span>
                            Patient Feedback
                        </span>

                    </a>


                    <!-- HELP -->

                    <a href="<%=request.getContextPath()%>/Help.jsp"
                       class="nav-link">

                        <i class="fa-solid fa-circle-question"></i>

                        <span>
                            Help & Support
                        </span>

                    </a>


                </nav>


                <!-- LOGOUT -->

                <div class="logout">

                    <a href="<%=request.getContextPath()%>/LogoutServlet">

                        <i class="fa-solid fa-right-from-bracket"></i>

                        <span>
                            Logout
                        </span>

                    </a>

                </div>


            </aside>


            <!-- =====================================================
                 MAIN CONTENT
                 ===================================================== -->

            <main class="main">


                <!-- =================================================
                     TOP BAR
                     ================================================= -->

                <header class="topbar">


                    <h2>
                        Patient Dashboard
                    </h2>


                    <div class="user-area">


                        <div class="user-info">

                            <strong>
                                <%=patientName%>
                            </strong>

                            <small>
                                Patient
                            </small>

                        </div>


                        <div class="avatar">

                            <i class="fa-solid fa-user"></i>

                        </div>


                    </div>


                </header>


                <!-- =================================================
                     CONTENT
                     ================================================= -->

                <section class="content">


                    <!-- WELCOME -->

                    <div class="welcome">

                        <h1>
                            Welcome, <%=patientName%>!
                        </h1>

                        <p>
                            Manage your appointments,
                            notifications and dental care
                            from your patient portal.
                        </p>

                    </div>


                    <!-- =================================================
                         STATISTICS
                         ================================================= -->

                    <div class="stats">


                        <!-- TOTAL -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-calendar-days"></i>

                            </div>

                            <div>

                                <h3>
                                    <%=totalAppointments%>
                                </h3>

                                <p>
                                    Total Appointments
                                </p>

                            </div>

                        </div>


                        <!-- PENDING -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-clock"></i>

                            </div>

                            <div>

                                <h3>
                                    <%=pendingAppointments%>
                                </h3>

                                <p>
                                    Pending Appointments
                                </p>

                            </div>

                        </div>


                        <!-- CONFIRMED -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-circle-check"></i>

                            </div>

                            <div>

                                <h3>
                                    <%=confirmedAppointments%>
                                </h3>

                                <p>
                                    Confirmed Appointments
                                </p>

                            </div>

                        </div>


                        <!-- NOTIFICATIONS -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-bell"></i>

                            </div>

                            <div>

                                <h3>
                                    <%=unreadNotifications%>
                                </h3>

                                <p>
                                    Unread Notifications
                                </p>

                            </div>

                        </div>


                    </div>


                    <!-- =================================================
                         DASHBOARD GRID
                         ================================================= -->

                    <div class="dashboard-grid">


                        <!-- =================================================
                             LEFT COLUMN
                             ================================================= -->

                        <div>


                            <!-- NEXT APPOINTMENT -->

                            <div class="panel">


                                <div class="panel-header">

                                    <div class="panel-title">

                                        Next Appointment

                                    </div>


                                    <a href="<%=request.getContextPath()%>/PatientAppointmentsServlet"
                                       class="view-all">

                                        View All

                                    </a>

                                </div>


                                <div class="next-appointment">


                                    <%
                                        if (nextAppointment != null) {

                                            String nextStatus
                                                    = nextAppointment.getStatus();

                                            String nextStatusClass
                                                    = "status-default";

                                            if ("CONFIRMED".equalsIgnoreCase(
                                                    nextStatus)) {

                                                nextStatusClass
                                                        = "status-confirmed";

                                            } else if ("PENDING_DOCTOR".equalsIgnoreCase(
                                                    nextStatus)
                                                    || "PENDING_ADMIN".equalsIgnoreCase(
                                                            nextStatus)
                                                    || "PENDING".equalsIgnoreCase(
                                                            nextStatus)) {

                                                nextStatusClass
                                                        = "status-pending";

                                            } else if ("COMPLETED".equalsIgnoreCase(
                                                    nextStatus)) {

                                                nextStatusClass
                                                        = "status-completed";

                                            } else if ("CANCELLED".equalsIgnoreCase(
                                                    nextStatus)
                                                    || "CANCELED".equalsIgnoreCase(
                                                            nextStatus)) {

                                                nextStatusClass
                                                        = "status-cancelled";
                                            }

                                    %>


                                    <div class="appointment-highlight">


                                        <div class="appointment-highlight-top">


                                            <div>

                                                <div class="doctor-name">

                                                    Dr.
                                                    <%=nextAppointment.getDoctorName()%>

                                                </div>


                                                <div class="treatment">

                                                    <%=nextAppointment.getTreatmentType()%>

                                                </div>

                                            </div>


                                            <span class="status <%=nextStatusClass%>">

                                                <%=nextStatus%>

                                            </span>


                                        </div>


                                        <div class="appointment-meta">


                                            <div class="meta-item">

                                                <i class="fa-regular fa-calendar"></i>

                                                <%=nextAppointment.getAppointmentDate()%>

                                            </div>


                                            <div class="meta-item">

                                                <i class="fa-regular fa-clock"></i>

                                                <%=nextAppointment.getAppointmentTime()%>

                                            </div>


                                        </div>


                                    </div>


                                    <%
                                    } else {
                                    %>


                                    <div class="empty">

                                        <i class="fa-regular fa-calendar-xmark"></i>

                                        <p>
                                            You do not have any
                                            upcoming appointments.
                                        </p>

                                    </div>


                                    <%
                                        }
                                    %>


                                </div>


                            </div>


                            <!-- =================================================
                                 RECENT APPOINTMENTS
                                 ================================================= -->

                            <div class="panel">


                                <div class="panel-header">

                                    <div class="panel-title">

                                        Recent Appointments

                                    </div>


                                    <a href="<%=request.getContextPath()%>/PatientAppointmentsServlet"
                                       class="view-all">

                                        View All

                                    </a>

                                </div>


                                <div class="appointment-list">


                                    <%
                                        if (appointments != null
                                                && !appointments.isEmpty()) {

                                            int count = 0;

                                            for (Appointment appointment
                                                    : appointments) {

                                                if (count >= 5) {
                                                    break;
                                                }

                                                count++;

                                                String status
                                                        = appointment.getStatus();

                                                String statusClass
                                                        = "status-default";

                                                if ("CONFIRMED".equalsIgnoreCase(
                                                        status)) {

                                                    statusClass
                                                            = "status-confirmed";

                                                } else if ("PENDING_DOCTOR".equalsIgnoreCase(
                                                        status)
                                                        || "PENDING_ADMIN".equalsIgnoreCase(
                                                                status)
                                                        || "PENDING".equalsIgnoreCase(
                                                                status)) {

                                                    statusClass
                                                            = "status-pending";

                                                } else if ("COMPLETED".equalsIgnoreCase(
                                                        status)) {

                                                    statusClass
                                                            = "status-completed";

                                                } else if ("CANCELLED".equalsIgnoreCase(
                                                        status)
                                                        || "CANCELED".equalsIgnoreCase(
                                                                status)) {

                                                    statusClass
                                                            = "status-cancelled";

                                                } else if (status != null
                                                        && status.toUpperCase()
                                                                .startsWith(
                                                                        "REJECTED"
                                                                )) {

                                                    statusClass
                                                            = "status-rejected";
                                                }

                                    %>


                                    <div class="appointment-item">


                                        <div class="appointment-left">


                                            <div class="appointment-icon">

                                                <i class="fa-solid fa-tooth"></i>

                                            </div>


                                            <div>

                                                <div class="appointment-doctor">

                                                    Dr.
                                                    <%=appointment.getDoctorName()%>

                                                </div>


                                                <div class="appointment-service">

                                                    <%=appointment.getTreatmentType()%>

                                                </div>

                                            </div>


                                        </div>


                                        <div class="appointment-right">


                                            <div class="appointment-date">

                                                <%=appointment.getAppointmentDate()%>

                                                <br>

                                                <%=appointment.getAppointmentTime()%>

                                            </div>


                                            <span class="status <%=statusClass%>">

                                                <%=status%>

                                            </span>


                                        </div>


                                    </div>


                                    <%
                                        }
                                    } else {
                                    %>


                                    <div class="empty">

                                        <i class="fa-regular fa-calendar"></i>

                                        <p>
                                            No appointments found.
                                        </p>

                                    </div>


                                    <%
                                        }
                                    %>


                                </div>


                            </div>


                        </div>


                        <!-- =================================================
                             RIGHT COLUMN
                             ================================================= -->

                        <div>


                            <!-- QUICK ACTIONS -->

                            <div class="panel">


                                <div class="panel-header">

                                    <div class="panel-title">

                                        Quick Actions

                                    </div>

                                </div>


                                <div class="quick-actions">


                                    <!-- BOOK -->

                                    <a href="<%=request.getContextPath()%>/BookAppointmentServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-calendar-plus"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Book Appointment
                                            </strong>

                                            <span>
                                                Schedule a dental visit
                                            </span>

                                        </div>

                                    </a>


                                    <!-- APPOINTMENTS -->

                                    <a href="<%=request.getContextPath()%>/PatientAppointmentsServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-calendar-check"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                My Appointments
                                            </strong>

                                            <span>
                                                View appointment status
                                            </span>

                                        </div>

                                    </a>


                                    <!-- BILLS -->

                                    <a href="<%=request.getContextPath()%>/PatientBillsServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-file-invoice-dollar"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                My Bills
                                            </strong>

                                            <span>
                                                View your payments
                                            </span>

                                        </div>

                                    </a>

                                    <!-- =================================================
  PAYMENT
  ================================================= -->

                                    <a href="<%=request.getContextPath()%>/PatientPaymentPageServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-credit-card"></i>

                                        </div>

                                        <div class="quick-action-text">

                                            <strong>
                                                Payment
                                            </strong>

                                            <span>
                                                Pay for your confirmed appointment
                                            </span>

                                        </div>

                                    </a>


                                    <!-- NOTIFICATIONS -->

                                    <a href="<%=request.getContextPath()%>/PatientNotificationsServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-bell"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Notifications
                                            </strong>

                                            <span>
                                                Check latest updates
                                            </span>

                                        </div>

                                    </a>


                                    <!-- =================================================
                                         PATIENT FEEDBACK
                                         ================================================= -->

                                    <a href="<%=request.getContextPath()%>/PatientFeedbackServlet"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-comment-dots"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Patient Feedback
                                            </strong>

                                            <span>
                                                Rate your dental experience
                                            </span>

                                        </div>

                                    </a>


                                    <!-- HELP -->

                                    <a href="<%=request.getContextPath()%>/Help.jsp"
                                       class="quick-action">

                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-circle-question"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Help & Support
                                            </strong>

                                            <span>
                                                Get assistance
                                            </span>

                                        </div>

                                    </a>


                                </div>


                            </div>


                            <!-- =================================================
                                 FEEDBACK CARD
                                 ================================================= -->

                            <div class="panel">


                                <div class="feedback-card">


                                    <div class="feedback-card-inner">


                                        <div class="feedback-icon">

                                            <i class="fa-solid fa-star"></i>

                                        </div>


                                        <div class="feedback-text">

                                            <h3>
                                                How was your experience?
                                            </h3>

                                            <p>
                                                Your feedback helps
                                                Sunrise Dental Clinic
                                                improve our services.
                                            </p>

                                        </div>


                                        <a href="<%=request.getContextPath()%>/PatientFeedbackServlet"
                                           class="feedback-btn">

                                            Give Feedback

                                        </a>


                                    </div>


                                </div>


                            </div>


                            <!-- =================================================
                                 NOTIFICATIONS
                                 ================================================= -->

                            <div class="panel">


                                <div class="panel-header">


                                    <div class="panel-title">

                                        Latest Notifications

                                    </div>


                                    <a href="<%=request.getContextPath()%>/PatientNotificationsServlet"
                                       class="view-all">

                                        View All

                                    </a>


                                </div>


                                <div class="notification-list">


                                    <%
                                        if (notifications != null
                                                && !notifications.isEmpty()) {

                                            int notificationCount = 0;

                                            for (String[] n
                                                    : notifications) {

                                                if (notificationCount >= 3) {
                                                    break;
                                                }

                                                notificationCount++;

                                    %>


                                    <div class="notification-item">


                                        <div class="notification-icon">

                                            <i class="fa-solid fa-bell"></i>

                                        </div>


                                        <div>


                                            <div class="notification-title">

                                                <%=n.length > 1
                                                        && n[1] != null
                                                                ? n[1]
                                                                : "Notification"%>

                                            </div>


                                            <div class="notification-message">

                                                <%=n.length > 2
                                                        && n[2] != null
                                                                ? n[2]
                                                                : ""%>

                                            </div>


                                        </div>


                                    </div>


                                    <%
                                        }
                                    } else {
                                    %>


                                    <div class="empty">

                                        <i class="fa-regular fa-bell-slash"></i>

                                        <p>
                                            No notifications yet.
                                        </p>

                                    </div>


                                    <%
                                        }
                                    %>


                                </div>


                            </div>


                        </div>


                    </div>


                </section>


            </main>


        </div>

        <jsp:include page="toast.jsp" />

    </body>

</html>