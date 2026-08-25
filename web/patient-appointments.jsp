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

    if (!"patient".equalsIgnoreCase(role)) {
        response.sendRedirect(
                "Login.jsp?error=access"
        );
        return;
    }

    String userName
            = (String) session.getAttribute("userName");

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Patient";
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

        <title>My Appointments | Sunrise Dental Clinic</title>

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

            /* SIDEBAR */

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

            /* MAIN */

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

            /* CONTENT */

            .content {
                padding: 32px;
            }

            .page-title {
                font: 700 28px Jost, sans-serif;
                color: #091e3e;
                margin-bottom: 6px;
            }

            .page-description {
                color: #7b8794;
                margin-bottom: 25px;
            }

            /* APPOINTMENT CARD */

            .appointment-card {
                background: white;
                border: 1px solid #e5ebf0;
                border-radius: 12px;
                padding: 24px;
                margin-bottom: 18px;
            }

            .appointment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .appointment-number {
                font: 700 19px Jost, sans-serif;
                color: #091e3e;
            }

            .status {
                padding: 7px 13px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
            }

            /* STATUS COLORS */

            .pending-doctor {
                background: #fff7d6;
                color: #9a6700;
            }

            .pending-admin {
                background: #e8f4ff;
                color: #075985;
            }

            .confirmed {
                background: #dcfce7;
                color: #166534;
            }

            .rejected-doctor,
            .rejected-admin {
                background: #fee2e2;
                color: #991b1b;
            }

            .details {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .detail {
                padding: 13px;
                background: #f8fafc;
                border-radius: 8px;
            }

            .detail label {
                display: block;
                color: #7b8794;
                font-size: 12px;
                margin-bottom: 5px;
            }

            .detail strong {
                color: #091e3e;
            }

            /* EMPTY */

            .empty {
                background: white;
                border: 1px solid #e5ebf0;
                border-radius: 12px;
                padding: 50px 20px;
                text-align: center;
            }

            .empty i {
                font-size: 45px;
                color: #06a3da;
                margin-bottom: 15px;
            }

            .empty h3 {
                color: #091e3e;
                font: 700 21px Jost, sans-serif;
                margin-bottom: 8px;
            }

            .empty p {
                color: #7b8794;
                margin-bottom: 20px;
            }

            .book-btn {
                display: inline-block;
                background: #06a3da;
                color: white;
                padding: 12px 18px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
            }

            .book-btn:hover {
                background: #0589b8;
            }

            /* MOBILE */

            @media(max-width:800px) {

                .sidebar {
                    width: 70px;
                    padding: 20px 10px;
                }

                .brand span,
                .menu span,
                .logout span {
                    display: none;
                }

                .main {
                    margin-left: 70px;
                    width: calc(100% - 70px);
                }

                .details {
                    grid-template-columns: 1fr;
                }

                .content {
                    padding: 20px;
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

                    <span>
                        Sunrise Dental
                    </span>

                </div>


                <nav class="menu">

                    <a href="patient-dashboard.jsp">

                        <i class="fa-solid fa-gauge"></i>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <a href="BookAppointmentServlet">

                        <i class="fa-solid fa-calendar-plus"></i>

                        <span>
                            Book Appointment
                        </span>

                    </a>


                    <a class="active"
                       href="PatientAppointmentsServlet">

                        <i class="fa-solid fa-calendar-check"></i>

                        <span>
                            My Appointments
                        </span>

                    </a>


                    <a href="PatientNotificationsServlet">

                        <i class="fa-solid fa-bell"></i>

                        <span>
                            Notifications
                        </span>

                    </a>

                </nav>


                <div class="logout">

                    <a href="LogoutServlet">

                        <i class="fa-solid fa-right-from-bracket"></i>

                        <span>
                            Logout
                        </span>

                    </a>

                </div>

            </aside>


            <!-- MAIN -->

            <main class="main">


                <header class="topbar">

                    <h2>
                        My Appointments
                    </h2>


                    <div class="user">

                        <div class="avatar">

                            <i class="fa-solid fa-user"></i>

                        </div>


                        <div>

                            <strong>
                                <%=userName%>
                            </strong>

                            <small>
                                Patient
                            </small>

                        </div>

                    </div>

                </header>


                <section class="content">

                    <h1 class="page-title">
                        My Appointments
                    </h1>

                    <p class="page-description">
                        View the status of your appointment requests.
                    </p>


                    <%
                        if (appointments == null
                                || appointments.isEmpty()) {
                    %>

                    <div class="empty">

                        <i class="fa-solid fa-calendar-xmark"></i>

                        <h3>
                            No Appointments Yet
                        </h3>

                        <p>
                            You have not booked any appointments yet.
                        </p>

                        <a class="book-btn"
                           href="BookAppointmentServlet">

                            <i class="fa-solid fa-calendar-plus"></i>

                            Book Appointment

                        </a>

                    </div>

                    <%
                    } else {

                        for (Appointment a : appointments) {

                            String status
                                    = a.getStatus();

                            String statusClass
                                    = "pending-doctor";

                            String statusText
                                    = "Waiting for Doctor";

                            if ("PENDING_ADMIN".equals(status)) {

                                statusClass = "pending-admin";
                                statusText = "Waiting for Admin";

                            } else if ("CONFIRMED".equals(status)) {

                                statusClass = "confirmed";
                                statusText = "Confirmed";

                            } else if ("REJECTED_BY_DOCTOR"
                                    .equals(status)) {

                                statusClass = "rejected-doctor";
                                statusText = "Rejected by Doctor";

                            } else if ("REJECTED_BY_ADMIN"
                                    .equals(status)) {

                                statusClass = "rejected-admin";
                                statusText = "Rejected by Admin";
                            }
                    %>


                    <div class="appointment-card">


                        <div class="appointment-header">

                            <div class="appointment-number">

                                <i class="fa-solid fa-calendar-check"></i>

                                <%=a.getAppointmentNo()%>

                            </div>


                            <div class="status <%=statusClass%>">

                                <%=statusText%>

                            </div>

                        </div>


                        <div class="details">


                            <div class="detail">

                                <label>
                                    Doctor
                                </label>

                                <strong>

                                    Dr. <%=a.getDoctorName()%>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Specialization
                                </label>

                                <strong>

                                    <%=a.getSpecialization()%>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Treatment
                                </label>

                                <strong>

                                    <%=a.getTreatmentType()%>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Date
                                </label>

                                <strong>

                                    <%=a.getAppointmentDate()%>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Time
                                </label>

                                <strong>

                                    <%=a.getAppointmentTime()%>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Doctor Note
                                </label>

                                <strong>

                                    <%
                                        if (a.getDoctorNote() == null
                                                || a.getDoctorNote().trim().isEmpty()) {
                                    %>

                                    -

                                    <%
                                    } else {
                                    %>

                                    <%=a.getDoctorNote()%>

                                    <%
                                        }
                                    %>

                                </strong>

                            </div>


                            <div class="detail">

                                <label>
                                    Admin Note
                                </label>

                                <strong>

                                    <%
                                        if (a.getAdminNote() == null
                                                || a.getAdminNote().trim().isEmpty()) {
                                    %>

                                    -

                                    <%
                                    } else {
                                    %>

                                    <%=a.getAdminNote()%>

                                    <%
                                        }
                                    %>

                                </strong>

                            </div>


                        </div>

                    </div>


                    <%
                            }
                        }
                    %>


                </section>

            </main>

        </div>

    </body>

</html>