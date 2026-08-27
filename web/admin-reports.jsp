<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>

<%@page import="model.ReportSummary"%>
<%@page import="model.ReportItem"%>


<%
    /*
     * =========================================================
     * ADMIN SECURITY
     * =========================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp"
        );

        return;
    }

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
     * =========================================================
     * REPORT DATA
     * =========================================================
     */
    ReportSummary appointmentSummary
            = (ReportSummary) request.getAttribute(
                    "appointmentSummary"
            );

    ReportSummary revenueSummary
            = (ReportSummary) request.getAttribute(
                    "revenueSummary"
            );

    ReportSummary treatmentSummary
            = (ReportSummary) request.getAttribute(
                    "treatmentSummary"
            );

    List<ReportItem> monthlyRevenue
            = (List<ReportItem>) request.getAttribute(
                    "monthlyRevenue"
            );

    List<ReportItem> treatmentPerformance
            = (List<ReportItem>) request.getAttribute(
                    "treatmentPerformance"
            );

    List<ReportItem> doctorAppointments
            = (List<ReportItem>) request.getAttribute(
                    "doctorAppointments"
            );


    /*
     * =========================================================
     * SAFE DEFAULTS
     * =========================================================
     */
    if (appointmentSummary == null) {

        appointmentSummary
                = new ReportSummary();
    }

    if (revenueSummary == null) {

        revenueSummary
                = new ReportSummary();
    }

    if (treatmentSummary == null) {

        treatmentSummary
                = new ReportSummary();
    }

    if (monthlyRevenue == null) {

        monthlyRevenue
                = new java.util.ArrayList<>();
    }

    if (treatmentPerformance == null) {

        treatmentPerformance
                = new java.util.ArrayList<>();
    }

    if (doctorAppointments == null) {

        doctorAppointments
                = new java.util.ArrayList<>();
    }


    /*
     * =========================================================
     * ADMIN NAME
     * =========================================================
     */
    String adminName
            = (String) session.getAttribute(
                    "userName"
            );

    if (adminName == null
            || adminName.trim().isEmpty()) {

        adminName
                = "Administrator";
    }

%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">


        <title>
            Reports & Analytics | Sunrise Dental Clinic
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
                text-decoration:
                    none;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                position:
                    fixed;

                top: 0;
                bottom: 0;
                left: 0;

                width:
                    255px;

                background:
                    linear-gradient(
                    180deg,
                    #071d3a 0%,
                    #0b2b50 100%
                    );

                color:
                    white;

                padding:
                    25px 16px;

                z-index:
                    1000;
            }


            .brand {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    12px;

                padding:
                    8px 12px 30px;

                border-bottom:
                    1px solid
                    rgba(255,255,255,.08);

                margin-bottom:
                    22px;
            }


            .brand-icon {

                width:
                    42px;

                height:
                    42px;

                border-radius:
                    12px;

                background:
                    #06a3da;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    20px;
            }


            .brand-text {

                font-family:
                    "Jost",
                    sans-serif;

                font-size:
                    19px;

                font-weight:
                    700;
            }


            .brand-text span {

                display:
                    block;

                font-size:
                    11px;

                color:
                    #94a9bf;

                font-weight:
                    400;

                margin-top:
                    2px;
            }


            .menu-title {

                font-size:
                    10px;

                color:
                    #7890a9;

                text-transform:
                    uppercase;

                letter-spacing:
                    1.3px;

                padding:
                    0 12px 10px;
            }


            .nav-link {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    13px;

                color:
                    #bdcbd9;

                padding:
                    13px 14px;

                margin-bottom:
                    5px;

                border-radius:
                    9px;

                font-size:
                    14px;
            }


            .nav-link i {

                width:
                    19px;

                text-align:
                    center;
            }


            .nav-link:hover,
            .nav-link.active {

                background:
                    #06a3da;

                color:
                    white;
            }


            .logout-area {

                position:
                    absolute;

                left:
                    16px;

                right:
                    16px;

                bottom:
                    20px;
            }


            .logout {

                border-top:
                    1px solid
                    rgba(255,255,255,.08);

                padding-top:
                    15px;
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left:
                    255px;

                min-height:
                    100vh;
            }


            /* =====================================================
               TOPBAR
               ===================================================== */

            .topbar {

                height:
                    76px;

                background:
                    white;

                border-bottom:
                    1px solid #e7edf3;

                padding:
                    0 32px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;
            }


            .welcome-small {

                font-size:
                    12px;

                color:
                    #94a3b8;
            }


            .welcome-title {

                font-family:
                    "Jost",
                    sans-serif;

                color:
                    #0b2447;

                font-size:
                    21px;

                font-weight:
                    700;
            }


            .profile {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    11px;
            }


            .profile-avatar {

                width:
                    42px;

                height:
                    42px;

                border-radius:
                    50%;

                background:
                    #e6f7fc;

                color:
                    #06a3da;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;
            }


            .profile-name {

                color:
                    #0b2447;

                font-size:
                    13px;

                font-weight:
                    600;
            }


            .profile-role {

                color:
                    #94a3b8;

                font-size:
                    11px;
            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding:
                    30px;
            }


            .page-header {

                margin-bottom:
                    25px;
            }


            .page-header h1 {

                color:
                    #0b2447;

                font-family:
                    "Jost",
                    sans-serif;

                font-size:
                    28px;

                font-weight:
                    700;
            }


            .page-header p {

                color:
                    #94a3b8;

                font-size:
                    12px;

                margin-top:
                    5px;
            }


            /* =====================================================
               STAT CARDS
               ===================================================== */

            .stats {

                display:
                    grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap:
                    18px;

                margin-bottom:
                    25px;
            }


            .stat-card {

                background:
                    white;

                border:
                    1px solid #e7edf3;

                border-radius:
                    12px;

                padding:
                    20px;

                box-shadow:
                    0 4px 15px
                    rgba(15,23,42,.04);
            }


            .stat-top {

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;
            }


            .stat-icon {

                width:
                    42px;

                height:
                    42px;

                border-radius:
                    10px;

                background:
                    #e8f7fc;

                color:
                    #06a3da;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;
            }


            .stat-label {

                margin-top:
                    15px;

                color:
                    #94a3b8;

                font-size:
                    11px;
            }


            .stat-value {

                color:
                    #0b2447;

                font:
                    700 25px Jost,
                    sans-serif;

                margin-top:
                    2px;
            }


            /* =====================================================
               PANELS
               ===================================================== */

            .panel-grid {

                display:
                    grid;

                grid-template-columns:
                    2fr 1fr;

                gap:
                    20px;

                margin-bottom:
                    20px;
            }


            .panel {

                background:
                    white;

                border:
                    1px solid #e7edf3;

                border-radius:
                    12px;

                padding:
                    22px;

                box-shadow:
                    0 4px 15px
                    rgba(15,23,42,.04);
            }


            .panel-title {

                color:
                    #0b2447;

                font:
                    700 17px Jost,
                    sans-serif;

                margin-bottom:
                    20px;
            }


            .panel-title i {

                color:
                    #06a3da;

                margin-right:
                    7px;
            }


            /* =====================================================
               APPOINTMENT STATUS
               ===================================================== */

            .status-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    12px;
            }


            .status-box {

                background:
                    #f8fafc;

                border:
                    1px solid #edf1f5;

                padding:
                    14px;

                border-radius:
                    8px;
            }


            .status-box span {

                display:
                    block;

                font-size:
                    10px;

                color:
                    #94a3b8;

                margin-bottom:
                    4px;
            }


            .status-box strong {

                color:
                    #0b2447;

                font:
                    700 20px Jost,
                    sans-serif;
            }


            /* =====================================================
               BARS
               ===================================================== */

            .bar-row {

                margin-bottom:
                    17px;
            }


            .bar-header {

                display:
                    flex;

                justify-content:
                    space-between;

                margin-bottom:
                    6px;

                font-size:
                    11px;
            }


            .bar-label {

                color:
                    #475569;

                font-weight:
                    600;
            }


            .bar-value {

                color:
                    #06a3da;

                font-weight:
                    700;
            }


            .bar-track {

                height:
                    9px;

                background:
                    #edf3f7;

                border-radius:
                    20px;

                overflow:
                    hidden;
            }


            .bar-fill {

                height:
                    100%;

                background:
                    #06a3da;

                border-radius:
                    20px;

                min-width:
                    3px;
            }


            /* =====================================================
               TABLE
               ===================================================== */

            .table-wrapper {

                overflow-x:
                    auto;
            }


            table {

                width:
                    100%;

                border-collapse:
                    collapse;
            }


            th {

                background:
                    #f8fafc;

                color:
                    #64748b;

                font-size:
                    10px;

                text-transform:
                    uppercase;

                letter-spacing:
                    .4px;

                text-align:
                    left;

                padding:
                    12px;
            }


            td {

                padding:
                    13px 12px;

                border-bottom:
                    1px solid #edf1f5;

                color:
                    #475569;

                font-size:
                    11px;
            }


            td strong {

                color:
                    #0b2447;
            }


            .money {

                color:
                    #0b8f5b;

                font-weight:
                    700;
            }


            .empty {

                text-align:
                    center;

                color:
                    #94a3b8;

                padding:
                    25px;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width: 1100px) {

                .stats {

                    grid-template-columns:
                        repeat(2, 1fr);
                }

                .panel-grid {

                    grid-template-columns:
                        1fr;
                }
            }


            @media(max-width: 750px) {

                .sidebar {

                    position:
                        relative;

                    width:
                        100%;

                    height:
                        auto;
                }

                .main {

                    margin-left:
                        0;
                }

                .logout-area {

                    position:
                        relative;

                    left:
                        auto;

                    right:
                        auto;

                    bottom:
                        auto;

                    margin-top:
                        20px;
                }

                .stats {

                    grid-template-columns:
                        1fr;
                }

                .topbar {

                    padding:
                        0 15px;
                }

                .content {

                    padding:
                        20px 15px;
                }
            }

        </style>

    </head>


    <body>


        <!-- =========================================================
             SIDEBAR
             ========================================================= -->

        <aside class="sidebar">


            <div class="brand">

                <div class="brand-icon">

                    <i class="fa-solid fa-tooth"></i>

                </div>


                <div class="brand-text">

                    Sunrise Dental

                    <span>
                        Clinic Management
                    </span>

                </div>

            </div>


            <div class="menu-title">
                Main Menu
            </div>


            <a
                href="<%=request.getContextPath()%>/admin-dashboard.jsp"
                class="nav-link">

                <i class="fa-solid fa-chart-pie"></i>

                Dashboard

            </a>


            <a
                href="<%=request.getContextPath()%>/AdminAppointmentsServlet"
                class="nav-link">

                <i class="fa-solid fa-calendar-check"></i>

                Appointments

            </a>


            <!-- ACTIVE REPORTS LINK -->

            <a
                href="<%=request.getContextPath()%>/AdminReportsServlet"
                class="nav-link active">

                <i class="fa-solid fa-chart-line"></i>

                Reports & Analytics

            </a>


            <a
                href="<%=request.getContextPath()%>/AdminNotificationsServlet"
                class="nav-link">

                <i class="fa-solid fa-bell"></i>

                Notifications

            </a>


            <div class="menu-title"
                 style="margin-top:25px;">

                Account

            </div>


            <a
                href="<%=request.getContextPath()%>/LogoutServlet"
                class="nav-link">

                <i class="fa-solid fa-right-from-bracket"></i>

                Logout

            </a>


        </aside>



        <!-- =========================================================
             MAIN
             ========================================================= -->

        <main class="main">


            <!-- TOPBAR -->

            <header class="topbar">


                <div>

                    <div class="welcome-small">
                        Welcome back
                    </div>

                    <div class="welcome-title">
                        Reports & Analytics
                    </div>

                </div>


                <div class="profile">


                    <div class="profile-avatar">

                        <i class="fa-solid fa-user-shield"></i>

                    </div>


                    <div>

                        <div class="profile-name">

                            <%=adminName%>

                        </div>

                        <div class="profile-role">

                            Administrator

                        </div>

                    </div>


                </div>


            </header>



            <!-- CONTENT -->

            <section class="content">


                <div class="page-header">

                    <h1>
                        Dashboard Reports & Analytics
                    </h1>

                    <p>
                        Monitor appointments, revenue, treatments and
                        doctor performance from one dashboard.
                    </p>

                </div>



                <!-- =================================================
                     MAIN STATISTICS
                     ================================================= -->

                <div class="stats">


                    <!-- APPOINTMENTS -->

                    <div class="stat-card">


                        <div class="stat-top">

                            <div>
                                <div class="stat-label">
                                    Total Appointments
                                </div>

                                <div class="stat-value">

                                    <%=appointmentSummary
                                    .getTotalAppointments()%>

                                </div>
                            </div>


                            <div class="stat-icon">

                                <i class="fa-solid fa-calendar-check"></i>

                            </div>

                        </div>


                    </div>



                    <!-- CONFIRMED -->

                    <div class="stat-card">


                        <div class="stat-top">

                            <div>

                                <div class="stat-label">
                                    Confirmed Appointments
                                </div>

                                <div class="stat-value">

                                    <%=appointmentSummary
                                    .getConfirmedAppointments()%>

                                </div>

                            </div>


                            <div class="stat-icon">

                                <i class="fa-solid fa-circle-check"></i>

                            </div>

                        </div>


                    </div>



                    <!-- REVENUE -->

                    <div class="stat-card">


                        <div class="stat-top">

                            <div>

                                <div class="stat-label">
                                    Total Paid Revenue
                                </div>

                                <div class="stat-value">

                                    Rs.
                                    <%=String.format(
                                            "%,.2f",
                                            revenueSummary
                                                    .getTotalRevenue()
                                    )%>

                                </div>

                            </div>


                            <div class="stat-icon">

                                <i class="fa-solid fa-money-bill-wave"></i>

                            </div>

                        </div>


                    </div>



                    <!-- TREATMENTS -->

                    <div class="stat-card">


                        <div class="stat-top">

                            <div>

                                <div class="stat-label">
                                    Active Treatments
                                </div>

                                <div class="stat-value">

                                    <%=treatmentSummary
                                    .getTotalTreatments()%>

                                </div>

                            </div>


                            <div class="stat-icon">

                                <i class="fa-solid fa-tooth"></i>

                            </div>

                        </div>


                    </div>


                </div>



                <!-- =================================================
                     APPOINTMENT + REVENUE
                     ================================================= -->

                <div class="panel-grid">


                    <!-- APPOINTMENT STATUS -->

                    <div class="panel">


                        <div class="panel-title">

                            <i class="fa-solid fa-calendar-days"></i>

                            Appointment Overview

                        </div>


                        <div class="status-grid">


                            <div class="status-box">

                                <span>
                                    Total
                                </span>

                                <strong>
                                    <%=appointmentSummary
                                    .getTotalAppointments()%>
                                </strong>

                            </div>


                            <div class="status-box">

                                <span>
                                    Confirmed
                                </span>

                                <strong>
                                    <%=appointmentSummary
                                    .getConfirmedAppointments()%>
                                </strong>

                            </div>


                            <div class="status-box">

                                <span>
                                    Pending
                                </span>

                                <strong>
                                    <%=appointmentSummary
                                    .getPendingAppointments()%>
                                </strong>

                            </div>


                            <div class="status-box">

                                <span>
                                    Rejected
                                </span>

                                <strong>
                                    <%=appointmentSummary
                                    .getRejectedAppointments()%>
                                </strong>

                            </div>


                            <div class="status-box">

                                <span>
                                    Cancelled
                                </span>

                                <strong>
                                    <%=appointmentSummary
                                    .getCancelledAppointments()%>
                                </strong>

                            </div>


                        </div>


                    </div>



                    <!-- REVENUE -->

                    <div class="panel">


                        <div class="panel-title">

                            <i class="fa-solid fa-wallet"></i>

                            Revenue Summary

                        </div>


                        <div class="stat-label">

                            Paid revenue

                        </div>


                        <div
                            style="
                            font:700 30px Jost;
                            color:#0b2447;
                            margin-top:7px;
                            ">

                            Rs.
                            <%=String.format(
                                    "%,.2f",
                                    revenueSummary
                                            .getTotalRevenue()
                            )%>

                        </div>


                        <div
                            style="
                            margin-top:15px;
                            color:#94a3b8;
                            font-size:11px;
                            ">

                            Revenue is calculated from
                            paid bills.

                        </div>


                    </div>


                </div>



                <!-- =================================================
                     MONTHLY REVENUE
                     ================================================= -->

                <div class="panel"
                     style="margin-bottom:20px;">


                    <div class="panel-title">

                        <i class="fa-solid fa-chart-column"></i>

                        Monthly Revenue
                        -
                        <%=java.time.Year.now().getValue()%>

                    </div>


                    <%
                        double maxRevenue = 0;

                        for (ReportItem item
                                : monthlyRevenue) {

                            if (item.getValue()
                                    > maxRevenue) {

                                maxRevenue
                                        = item.getValue();
                            }
                        }

                        if (monthlyRevenue.isEmpty()) {
                    %>


                    <div class="empty">

                        No revenue data available
                        for this year.

                    </div>


                    <%
                    } else {

                        for (ReportItem item
                                : monthlyRevenue) {

                            double width = 0;

                            if (maxRevenue > 0) {

                                width
                                        = (item.getValue()
                                        / maxRevenue)
                                        * 100;
                            }
                    %>


                    <div class="bar-row">


                        <div class="bar-header">

                            <span class="bar-label">

                                <%=item.getLabel()%>

                            </span>


                            <span class="bar-value">

                                Rs.
                                <%=String.format(
                                        "%,.2f",
                                        item.getValue()
                                )%>

                            </span>

                        </div>


                        <div class="bar-track">

                            <div
                                class="bar-fill"
                                style="width:<%=width%>%;">
                            </div>

                        </div>


                    </div>


                    <%
                            }
                        }
                    %>


                </div>



                <!-- =================================================
                     TREATMENT + DOCTOR
                     ================================================= -->

                <div class="panel-grid">


                    <!-- TREATMENTS -->

                    <div class="panel">


                        <div class="panel-title">

                            <i class="fa-solid fa-tooth"></i>

                            Treatment Performance

                        </div>


                        <%
                            int maxTreatment = 0;

                            for (ReportItem item
                                    : treatmentPerformance) {

                                if (item.getCount()
                                        > maxTreatment) {

                                    maxTreatment
                                            = item.getCount();
                                }
                            }

                            if (treatmentPerformance.isEmpty()) {
                        %>


                        <div class="empty">

                            No treatment data available.

                        </div>


                        <%
                        } else {

                            for (ReportItem item
                                    : treatmentPerformance) {

                                double width = 0;

                                if (maxTreatment > 0) {

                                    width
                                            = ((double) item.getCount()
                                            / maxTreatment)
                                            * 100;
                                }
                        %>


                        <div class="bar-row">


                            <div class="bar-header">

                                <span class="bar-label">

                                    <%=item.getLabel()%>

                                </span>


                                <span class="bar-value">

                                    <%=item.getCount()%>

                                </span>

                            </div>


                            <div class="bar-track">

                                <div
                                    class="bar-fill"
                                    style="width:<%=width%>%;">
                                </div>

                            </div>


                        </div>


                        <%
                                }
                            }
                        %>


                    </div>



                    <!-- DOCTORS -->

                    <div class="panel">


                        <div class="panel-title">

                            <i class="fa-solid fa-user-doctor"></i>

                            Doctor Appointments

                        </div>


                        <%
                            int maxDoctor = 0;

                            for (ReportItem item
                                    : doctorAppointments) {

                                if (item.getCount()
                                        > maxDoctor) {

                                    maxDoctor
                                            = item.getCount();
                                }
                            }

                            if (doctorAppointments.isEmpty()) {
                        %>


                        <div class="empty">

                            No doctor data available.

                        </div>


                        <%
                        } else {

                            for (ReportItem item
                                    : doctorAppointments) {

                                double width = 0;

                                if (maxDoctor > 0) {

                                    width
                                            = ((double) item.getCount()
                                            / maxDoctor)
                                            * 100;
                                }
                        %>


                        <div class="bar-row">


                            <div class="bar-header">

                                <span class="bar-label">

                                    <%=item.getLabel()%>

                                </span>


                                <span class="bar-value">

                                    <%=item.getCount()%>

                                </span>

                            </div>


                            <div class="bar-track">

                                <div
                                    class="bar-fill"
                                    style="width:<%=width%>%;">
                                </div>

                            </div>


                        </div>


                        <%
                                }
                            }
                        %>


                    </div>


                </div>



                <!-- =================================================
                     TREATMENT TABLE
                     ================================================= -->

                <div class="panel">


                    <div class="panel-title">

                        <i class="fa-solid fa-list-check"></i>

                        Treatment Appointment Details

                    </div>


                    <div class="table-wrapper">


                        <table>


                            <thead>

                                <tr>

                                    <th>
                                        Treatment
                                    </th>

                                    <th>
                                        Appointments
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                                <%
                                    if (treatmentPerformance.isEmpty()) {
                                %>


                                <tr>

                                    <td
                                        colspan="2"
                                        class="empty">

                                        No treatment records found.

                                    </td>

                                </tr>


                                <%
                                } else {

                                    for (ReportItem item
                                            : treatmentPerformance) {
                                %>


                                <tr>

                                    <td>

                                        <strong>
                                            <%=item.getLabel()%>
                                        </strong>

                                    </td>


                                    <td>

                                        <%=item.getCount()%>

                                    </td>

                                </tr>


                                <%
                                        }
                                    }
                                %>


                            </tbody>


                        </table>


                    </div>


                </div>


            </section>


        </main>


    </body>

</html>