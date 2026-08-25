<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String role
            = (String) session.getAttribute("userRole");

    if (!"doctor".equalsIgnoreCase(role)) {
        response.sendRedirect(
                "Login.jsp?error=access"
        );
        return;
    }

    String userName
            = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "Doctor";
    }

    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute("appointments");
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Doctor Appointments | Sunrise Dental Clinic</title>

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
                color: #555;
            }

            .layout {
                min-height: 100vh;
                display: flex;
            }

            .sidebar {
                width: 250px;
                position: fixed;
                inset: 0 auto 0 0;
                background: #091e3e;
                color: white;
                padding: 25px 18px;
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
                border-radius: 8px;
                margin-bottom: 6px;
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
                font: 700 25px Jost, sans-serif;
                color: #091e3e;
            }

            .user {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .user small {
                display: block;
                color: #7b8794;
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

            .page-title {
                margin-bottom: 25px;
            }

            .page-title h1 {
                font: 700 30px Jost, sans-serif;
                color: #091e3e;
            }

            .page-title p {
                margin-top: 5px;
                color: #7b8794;
            }

            .card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.05);
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                min-width: 950px;
            }

            th {
                background: #091e3e;
                color: white;
                padding: 14px;
                text-align: left;
                font-size: 14px;
            }

            td {
                padding: 15px 14px;
                border-bottom: 1px solid #edf1f5;
                vertical-align: middle;
            }

            tr:hover td {
                background: #f8fbfd;
            }

            .status {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .pending {
                background: #fff4d6;
                color: #9a6a00;
            }

            .accepted {
                background: #e4f8ed;
                color: #16834b;
            }

            .rejected {
                background: #ffe7e7;
                color: #c62828;
            }

            .admin {
                background: #e6f0ff;
                color: #1769aa;
            }

            .action-form {
                display: flex;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }

            .note {
                padding: 8px 10px;
                border: 1px solid #dce3ea;
                border-radius: 6px;
                width: 180px;
                outline: none;
            }

            .btn {
                border: none;
                border-radius: 6px;
                padding: 9px 13px;
                cursor: pointer;
                color: white;
                font-weight: 600;
            }

            .btn-accept {
                background: #198754;
            }

            .btn-reject {
                background: #dc3545;
            }

            .btn:hover {
                opacity: 0.9;
            }

            .empty {
                text-align: center;
                padding: 50px;
                color: #888;
            }

        </style>

    </head>

    <body>

        <div class="layout">

            <aside class="sidebar">

                <div class="brand">
                    <i class="fa-solid fa-tooth"></i>
                    Sunrise Dental
                </div>

                <div class="menu">

                    <a href="doctor-dashboard.jsp">
                        <i class="fa-solid fa-house"></i>
                        Dashboard
                    </a>

                    <a href="DoctorAppointmentsServlet"
                       class="active">
                        <i class="fa-solid fa-calendar-check"></i>
                        Appointments
                    </a>

                    <a href="DoctorNotificationsServlet">
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


            <main class="main">

                <div class="topbar">

                    <h2>Doctor Appointments</h2>

                    <div class="user">

                        <div>
                            <strong><%= userName%></strong>
                            <small>Doctor</small>
                        </div>

                        <div class="avatar">
                            <i class="fa-solid fa-user-doctor"></i>
                        </div>

                    </div>

                </div>


                <div class="content">

                    <div class="page-title">

                        <h1>Appointment Requests</h1>

                        <p>
                            Review and manage your patient appointment requests.
                        </p>

                    </div>


                    <div class="card">

                        <% if (appointments == null
                            || appointments.isEmpty()) { %>

                        <div class="empty">

                            <i class="fa-regular fa-calendar-xmark"
                               style="font-size:45px;margin-bottom:15px;">
                            </i>

                            <h3>No appointments found</h3>

                            <p>
                                There are currently no appointment requests.
                            </p>

                        </div>

                        <% } else { %>

                        <table>

                            <thead>

                                <tr>

                                    <th>Appointment No</th>

                                    <th>Patient</th>

                                    <th>Phone</th>

                                    <th>Treatment</th>

                                    <th>Date</th>

                                    <th>Time</th>

                                    <th>Status</th>

                                    <th>Action</th>

                                </tr>

                            </thead>

                            <tbody>

                                <% for (Appointment a : appointments) {%>

                                <tr>

                                    <td>
                                        <strong>
                                            <%= a.getAppointmentNo()%>
                                        </strong>
                                    </td>

                                    <td>
                                        <%= a.getPatientName()%>
                                    </td>

                                    <td>
                                        <%= a.getPatientPhone()%>
                                    </td>

                                    <td>
                                        <%= a.getTreatmentType()%>
                                    </td>

                                    <td>
                                        <%= a.getAppointmentDate()%>
                                    </td>

                                    <td>
                                        <%= a.getAppointmentTime()%>
                                    </td>

                                    <td>

                                        <%
                                            String status
                                                    = a.getStatus();

                                            String statusClass
                                                    = "pending";

                                            if ("PENDING_ADMIN"
                                                    .equals(status)) {
                                                statusClass = "admin";
                                            } else if ("CONFIRMED"
                                                    .equals(status)) {
                                                statusClass = "accepted";
                                            } else if (status != null
                                                    && status.startsWith(
                                                            "REJECTED")) {
                                                statusClass = "rejected";
                                            }
                                        %>

                                        <span class="status <%= statusClass%>">
                                            <%= status.replace("_", " ")%>
                                        </span>

                                    </td>

                                    <td>

                                        <% if ("PENDING_DOCTOR"
                                                .equals(a.getStatus())) {%>

                                        <form
                                            method="post"
                                            action="DoctorDecisionServlet"
                                            class="action-form">

                                            <input
                                                type="hidden"
                                                name="appointmentId"
                                                value="<%= a.getId()%>">

                                            <input
                                                type="text"
                                                name="note"
                                                class="note"
                                                placeholder="Note (optional)">

                                            <button
                                                type="submit"
                                                name="decision"
                                                value="accept"
                                                class="btn btn-accept">

                                                <i class="fa-solid fa-check"></i>
                                                Accept

                                            </button>

                                            <button
                                                type="submit"
                                                name="decision"
                                                value="reject"
                                                class="btn btn-reject">

                                                <i class="fa-solid fa-xmark"></i>
                                                Reject

                                            </button>

                                        </form>

                                        <% } else { %>

                                        <span style="color:#888;">
                                            No action required
                                        </span>

                                        <% } %>

                                    </td>

                                </tr>

                                <% } %>

                            </tbody>

                        </table>

                        <% }%>

                    </div>

                </div>

            </main>

        </div>

    </body>

</html>