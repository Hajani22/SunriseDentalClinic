<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.DoctorOption"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"admin".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }

    String userName
            = (String) session.getAttribute(
                    "userName"
            );

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Administrator";
    }

    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute(
                    "appointments"
            );

    List<DoctorOption> doctors
            = (List<DoctorOption>) request.getAttribute(
                    "doctors"
            );

    String selectedDoctor
            = (String) request.getAttribute(
                    "selectedDoctor"
            );

    String selectedDate
            = (String) request.getAttribute(
                    "selectedDate"
            );

    String selectedStatus
            = (String) request.getAttribute(
                    "selectedStatus"
            );

    if (selectedStatus == null
            || selectedStatus.trim().isEmpty()) {

        selectedStatus = "ALL";
    }
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Appointment Management | Sunrise Dental Clinic
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
                font-family: "Open Sans", sans-serif;
                background: #f4f8fb;
                color: #475569;
            }

            .layout {
                min-height: 100vh;
                display: flex;
            }

            .sidebar {
                width: 250px;
                position: fixed;
                inset: 0 auto 0 0;
                background: linear-gradient(
                    180deg,
                    #071d3a,
                    #0b2b50
                    );
                color: white;
                padding: 25px 18px;
                z-index: 100;
            }

            .brand {
                font: 700 21px Jost, sans-serif;
                margin: 10px 8px 35px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .brand i {
                background: #06a3da;
                padding: 12px;
                border-radius: 10px;
            }

            .menu a {
                display: flex;
                gap: 12px;
                padding: 13px 14px;
                color: #c7d2e0;
                text-decoration: none;
                border-radius: 9px;
                margin-bottom: 6px;
                transition: .2s;
            }

            .menu a:hover,
            .menu a.active {
                background: #06a3da;
                color: white;
            }

            .menu i {
                width: 18px;
            }

            .logout {
                position: absolute;
                bottom: 25px;
                left: 18px;
                right: 18px;
            }

            .logout a {
                color: #ffb4b4;
                text-decoration: none;
                display: block;
                padding: 12px;
            }

            .main {
                margin-left: 250px;
                width: calc(100% - 250px);
            }

            .topbar {
                height: 72px;
                background: white;
                border-bottom: 1px solid #e5ebf0;
                padding: 0 32px;

                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .topbar h2 {
                font: 700 24px Jost, sans-serif;
                color: #091e3e;
            }

            .admin-user {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .avatar {
                width: 42px;
                height: 42px;
                border-radius: 50%;
                background: #e7f7fc;
                color: #06a3da;
                display: grid;
                place-items: center;
            }

            .content {
                padding: 30px;
            }

            .page-heading {
                margin-bottom: 25px;
            }

            .page-heading h1 {
                font: 700 32px Jost, sans-serif;
                color: #091e3e;
            }

            .page-heading p {
                color: #7b8794;
                margin-top: 5px;
            }

            /* FILTER CARD */

            .filter-card {
                background: white;
                border-radius: 16px;
                padding: 22px;
                margin-bottom: 25px;

                box-shadow:
                    0 8px 25px rgba(15, 23, 42, .06);

                border: 1px solid #edf2f7;
            }

            .filter-title {
                font: 700 18px Jost, sans-serif;
                color: #091e3e;
                margin-bottom: 18px;
            }

            .filter-grid {
                display: grid;
                grid-template-columns:
                    1fr 1fr 1fr auto auto;

                gap: 14px;
                align-items: end;
            }

            .field label {
                display: block;
                font-size: 12px;
                font-weight: 700;
                color: #64748b;
                margin-bottom: 7px;
            }

            .field select,
            .field input {
                width: 100%;
                height: 44px;
                border: 1px solid #dbe3eb;
                border-radius: 9px;
                padding: 0 12px;
                outline: none;
                background: white;
                color: #334155;
            }

            .field select:focus,
            .field input:focus {
                border-color: #06a3da;
                box-shadow: 0 0 0 3px rgba(6,163,218,.10);
            }

            .filter-btn,
            .reset-btn {
                height: 44px;
                border: 0;
                border-radius: 9px;
                padding: 0 18px;
                cursor: pointer;
                font-weight: 700;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .filter-btn {
                background: #06a3da;
                color: white;
            }

            .filter-btn:hover {
                background: #078dbd;
            }

            .reset-btn {
                background: #eef2f6;
                color: #475569;
            }

            .reset-btn:hover {
                background: #e2e8f0;
            }

            /* SUMMARY */

            .summary {
                display: grid;
                grid-template-columns:
                    repeat(4, 1fr);

                gap: 16px;
                margin-bottom: 25px;
            }

            .summary-card {
                background: white;
                padding: 20px;
                border-radius: 14px;
                border: 1px solid #edf2f7;
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .summary-icon {
                width: 46px;
                height: 46px;
                border-radius: 12px;
                background: #e8f7fc;
                color: #06a3da;
                display: grid;
                place-items: center;
            }

            .summary-number {
                font: 700 24px Jost, sans-serif;
                color: #091e3e;
            }

            .summary-label {
                font-size: 12px;
                color: #7b8794;
            }

            /* TABLE */

            .table-card {
                background: white;
                border-radius: 16px;
                border: 1px solid #edf2f7;

                box-shadow:
                    0 8px 25px rgba(15,23,42,.06);

                overflow: hidden;
            }

            .table-header {
                padding: 20px 22px;
                border-bottom: 1px solid #edf2f7;

                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .table-header h2 {
                font: 700 20px Jost, sans-serif;
                color: #091e3e;
            }

            .table-header span {
                font-size: 13px;
                color: #7b8794;
            }

            .table-wrapper {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                min-width: 1200px;
            }

            th {
                background: #091e3e;
                color: white;
                padding: 14px 16px;
                text-align: left;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: .4px;
            }

            td {
                padding: 15px 16px;
                border-bottom: 1px solid #edf1f5;
                vertical-align: middle;
                font-size: 13px;
            }

            tbody tr:hover td {
                background: #f8fbfd;
            }

            .today-row td {
                background: #f0fbff;
            }

            .today-badge {
                display: inline-block;
                margin-top: 4px;
                padding: 3px 7px;
                border-radius: 20px;
                background: #06a3da;
                color: white;
                font-size: 10px;
                font-weight: 700;
            }

            .appointment-no {
                font-weight: 700;
                color: #06a3da;
            }

            .patient-name {
                font-weight: 700;
                color: #1e293b;
            }

            .doctor-name {
                font-weight: 600;
                color: #334155;
            }

            .specialization {
                font-size: 11px;
                color: #94a3b8;
                margin-top: 3px;
            }

            .status {
                display: inline-block;
                padding: 6px 11px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
                white-space: nowrap;
            }

            .pending-doctor {
                background: #fff4d6;
                color: #946200;
            }

            .pending-admin {
                background: #e6f0ff;
                color: #1769aa;
            }

            .confirmed {
                background: #e4f8ed;
                color: #16834b;
            }

            .rejected {
                background: #ffe7e7;
                color: #c62828;
            }

            .action-area {
                display: flex;
                flex-direction: column;
                gap: 7px;
            }

            .note {
                width: 170px;
                height: 34px;
                border: 1px solid #dce3ea;
                border-radius: 7px;
                padding: 0 9px;
                outline: none;
                font-size: 12px;
            }

            .action-buttons {
                display: flex;
                gap: 5px;
            }

            .action-btn {
                border: 0;
                border-radius: 7px;
                padding: 7px 10px;
                cursor: pointer;
                color: white;
                font-size: 11px;
                font-weight: 700;
            }

            .confirm {
                background: #198754;
            }

            .reject {
                background: #dc3545;
            }

            .disabled {
                color: #94a3b8;
                font-size: 12px;
            }

            .empty {
                text-align: center;
                padding: 65px 20px;
                color: #94a3b8;
            }

            .empty i {
                font-size: 45px;
                margin-bottom: 15px;
                color: #cbd5e1;
            }

            .empty h3 {
                color: #475569;
                margin-bottom: 5px;
            }

            @media(max-width:1000px) {

                .filter-grid {
                    grid-template-columns: 1fr 1fr;
                }

                .summary {
                    grid-template-columns: 1fr 1fr;
                }
            }

            @media(max-width:700px) {

                .sidebar {
                    width: 70px;
                    padding: 20px 8px;
                }

                .brand {
                    justify-content: center;
                    font-size: 0;
                }

                .brand i {
                    font-size: 18px;
                }

                .menu a {
                    justify-content: center;
                }

                .menu a:not(.active) {
                    font-size: 0;
                }

                .menu a i {
                    font-size: 16px;
                }

                .main {
                    margin-left: 70px;
                    width: calc(100% - 70px);
                }

                .content {
                    padding: 18px;
                }

                .filter-grid {
                    grid-template-columns: 1fr;
                }

                .summary {
                    grid-template-columns: 1fr;
                }

                .topbar {
                    padding: 0 18px;
                }
            }

        </style>

    </head>

    <body>

        <div class="layout">

            <!-- SIDEBAR -->

            <aside class="sidebar">

                <div class="brand">

                    <i class="fa-solid fa-tooth"></i>

                    Sunrise Dental

                </div>

                <div class="menu">

                    <a href="admin-dashboard.jsp">

                        <i class="fa-solid fa-house"></i>

                        Dashboard

                    </a>

                    <a href="AdminAppointmentsServlet"
                       class="active">

                        <i class="fa-solid fa-calendar-check"></i>

                        Appointments

                    </a>

                    <a href="AdminNotificationsServlet">

                        <i class="fa-solid fa-bell"></i>

                        Notifications

                    </a>

                </div>

                <div class="logout">

                    <a href="LogoutServlet">

                        <i class="fa-solid fa-right-from-bracket"></i>

                        Logout

                    </a>

                </div>

            </aside>


            <!-- MAIN -->

            <main class="main">

                <header class="topbar">

                    <h2>

                        <i class="fa-solid fa-calendar-check"></i>

                        Appointment Management

                    </h2>

                    <div class="admin-user">

                        <div>

                            <strong>
                                <%= userName%>
                            </strong>

                            <small>
                                Administrator
                            </small>

                        </div>

                        <div class="avatar">

                            <i class="fa-solid fa-user-shield"></i>

                        </div>

                    </div>

                </header>


                <section class="content">


                    <div class="page-heading">

                        <h1>
                            Appointment Management
                        </h1>

                        <p>
                            Review appointments by doctor, date and status.
                            Confirm doctor-approved appointments from one place.
                        </p>

                    </div>


                    <!-- FILTER -->

                    <div class="filter-card">

                        <div class="filter-title">

                            <i class="fa-solid fa-filter"></i>

                            Appointment Filters

                        </div>

                        <form
                            method="get"
                            action="AdminAppointmentsServlet">

                            <div class="filter-grid">


                                <!-- DOCTOR -->

                                <div class="field">

                                    <label>
                                        Doctor
                                    </label>

                                    <select name="doctor">

                                        <option value="all">
                                            All Doctors
                                        </option>

                                        <%
                                            if (doctors != null) {

                                                for (DoctorOption doctor
                                                        : doctors) {

                                                    String id
                                                            = String.valueOf(
                                                                    doctor.getId()
                                                            );

                                                    boolean selected
                                                            = id.equals(
                                                                    selectedDoctor
                                                            );
                                        %>

                                        <option
                                            value="<%= id%>"
                                            <%= selected
                                                    ? "selected"
                                                    : ""%>>

                                            <%= doctor.getName()%>

                                        </option>

                                        <%
                                                }
                                            }
                                        %>

                                    </select>

                                </div>


                                <!-- DATE -->

                                <div class="field">

                                    <label>
                                        Appointment Date
                                    </label>

                                    <input
                                        type="date"
                                        name="date"
                                        value="<%= selectedDate == null
                                                ? ""
                                                : selectedDate%>">

                                </div>


                                <!-- STATUS -->

                                <div class="field">

                                    <label>
                                        Status
                                    </label>

                                    <select name="status">

                                        <option
                                            value="ALL"
                                            <%= "ALL".equals(selectedStatus)
                                                    ? "selected"
                                                    : ""%>>
                                            All Status
                                        </option>

                                        <option
                                            value="PENDING_DOCTOR"
                                            <%= "PENDING_DOCTOR".equals(
                                                    selectedStatus)
                                                            ? "selected"
                                                            : ""%>>
                                            Waiting for Doctor
                                        </option>

                                        <option
                                            value="PENDING_ADMIN"
                                            <%= "PENDING_ADMIN".equals(
                                                    selectedStatus)
                                                            ? "selected"
                                                            : ""%>>
                                            Waiting for Admin
                                        </option>

                                        <option
                                            value="CONFIRMED"
                                            <%= "CONFIRMED".equals(
                                                    selectedStatus)
                                                            ? "selected"
                                                            : ""%>>
                                            Confirmed
                                        </option>

                                        <option
                                            value="REJECTED_BY_DOCTOR"
                                            <%= "REJECTED_BY_DOCTOR".equals(
                                                    selectedStatus)
                                                            ? "selected"
                                                            : ""%>>
                                            Rejected by Doctor
                                        </option>

                                        <option
                                            value="REJECTED_BY_ADMIN"
                                            <%= "REJECTED_BY_ADMIN".equals(
                                                    selectedStatus)
                                                            ? "selected"
                                                            : ""%>>
                                            Rejected by Admin
                                        </option>

                                    </select>

                                </div>


                                <button
                                    type="submit"
                                    class="filter-btn">

                                    <i class="fa-solid fa-magnifying-glass"></i>

                                    Filter

                                </button>


                                <a
                                    href="AdminAppointmentsServlet"
                                    class="reset-btn">

                                    <i class="fa-solid fa-rotate-left"></i>

                                    Reset

                                </a>

                            </div>

                        </form>

                    </div>


                    <!-- SUMMARY -->

                    <%
                        int total = 0;
                        int pendingAdmin = 0;
                        int confirmed = 0;
                        int rejected = 0;

                        if (appointments != null) {

                            total = appointments.size();

                            for (Appointment a : appointments) {

                                if ("PENDING_ADMIN".equals(
                                        a.getStatus())) {

                                    pendingAdmin++;

                                } else if ("CONFIRMED".equals(
                                        a.getStatus())) {

                                    confirmed++;

                                } else if (a.getStatus() != null
                                        && a.getStatus().startsWith(
                                                "REJECTED")) {

                                    rejected++;
                                }
                            }
                        }
                    %>

                    <div class="summary">

                        <div class="summary-card">

                            <div class="summary-icon">
                                <i class="fa-solid fa-calendar-days"></i>
                            </div>

                            <div>

                                <div class="summary-number">
                                    <%= total%>
                                </div>

                                <div class="summary-label">
                                    Filtered Appointments
                                </div>

                            </div>

                        </div>


                        <div class="summary-card">

                            <div class="summary-icon">
                                <i class="fa-solid fa-hourglass-half"></i>
                            </div>

                            <div>

                                <div class="summary-number">
                                    <%= pendingAdmin%>
                                </div>

                                <div class="summary-label">
                                    Waiting for Admin
                                </div>

                            </div>

                        </div>


                        <div class="summary-card">

                            <div class="summary-icon">
                                <i class="fa-solid fa-circle-check"></i>
                            </div>

                            <div>

                                <div class="summary-number">
                                    <%= confirmed%>
                                </div>

                                <div class="summary-label">
                                    Confirmed
                                </div>

                            </div>

                        </div>


                        <div class="summary-card">

                            <div class="summary-icon">
                                <i class="fa-solid fa-circle-xmark"></i>
                            </div>

                            <div>

                                <div class="summary-number">
                                    <%= rejected%>
                                </div>

                                <div class="summary-label">
                                    Rejected
                                </div>

                            </div>

                        </div>

                    </div>


                    <!-- TABLE -->

                    <div class="table-card">

                        <div class="table-header">

                            <div>

                                <h2>
                                    Appointment Records
                                </h2>

                                <span>
                                    Doctor-wise and date-wise appointment overview
                                </span>

                            </div>

                            <span>
                                <i class="fa-solid fa-database"></i>
                                Database Records
                            </span>

                        </div>


                        <div class="table-wrapper">

                            <%
                                if (appointments == null
                                        || appointments.isEmpty()) {
                            %>

                            <div class="empty">

                                <i class="fa-regular fa-calendar-xmark"></i>

                                <h3>
                                    No appointments found
                                </h3>

                                <p>
                                    Try changing the doctor, date or status filter.
                                </p>

                            </div>

                            <%
                            } else {
                            %>

                            <table>

                                <thead>

                                    <tr>

                                        <th>Appointment</th>
                                        <th>Patient</th>
                                        <th>Doctor</th>
                                        <th>Treatment</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Status</th>
                                        <th>Admin Action</th>

                                    </tr>

                                </thead>

                                <tbody>

                                    <%
                                        java.time.LocalDate today
                                                = java.time.LocalDate.now();

                                        for (Appointment a
                                                : appointments) {

                                            boolean isToday = false;

                                            try {

                                                isToday
                                                        = today.toString()
                                                                .equals(
                                                                        a.getAppointmentDate()
                                                                );

                                            } catch (Exception ignored) {
                                            }

                                            String statusClass
                                                    = "pending-admin";

                                            String statusText
                                                    = "Pending Admin";

                                            if ("PENDING_DOCTOR".equals(
                                                    a.getStatus())) {

                                                statusClass
                                                        = "pending-doctor";

                                                statusText
                                                        = "Pending Doctor";

                                            } else if ("CONFIRMED".equals(
                                                    a.getStatus())) {

                                                statusClass
                                                        = "confirmed";

                                                statusText
                                                        = "Confirmed";

                                            } else if (a.getStatus() != null
                                                    && a.getStatus().startsWith(
                                                            "REJECTED")) {

                                                statusClass
                                                        = "rejected";

                                                statusText
                                                        = a.getStatus()
                                                                .replace(
                                                                        "_",
                                                                        " "
                                                                );
                                            }
                                    %>

                                    <tr class="<%= isToday
                                            ? "today-row"
                                            : ""%>">

                                        <td>

                                            <div class="appointment-no">

                                                <%= a.getAppointmentNo()%>

                                            </div>

                                        </td>


                                        <td>

                                            <div class="patient-name">

                                                <%= a.getPatientName()%>

                                            </div>

                                            <div>
                                                <%= a.getPatientPhone()%>
                                            </div>

                                        </td>


                                        <td>

                                            <div class="doctor-name">

                                                Dr.
                                                <%= a.getDoctorName()%>

                                            </div>

                                            <div class="specialization">

                                                <%= a.getSpecialization()%>

                                            </div>

                                        </td>


                                        <td>

                                            <%= a.getTreatmentType()%>

                                        </td>


                                        <td>

                                            <%= a.getAppointmentDate()%>

                                            <%
                                                if (isToday) {
                                            %>

                                            <div class="today-badge">
                                                TODAY
                                            </div>

                                            <%
                                                }
                                            %>

                                        </td>


                                        <td>

                                            <strong>
                                                <%= a.getAppointmentTime()%>
                                            </strong>

                                        </td>


                                        <td>

                                            <span
                                                class="status <%= statusClass%>">

                                                <%= statusText%>

                                            </span>

                                        </td>


                                        <td>

                                            <%
                                                if ("PENDING_ADMIN".equals(
                                                        a.getStatus())) {
                                            %>

                                            <div class="action-area">

                                                <form
                                                    method="post"
                                                    action="AdminDecisionServlet">

                                                    <input
                                                        type="hidden"
                                                        name="appointmentId"
                                                        value="<%= a.getId()%>">

                                                    <input
                                                        type="text"
                                                        name="note"
                                                        class="note"
                                                        placeholder="Admin note">

                                                    <div class="action-buttons">

                                                        <button
                                                            type="submit"
                                                            name="decision"
                                                            value="confirm"
                                                            class="action-btn confirm">

                                                            <i class="fa-solid fa-check"></i>
                                                            Confirm

                                                        </button>

                                                        <button
                                                            type="submit"
                                                            name="decision"
                                                            value="reject"
                                                            class="action-btn reject">

                                                            <i class="fa-solid fa-xmark"></i>
                                                            Reject

                                                        </button>

                                                    </div>

                                                </form>

                                            </div>

                                            <%
                                            } else {
                                            %>

                                            <span class="disabled">

                                                No admin action required

                                            </span>

                                            <%
                                                }
                                            %>

                                        </td>

                                    </tr>

                                    <%
                                        }
                                    %>

                                </tbody>

                            </table>

                            <%
                                }
                            %>

                        </div>

                    </div>

                </section>

            </main>

        </div>

    </body>

</html>