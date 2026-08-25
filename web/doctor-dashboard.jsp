<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="service.AppointmentService"%>
<%@page import="service.impl.AppointmentServiceImpl"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="dao.impl.NotificationDAOImpl"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * DOCTOR SESSION
     * =========================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"doctor".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /*
     * =========================================================
     * DOCTOR ID
     * =========================================================
     */
    Object userIdObject
            = session.getAttribute("userId");

    if (userIdObject == null) {

        response.sendRedirect(
                "Login.jsp?error=session"
        );

        return;
    }

    int doctorId
            = Integer.parseInt(
                    userIdObject.toString()
            );


    /*
     * =========================================================
     * DOCTOR NAME
     * =========================================================
     */
    String doctorName
            = (String) session.getAttribute(
                    "userName"
            );

    if (doctorName == null
            || doctorName.trim().isEmpty()) {

        doctorName = "Doctor";
    }


    /*
     * =========================================================
     * SERVICES
     * =========================================================
     */
    AppointmentService appointmentService
            = new AppointmentServiceImpl();

    NotificationDAO notificationDAO
            = new NotificationDAOImpl();

    List<Appointment> appointments
            = null;

    List<String[]> notifications
            = null;

    try {

        appointments
                = appointmentService
                        .getDoctorAppointments(
                                doctorId
                        );

        notifications
                = notificationDAO.getForUser(
                        doctorId,
                        "doctor"
                );

    } catch (Exception e) {

        e.printStackTrace();
    }


    /*
     * =========================================================
     * STATISTICS
     * =========================================================
     */
    int totalAppointments = 0;

    int pendingRequests = 0;

    int confirmedAppointments = 0;

    int unreadNotifications = 0;

    if (appointments != null) {

        totalAppointments
                = appointments.size();

        for (Appointment appointment
                : appointments) {

            String status
                    = appointment.getStatus();

            if ("PENDING_DOCTOR".equals(status)) {

                pendingRequests++;

            }

            if ("CONFIRMED".equals(status)) {

                confirmedAppointments++;

            }

        }

    }


    /*
     * =========================================================
     * NOTIFICATION COUNT
     * =========================================================
     */
    if (notifications != null) {

        for (String[] notification
                : notifications) {

            if (notification.length > 3
                    && "0".equals(
                            notification[3]
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
              content="width=device-width, initial-scale=1.0">


        <title>
            Doctor Dashboard | Sunrise Dental Clinic
        </title>


        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }


            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f5f8fc;

                color:
                    #475569;

            }


            a {
                text-decoration: none;
            }


            /* =====================================================
               LAYOUT
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
                bottom: 0;
                left: 0;

                background:
                    linear-gradient(
                    180deg,
                    #071d3a 0%,
                    #0b2b50 100%
                    );

                color: white;

                padding: 25px 16px;

                z-index: 1000;

            }


            .brand {

                display: flex;

                align-items: center;

                gap: 12px;

                padding:
                    8px 12px 30px;

                border-bottom:
                    1px solid
                    rgba(255,255,255,.08);

                margin-bottom: 22px;

            }


            .brand-icon {

                width: 42px;
                height: 42px;

                border-radius: 12px;

                background:
                    #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 20px;

            }


            .brand-text {

                font-family:
                    "Jost",
                    sans-serif;

                font-size: 19px;

                font-weight: 700;

            }


            .brand-text span {

                display: block;

                font-size: 11px;

                color:
                    #94a9bf;

                font-weight: 400;

                margin-top: 2px;

            }


            .menu-title {

                font-size: 10px;

                color:
                    #7890a9;

                text-transform:
                    uppercase;

                letter-spacing: 1.3px;

                padding:
                    0 12px 10px;

            }


            .nav-link {

                display: flex;

                align-items: center;

                gap: 13px;

                color:
                    #bdcbd9;

                padding:
                    13px 14px;

                margin-bottom: 5px;

                border-radius: 9px;

                font-size: 14px;

                transition:
                    .2s;

            }


            .nav-link i {

                width: 19px;

                text-align: center;

            }


            .nav-link:hover,
            .nav-link.active {

                background:
                    #06a3da;

                color:
                    white;

            }


            .notification-link {

                position: relative;

            }


            .notification-count {

                margin-left: auto;

                min-width: 20px;

                height: 20px;

                padding: 0 6px;

                border-radius: 20px;

                background:
                    #ef4444;

                color: white;

                font-size: 10px;

                display: flex;

                align-items: center;

                justify-content: center;

                font-weight: 700;

            }


            .logout-area {

                position: absolute;

                left: 16px;

                right: 16px;

                bottom: 20px;

            }


            .logout {

                border-top:
                    1px solid
                    rgba(255,255,255,.08);

                padding-top: 15px;

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
               TOPBAR
               ===================================================== */

            .topbar {

                background:
                    white;

                height: 76px;

                border-bottom:
                    1px solid #e7edf3;

                padding:
                    0 32px;

                display: flex;

                align-items: center;

                justify-content:
                    space-between;

            }


            .welcome-small {

                font-size: 12px;

                color:
                    #94a3b8;

                margin-bottom: 3px;

            }


            .welcome-title {

                font-family:
                    "Jost",
                    sans-serif;

                color:
                    #0b2447;

                font-size: 21px;

                font-weight: 700;

            }


            .profile {

                display: flex;

                align-items: center;

                gap: 11px;

            }


            .profile-avatar {

                width: 42px;
                height: 42px;

                border-radius: 50%;

                background:
                    #e6f7fc;

                color:
                    #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

            }


            .profile-name {

                color:
                    #0b2447;

                font-weight: 600;

                font-size: 13px;

            }


            .profile-role {

                color:
                    #94a3b8;

                font-size: 11px;

            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding: 30px;

                max-width: 1500px;

                margin: auto;

            }


            /* =====================================================
               HERO
               ===================================================== */

            .hero {

                position: relative;

                overflow: hidden;

                border-radius: 18px;

                padding:
                    30px 32px;

                background:
                    linear-gradient(
                    135deg,
                    #087eac,
                    #06a3da
                    );

                color: white;

                margin-bottom: 25px;

                box-shadow:
                    0 10px 30px
                    rgba(6,163,218,.18);

            }


            .hero-content {

                position: relative;

                z-index: 2;

                display: flex;

                justify-content:
                    space-between;

                align-items: center;

                gap: 20px;

            }


            .hero-label {

                display: inline-flex;

                align-items: center;

                gap: 7px;

                background:
                    rgba(255,255,255,.16);

                padding:
                    6px 11px;

                border-radius: 20px;

                font-size: 11px;

                margin-bottom: 10px;

            }


            .hero h1 {

                font-family:
                    "Jost",
                    sans-serif;

                font-size: 30px;

                margin-bottom: 7px;

            }


            .hero p {

                color:
                    rgba(255,255,255,.86);

                font-size: 14px;

            }


            .hero-button {

                background:
                    white;

                color:
                    #087eac;

                padding:
                    13px 19px;

                border-radius: 9px;

                font-size: 13px;

                font-weight: 700;

                white-space: nowrap;

            }


            /* =====================================================
               STATISTICS
               ===================================================== */

            .stats {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 18px;

                margin-bottom: 25px;

            }


            .stat-card {

                background:
                    white;

                border:
                    1px solid #e8eef4;

                border-radius: 14px;

                padding: 20px;

                box-shadow:
                    0 5px 18px
                    rgba(15,23,42,.035);

            }


            .stat-icon {

                width: 43px;
                height: 43px;

                border-radius: 11px;

                background:
                    #e9f8fc;

                color:
                    #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

                margin-bottom: 15px;

            }


            .stat-number {

                color:
                    #0b2447;

                font-family:
                    "Jost",
                    sans-serif;

                font-size: 27px;

                font-weight: 700;

            }


            .stat-label {

                color:
                    #64748b;

                font-size: 12px;

            }


            /* =====================================================
               GRID
               ===================================================== */

            .dashboard-grid {

                display: grid;

                grid-template-columns:
                    minmax(0, 1.7fr)
                    minmax(300px, 1fr);

                gap: 22px;

            }


            .panel {

                background:
                    white;

                border:
                    1px solid #e8eef4;

                border-radius: 14px;

                padding: 23px;

                box-shadow:
                    0 5px 18px
                    rgba(15,23,42,.035);

                margin-bottom: 22px;

            }


            .panel-header {

                display: flex;

                align-items: center;

                justify-content:
                    space-between;

                margin-bottom: 18px;

            }


            .panel-title {

                font-family:
                    "Jost",
                    sans-serif;

                color:
                    #0b2447;

                font-size: 17px;

                font-weight: 700;

            }


            .view-all {

                color:
                    #06a3da;

                font-size: 12px;

                font-weight: 600;

            }


            /* =====================================================
               APPOINTMENT ROW
               ===================================================== */

            .appointment-item {

                display: flex;

                align-items: center;

                justify-content:
                    space-between;

                gap: 15px;

                padding:
                    15px 0;

                border-bottom:
                    1px solid #edf1f5;

            }


            .appointment-item:last-child {

                border-bottom:
                    none;

            }


            .appointment-info {

                display: flex;

                align-items: center;

                gap: 12px;

                min-width: 0;

            }


            .appointment-icon {

                width: 42px;
                height: 42px;

                flex-shrink: 0;

                border-radius: 10px;

                background:
                    #edf9fc;

                color:
                    #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

            }


            .patient-name {

                color:
                    #0b2447;

                font-weight: 700;

                font-size: 13px;

            }


            .patient-service {

                color:
                    #94a3b8;

                font-size: 11px;

                margin-top: 3px;

            }


            .appointment-right {

                text-align:
                    right;

                flex-shrink: 0;

            }


            .appointment-date {

                color:
                    #475569;

                font-size: 11px;

                margin-bottom: 6px;

            }


            /* =====================================================
               STATUS
               ===================================================== */

            .status {

                display: inline-flex;

                align-items: center;

                gap: 5px;

                padding:
                    5px 9px;

                border-radius: 20px;

                font-size: 10px;

                font-weight: 700;

            }


            .status-pending {

                color:
                    #a16207;

                background:
                    #fef9c3;

            }


            .status-confirmed {

                color:
                    #15803d;

                background:
                    #dcfce7;

            }


            .status-rejected {

                color:
                    #b91c1c;

                background:
                    #fee2e2;

            }


            /* =====================================================
               ACTION BUTTONS
               ===================================================== */

            .actions {

                display: flex;

                gap: 6px;

                margin-top: 7px;

                justify-content:
                    flex-end;

            }


            .btn {

                border: none;

                padding:
                    7px 10px;

                border-radius: 6px;

                font-size: 10px;

                font-weight: 700;

                cursor: pointer;

            }


            .btn-accept {

                background:
                    #198754;

                color: white;

            }


            .btn-reject {

                background:
                    #dc3545;

                color: white;

            }


            .btn-view {

                background:
                    #edf9fc;

                color:
                    #087eac;

            }


            /* =====================================================
               QUICK ACTIONS
               ===================================================== */

            .quick-actions {

                display: grid;

                gap: 10px;

            }


            .quick-action {

                display: flex;

                align-items: center;

                gap: 12px;

                padding: 13px;

                border:
                    1px solid #e8eef4;

                border-radius: 10px;

                color:
                    #334155;

                transition:
                    .2s;

            }


            .quick-action:hover {

                border-color:
                    #b7e8f4;

                background:
                    #f5fcfe;

            }


            .quick-action-icon {

                width: 36px;
                height: 36px;

                border-radius: 9px;

                background:
                    #eaf8fc;

                color:
                    #06a3da;

                display: flex;

                align-items: center;

                justify-content: center;

            }


            .quick-action-text strong {

                display: block;

                color:
                    #0b2447;

                font-size: 12px;

            }


            .quick-action-text span {

                display: block;

                color:
                    #94a3b8;

                font-size: 10px;

                margin-top: 2px;

            }


            /* =====================================================
               NOTIFICATIONS
               ===================================================== */

            .notification-item {

                padding:
                    13px 0;

                border-bottom:
                    1px solid #edf1f5;

            }


            .notification-item:last-child {

                border-bottom:
                    none;

            }


            .notification-title {

                color:
                    #0b2447;

                font-size: 12px;

                font-weight: 700;

                margin-bottom: 4px;

            }


            .notification-message {

                color:
                    #64748b;

                font-size: 11px;

                line-height: 1.5;

            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                text-align:
                    center;

                padding:
                    35px 10px;

                color:
                    #94a3b8;

            }


            .empty i {

                font-size: 30px;

                margin-bottom: 10px;

                color:
                    #cbd5e1;

            }


            .empty p {

                font-size: 12px;

            }


            /* =====================================================
               MOBILE
               ===================================================== */

            @media(max-width:1100px) {

                .stats {

                    grid-template-columns:
                        repeat(2, 1fr);

                }


                .dashboard-grid {

                    grid-template-columns:
                        1fr;

                }

            }


            @media(max-width:768px) {

                .sidebar {

                    width: 72px;

                    padding:
                        20px 9px;

                }


                .brand {

                    justify-content:
                        center;

                    padding:
                        5px 0 20px;

                }


                .brand-text,
                .menu-title,
                .nav-link span,
                .logout-text {

                    display:
                        none;

                }


                .nav-link {

                    justify-content:
                        center;

                    padding:
                        13px;

                }


                .notification-count {

                    position: absolute;

                    top: 3px;

                    right: 3px;

                    min-width: 16px;

                    height: 16px;

                    font-size: 8px;

                }


                .main {

                    margin-left: 72px;

                    width:
                        calc(100% - 72px);

                }


                .topbar {

                    padding:
                        0 18px;

                }


                .content {

                    padding:
                        18px;

                }


                .hero-content {

                    flex-direction:
                        column;

                    align-items:
                        flex-start;

                }


                .hero-button {

                    width:
                        100%;

                    text-align:
                        center;

                }

            }


            @media(max-width:520px) {

                .stats {

                    grid-template-columns:
                        1fr 1fr;

                    gap: 10px;

                }


                .stat-card {

                    padding: 14px;

                }


                .stat-number {

                    font-size: 22px;

                }


                .hero {

                    padding:
                        22px;

                }


                .hero h1 {

                    font-size: 23px;

                }


                .panel {

                    padding:
                        17px;

                }


                .profile-name,
                .profile-role {

                    display:
                        none;

                }


                .appointment-item {

                    align-items:
                        flex-start;

                }


                .appointment-right {

                    max-width:
                        130px;

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


                <div class="brand">

                    <div class="brand-icon">

                        <i class="fa-solid fa-tooth"></i>

                    </div>


                    <div class="brand-text">

                        Sunrise Dental

                        <span>
                            Doctor Portal
                        </span>

                    </div>

                </div>


                <div class="menu-title">
                    Doctor Menu
                </div>


                <a href="doctor-dashboard.jsp"
                   class="nav-link active">

                    <i class="fa-solid fa-chart-pie"></i>

                    <span>
                        Dashboard
                    </span>

                </a>


                <a href="DoctorAppointmentsServlet"
                   class="nav-link">

                    <i class="fa-solid fa-calendar-check"></i>

                    <span>
                        Appointments
                    </span>

                </a>


                <a href="DoctorNotificationsServlet"
                   class="nav-link notification-link">

                    <i class="fa-solid fa-bell"></i>

                    <span>
                        Notifications
                    </span>


                    <% if (unreadNotifications > 0) {%>

                    <span class="notification-count">

                        <%= unreadNotifications%>

                    </span>

                    <% }%>

                </a>


                <div class="logout-area">

                    <div class="logout">

                        <a href="LogoutServlet"
                           class="nav-link">

                            <i class="fa-solid fa-right-from-bracket"></i>

                            <span class="logout-text">
                                Logout
                            </span>

                        </a>

                    </div>

                </div>


            </aside>


            <!-- =====================================================
                 MAIN
                 ===================================================== -->

            <main class="main">


                <!-- TOPBAR -->

                <header class="topbar">


                    <div>

                        <div class="welcome-small">
                            Doctor Portal
                        </div>


                        <div class="welcome-title">

                            Welcome back, Dr.
                            <%= doctorName%> 👋

                        </div>

                    </div>


                    <div class="profile">


                        <div>

                            <div class="profile-name">

                                Dr.
                                <%= doctorName%>

                            </div>


                            <div class="profile-role">
                                Doctor
                            </div>

                        </div>


                        <div class="profile-avatar">

                            <i class="fa-solid fa-user-doctor"></i>

                        </div>


                    </div>


                </header>


                <!-- CONTENT -->

                <section class="content">


                    <!-- =================================================
                         HERO
                         ================================================= -->

                    <div class="hero">


                        <div class="hero-content">


                            <div>

                                <div class="hero-label">

                                    <i class="fa-solid fa-stethoscope"></i>

                                    Doctor Workspace

                                </div>


                                <h1>
                                    Good day, Dr. <%= doctorName%>.
                                </h1>


                                <p>
                                    Manage patient appointments,
                                    review requests and stay updated.
                                </p>

                            </div>


                            <a href="DoctorAppointmentsServlet"
                               class="hero-button">

                                <i class="fa-solid fa-calendar-check"></i>

                                &nbsp;

                                View Appointments

                            </a>


                        </div>


                    </div>


                    <!-- =================================================
                         STATISTICS
                         ================================================= -->

                    <div class="stats">


                        <!-- Total -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-calendar"></i>

                            </div>


                            <div class="stat-number">

                                <%= totalAppointments%>

                            </div>


                            <div class="stat-label">

                                Total Appointments

                            </div>

                        </div>


                        <!-- Pending -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-hourglass-half"></i>

                            </div>


                            <div class="stat-number">

                                <%= pendingRequests%>

                            </div>


                            <div class="stat-label">

                                Pending Requests

                            </div>

                        </div>


                        <!-- Confirmed -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-circle-check"></i>

                            </div>


                            <div class="stat-number">

                                <%= confirmedAppointments%>

                            </div>


                            <div class="stat-label">

                                Confirmed Appointments

                            </div>

                        </div>


                        <!-- Notifications -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-bell"></i>

                            </div>


                            <div class="stat-number">

                                <%= unreadNotifications%>

                            </div>


                            <div class="stat-label">

                                Unread Notifications

                            </div>

                        </div>


                    </div>


                    <!-- =================================================
                         MAIN GRID
                         ================================================= -->

                    <div class="dashboard-grid">


                        <!-- =================================================
                             LEFT
                             ================================================= -->

                        <div>


                            <!-- APPOINTMENT REQUESTS -->

                            <div class="panel">


                                <div class="panel-header">


                                    <div class="panel-title">

                                        <i class="fa-solid fa-calendar-check"
                                           style="color:#06a3da;">
                                        </i>

                                        &nbsp;

                                        Appointment Requests

                                    </div>


                                    <a href="DoctorAppointmentsServlet"
                                       class="view-all">

                                        View All

                                        <i class="fa-solid fa-arrow-right"></i>

                                    </a>


                                </div>


                                <%
                                    boolean hasPending
                                            = false;

                                    if (appointments != null) {

                                        for (Appointment appointment
                                                : appointments) {

                                            if (!"PENDING_DOCTOR"
                                                    .equals(
                                                            appointment.getStatus()
                                                    )) {

                                                continue;
                                            }

                                            hasPending = true;
                                %>


                                <div class="appointment-item">


                                    <div class="appointment-info">


                                        <div class="appointment-icon">

                                            <i class="fa-solid fa-user"></i>

                                        </div>


                                        <div>


                                            <div class="patient-name">

                                                <%= appointment.getPatientName()%>

                                            </div>


                                            <div class="patient-service">

                                                <%= appointment.getTreatmentType()%>

                                                &nbsp; • &nbsp;

                                                <%= appointment.getAppointmentNo()%>

                                            </div>


                                        </div>


                                    </div>


                                    <div class="appointment-right">


                                        <div class="appointment-date">

                                            <%= appointment.getAppointmentDate()%>

                                            <br>

                                            <%= appointment.getAppointmentTime()%>

                                        </div>


                                        <div class="actions">


                                            <form
                                                method="post"
                                                action="DoctorDecisionServlet"
                                                style="display:inline;">


                                                <input
                                                    type="hidden"
                                                    name="appointmentId"
                                                    value="<%= appointment.getId()%>">


                                                <button
                                                    type="submit"
                                                    name="decision"
                                                    value="accept"
                                                    class="btn btn-accept">

                                                    <i class="fa-solid fa-check"></i>

                                                    Accept

                                                </button>


                                            </form>


                                            <form
                                                method="post"
                                                action="DoctorDecisionServlet"
                                                style="display:inline;">


                                                <input
                                                    type="hidden"
                                                    name="appointmentId"
                                                    value="<%= appointment.getId()%>">


                                                <input
                                                    type="hidden"
                                                    name="note"
                                                    value="Doctor is not available.">


                                                <button
                                                    type="submit"
                                                    name="decision"
                                                    value="reject"
                                                    class="btn btn-reject">

                                                    <i class="fa-solid fa-xmark"></i>

                                                    Reject

                                                </button>


                                            </form>


                                        </div>


                                    </div>


                                </div>


                                <%
                                        }
                                    }

                                    if (!hasPending) {
                                %>


                                <div class="empty">

                                    <i class="fa-regular fa-calendar-check"></i>

                                    <p>
                                        No pending appointment requests.
                                    </p>

                                </div>


                                <%
                                    }
                                %>


                            </div>


                            <!-- ALL APPOINTMENTS -->

                            <div class="panel">


                                <div class="panel-header">


                                    <div class="panel-title">

                                        Recent Appointments

                                    </div>


                                    <a href="DoctorAppointmentsServlet"
                                       class="view-all">

                                        View All

                                    </a>


                                </div>


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
                                                    = "status-pending";

                                            String statusText
                                                    = "Pending";

                                            if ("CONFIRMED"
                                                    .equals(status)) {

                                                statusClass
                                                        = "status-confirmed";

                                                statusText
                                                        = "Confirmed";

                                            } else if (status != null
                                                    && status.startsWith(
                                                            "REJECTED"
                                                    )) {

                                                statusClass
                                                        = "status-rejected";

                                                statusText
                                                        = "Rejected";
                                            }

                                %>


                                <div class="appointment-item">


                                    <div class="appointment-info">


                                        <div class="appointment-icon">

                                            <i class="fa-solid fa-tooth"></i>

                                        </div>


                                        <div>

                                            <div class="patient-name">

                                                <%= appointment.getPatientName()%>

                                            </div>


                                            <div class="patient-service">

                                                <%= appointment.getTreatmentType()%>

                                            </div>

                                        </div>


                                    </div>


                                    <div class="appointment-right">


                                        <div class="appointment-date">

                                            <%= appointment.getAppointmentDate()%>

                                            <br>

                                            <%= appointment.getAppointmentTime()%>

                                        </div>


                                        <span class="status <%= statusClass%>">

                                            <%= statusText%>

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


                        <!-- =================================================
                             RIGHT
                             ================================================= -->

                        <div>


                            <!-- QUICK ACTIONS -->

                            <div class="panel">


                                <div class="panel-header">

                                    <div class="panel-title">

                                        Doctor Tools

                                    </div>

                                </div>


                                <div class="quick-actions">


                                    <a href="DoctorAppointmentsServlet"
                                       class="quick-action">


                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-calendar-check"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Manage Appointments
                                            </strong>

                                            <span>
                                                Review and respond to requests
                                            </span>

                                        </div>


                                    </a>


                                    <a href="DoctorNotificationsServlet"
                                       class="quick-action">


                                        <div class="quick-action-icon">

                                            <i class="fa-solid fa-bell"></i>

                                        </div>


                                        <div class="quick-action-text">

                                            <strong>
                                                Notifications
                                            </strong>

                                            <span>
                                                View your latest updates
                                            </span>

                                        </div>


                                    </a>


                                </div>


                            </div>


                            <!-- NOTIFICATIONS -->

                            <div class="panel">


                                <div class="panel-header">


                                    <div class="panel-title">

                                        Latest Notifications

                                    </div>


                                    <a href="DoctorNotificationsServlet"
                                       class="view-all">

                                        View All

                                    </a>


                                </div>


                                <% if (notifications != null
                                    && !notifications.isEmpty()) { %>


                                <%
                                    int notificationCount = 0;

                                    for (String[] n
                                            : notifications) {

                                        if (notificationCount >= 4) {
                                            break;
                                        }

                                        notificationCount++;
                                %>


                                <div class="notification-item">


                                    <div class="notification-title">

                                        <i class="fa-solid fa-bell"
                                           style="color:#06a3da;">
                                        </i>

                                        &nbsp;

                                        <%= n[1]%>

                                    </div>


                                    <div class="notification-message">

                                        <%= n[2]%>

                                    </div>


                                </div>


                                <%
                                    }
                                %>


                                <% } else { %>


                                <div class="empty">

                                    <i class="fa-regular fa-bell-slash"></i>

                                    <p>
                                        No notifications yet.
                                    </p>

                                </div>


                                <% }%>


                            </div>


                        </div>


                    </div>


                </section>


            </main>


        </div>


    </body>

</html>