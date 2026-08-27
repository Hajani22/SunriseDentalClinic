<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * PATIENT LOGIN CHECK
     * =========================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }

    String role
            = (String) session.getAttribute(
                    "userRole"
            );

    if (!"patient".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /*
     * =========================================================
     * PATIENT NAME
     * =========================================================
     */
    String userName
            = (String) session.getAttribute(
                    "userName"
            );

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Patient";
    }


    /*
     * =========================================================
     * APPOINTMENTS
     * =========================================================
     */
    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute(
                    "appointments"
            );


    /*
     * =========================================================
     * SUCCESS / ERROR MESSAGES
     * =========================================================
     */
    String success
            = request.getParameter(
                    "success"
            );

    String error
            = request.getParameter(
                    "error"
            );
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">


        <meta name="viewport"
              content="width=device-width,
              initial-scale=1.0">


        <title>
            My Appointments | Sunrise Dental Clinic
        </title>


        <!-- GOOGLE FONT -->

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <!-- FONT AWESOME -->

        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /*
             * =====================================================
             * GLOBAL
             * =====================================================
             */

            * {

                box-sizing:
                    border-box;

                margin:
                    0;

                padding:
                    0;
            }


            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f4f8fb;

                color:
                    #555;
            }


            /*
             * =====================================================
             * LAYOUT
             * =====================================================
             */

            .layout {

                min-height:
                    100vh;

                display:
                    flex;
            }


            /*
             * =====================================================
             * SIDEBAR
             * =====================================================
             */

            .sidebar {

                width:
                    250px;

                position:
                    fixed;

                inset:
                    0 auto 0 0;

                background:
                    #091e3e;

                color:
                    white;

                padding:
                    25px 18px;
            }


            .brand {

                font:
                    700 21px Jost,
                    sans-serif;

                margin:
                    10px 8px 35px;

                display:
                    flex;

                gap:
                    10px;

                align-items:
                    center;
            }


            .brand i {

                background:
                    #06a3da;

                padding:
                    12px;

                border-radius:
                    10px;
            }


            .menu a {

                display:
                    flex;

                gap:
                    12px;

                padding:
                    13px 14px;

                color:
                    #c7d2e0;

                text-decoration:
                    none;

                border-radius:
                    8px;

                margin-bottom:
                    6px;

                transition:
                    .2s;
            }


            .menu a:hover,
            .menu a.active {

                background:
                    #06a3da;

                color:
                    white;
            }


            .menu i {

                width:
                    18px;
            }


            .logout {

                position:
                    absolute;

                bottom:
                    25px;

                left:
                    18px;

                right:
                    18px;
            }


            .logout a {

                color:
                    #ffb4b4;

                text-decoration:
                    none;

                display:
                    block;

                padding:
                    12px;

                border-radius:
                    8px;

                transition:
                    .2s;
            }


            .logout a:hover {

                background:
                    rgba(255,255,255,.08);
            }


            /*
             * =====================================================
             * MAIN
             * =====================================================
             */

            .main {

                margin-left:
                    250px;

                width:
                    calc(100% - 250px);
            }


            /*
             * =====================================================
             * TOP BAR
             * =====================================================
             */

            .topbar {

                height:
                    72px;

                background:
                    white;

                border-bottom:
                    1px solid #e5ebf0;

                padding:
                    0 32px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;
            }


            .topbar h2 {

                font:
                    700 25px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .user {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;
            }


            .user small {

                display:
                    block;

                color:
                    #7b8794;
            }


            .avatar {

                width:
                    42px;

                height:
                    42px;

                border-radius:
                    50%;

                background:
                    #e7f7fc;

                color:
                    #06a3da;

                display:
                    grid;

                place-items:
                    center;
            }


            /*
             * =====================================================
             * CONTENT
             * =====================================================
             */

            .content {

                padding:
                    32px;
            }


            .page-title {

                font:
                    700 28px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    6px;
            }


            .page-description {

                color:
                    #7b8794;

                margin-bottom:
                    25px;
            }


            /*
             * =====================================================
             * SUCCESS / ERROR MESSAGES
             * =====================================================
             */

            .message {

                padding:
                    14px 17px;

                border-radius:
                    9px;

                margin-bottom:
                    20px;

                font-size:
                    14px;

                font-weight:
                    600;
            }


            .success-message {

                background:
                    #dcfce7;

                color:
                    #166534;

                border:
                    1px solid #bbf7d0;
            }


            .error-message {

                background:
                    #fee2e2;

                color:
                    #991b1b;

                border:
                    1px solid #fecaca;
            }


            /*
             * =====================================================
             * APPOINTMENT CARD
             * =====================================================
             */

            .appointment-card {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    12px;

                padding:
                    24px;

                margin-bottom:
                    18px;

                box-shadow:
                    0 4px 14px
                    rgba(15,23,42,.03);
            }


            .appointment-header {

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

                gap:
                    15px;

                margin-bottom:
                    20px;
            }


            .appointment-number {

                font:
                    700 19px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .appointment-number i {

                color:
                    #06a3da;

                margin-right:
                    6px;
            }


            /*
             * =====================================================
             * STATUS
             * =====================================================
             */

            .status {

                padding:
                    7px 13px;

                border-radius:
                    20px;

                font-size:
                    12px;

                font-weight:
                    700;

                white-space:
                    nowrap;
            }


            .pending-doctor {

                background:
                    #fff7d6;

                color:
                    #9a6700;
            }


            .pending-admin {

                background:
                    #e8f4ff;

                color:
                    #075985;
            }


            .confirmed {

                background:
                    #dcfce7;

                color:
                    #166534;
            }


            .rejected-doctor,
            .rejected-admin {

                background:
                    #fee2e2;

                color:
                    #991b1b;
            }


            .cancelled {

                background:
                    #fee2e2;

                color:
                    #991b1b;
            }


            /*
             * =====================================================
             * APPOINTMENT DETAILS
             * =====================================================
             */

            .details {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    15px;
            }


            .detail {

                padding:
                    13px;

                background:
                    #f8fafc;

                border-radius:
                    8px;
            }


            .detail label {

                display:
                    block;

                color:
                    #7b8794;

                font-size:
                    12px;

                margin-bottom:
                    5px;
            }


            .detail strong {

                color:
                    #091e3e;

                word-break:
                    break-word;
            }


            /*
             * =====================================================
             * APPOINTMENT ACTIONS
             * =====================================================
             */

            .actions {

                display:
                    flex;

                gap:
                    10px;

                flex-wrap:
                    wrap;

                margin-top:
                    20px;

                padding-top:
                    18px;

                border-top:
                    1px solid #e5ebf0;
            }


            .action-btn {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    7px;

                padding:
                    10px 15px;

                border-radius:
                    8px;

                border:
                    0;

                text-decoration:
                    none;

                font-size:
                    13px;

                font-weight:
                    700;

                cursor:
                    pointer;

                transition:
                    .2s;
            }


            .reschedule-btn {

                background:
                    #06a3da;

                color:
                    white;
            }


            .reschedule-btn:hover {

                background:
                    #0589b8;
            }


            .cancel-btn {

                background:
                    #dc2626;

                color:
                    white;
            }


            .cancel-btn:hover {

                background:
                    #b91c1c;
            }


            /*
             * =====================================================
             * CANCELLATION REASON
             * =====================================================
             */

            .cancellation-box {

                margin-top:
                    15px;

                padding:
                    14px;

                border-radius:
                    8px;

                background:
                    #fff7f7;

                border:
                    1px solid #fecaca;
            }


            .cancellation-box label {

                display:
                    block;

                color:
                    #991b1b;

                font-size:
                    12px;

                font-weight:
                    700;

                margin-bottom:
                    5px;
            }


            .cancellation-box strong {

                color:
                    #7f1d1d;

                font-size:
                    14px;
            }


            /*
             * =====================================================
             * EMPTY
             * =====================================================
             */

            .empty {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    12px;

                padding:
                    50px 20px;

                text-align:
                    center;
            }


            .empty i {

                font-size:
                    45px;

                color:
                    #06a3da;

                margin-bottom:
                    15px;
            }


            .empty h3 {

                color:
                    #091e3e;

                font:
                    700 21px Jost,
                    sans-serif;

                margin-bottom:
                    8px;
            }


            .empty p {

                color:
                    #7b8794;

                margin-bottom:
                    20px;
            }


            .book-btn {

                display:
                    inline-block;

                background:
                    #06a3da;

                color:
                    white;

                padding:
                    12px 18px;

                border-radius:
                    8px;

                text-decoration:
                    none;

                font-weight:
                    600;
            }


            .book-btn:hover {

                background:
                    #0589b8;
            }


            /*
             * =====================================================
             * CANCEL MODAL
             * =====================================================
             */

            .modal {

                display:
                    none;

                position:
                    fixed;

                inset:
                    0;

                background:
                    rgba(0,0,0,.55);

                z-index:
                    9999;

                align-items:
                    center;

                justify-content:
                    center;

                padding:
                    20px;
            }


            .modal-card {

                width:
                    min(500px, 100%);

                background:
                    white;

                border-radius:
                    14px;

                padding:
                    26px;

                box-shadow:
                    0 15px 45px
                    rgba(0,0,0,.18);
            }


            .modal-card h2 {

                font:
                    700 23px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    8px;
            }


            .modal-card p {

                color:
                    #6b7280;

                margin-bottom:
                    18px;

                line-height:
                    1.6;
            }


            .modal-card label {

                display:
                    block;

                font-weight:
                    700;

                color:
                    #091e3e;

                margin-bottom:
                    7px;
            }


            .modal-card textarea {

                width:
                    100%;

                min-height:
                    110px;

                resize:
                    vertical;

                border:
                    1px solid #d8e1e8;

                border-radius:
                    8px;

                padding:
                    11px;

                font:
                    14px "Open Sans",
                    sans-serif;

                outline:
                    none;
            }


            .modal-card textarea:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px
                    rgba(6,163,218,.1);
            }


            .modal-actions {

                display:
                    flex;

                justify-content:
                    flex-end;

                gap:
                    10px;

                margin-top:
                    18px;
            }


            .modal-actions button {

                border:
                    0;

                padding:
                    10px 16px;

                border-radius:
                    8px;

                cursor:
                    pointer;

                font-weight:
                    700;
            }


            .keep-btn {

                background:
                    #e8eef3;

                color:
                    #334155;
            }


            .keep-btn:hover {

                background:
                    #dce5ec;
            }


            .confirm-cancel-btn {

                background:
                    #dc2626;

                color:
                    white;
            }


            .confirm-cancel-btn:hover {

                background:
                    #b91c1c;
            }


            /*
             * =====================================================
             * MOBILE
             * =====================================================
             */

            @media(max-width:800px) {

                .sidebar {

                    width:
                        70px;

                    padding:
                        20px 10px;
                }


                .brand span,
                .menu span,
                .logout span {

                    display:
                        none;
                }


                .brand {

                    justify-content:
                        center;

                    margin-left:
                        0;

                    margin-right:
                        0;
                }


                .menu a {

                    justify-content:
                        center;

                    padding:
                        13px 8px;
                }


                .menu i {

                    width:
                        auto;
                }


                .logout {

                    left:
                        10px;

                    right:
                        10px;
                }


                .logout a {

                    text-align:
                        center;
                }


                .main {

                    margin-left:
                        70px;

                    width:
                        calc(100% - 70px);
                }


                .topbar {

                    padding:
                        0 20px;
                }


                .topbar h2 {

                    font-size:
                        21px;
                }


                .user strong {

                    font-size:
                        13px;
                }


                .user small {

                    font-size:
                        11px;
                }


                .content {

                    padding:
                        20px;
                }


                .details {

                    grid-template-columns:
                        1fr;
                }


                .appointment-header {

                    align-items:
                        flex-start;

                    flex-direction:
                        column;
                }


                .status {

                    align-self:
                        flex-start;
                }


                .actions {

                    flex-direction:
                        column;
                }


                .action-btn {

                    width:
                        100%;
                }
            }


            /*
             * =====================================================
             * SMALL MOBILE
             * =====================================================
             */

            @media(max-width:500px) {

                .sidebar {

                    width:
                        60px;
                }


                .main {

                    margin-left:
                        60px;

                    width:
                        calc(100% - 60px);
                }


                .content {

                    padding:
                        15px;
                }


                .topbar {

                    height:
                        65px;

                    padding:
                        0 15px;
                }


                .topbar h2 {

                    font-size:
                        18px;
                }


                .avatar {

                    width:
                        36px;

                    height:
                        36px;
                }


                .appointment-card {

                    padding:
                        17px;
                }


                .page-title {

                    font-size:
                        24px;
                }
            }

        </style>

    </head>


    <body>


        <div class="layout">


            <!-- =====================================================
                 SIDEBAR
                 ===================================================== -->

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


            <!-- =====================================================
                 MAIN
                 ===================================================== -->

            <main class="main">


                <!-- =================================================
                     TOPBAR
                     ================================================= -->

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


                <!-- =================================================
                     CONTENT
                     ================================================= -->

                <section class="content">


                    <h1 class="page-title">

                        My Appointments

                    </h1>


                    <p class="page-description">

                        View, reschedule or cancel your
                        dental appointments.

                    </p>


                    <!-- =================================================
                         SUCCESS / ERROR MESSAGE
                         ================================================= -->


                    <% if ("rescheduled".equals(success)) { %>


                    <div class="message success-message">

                        <i class="fa-solid fa-circle-check"></i>

                        Appointment rescheduled successfully.
                        It is now waiting for doctor approval.

                    </div>


                    <% } else if ("cancelled".equals(success)) { %>


                    <div class="message success-message">

                        <i class="fa-solid fa-circle-check"></i>

                        Appointment cancelled successfully.

                    </div>


                    <% } else if ("slot".equals(error)) { %>


                    <div class="message error-message">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        The selected appointment slot is not
                        available. Please choose another date
                        or time.

                    </div>


                    <% } else if ("cancel".equals(error)) { %>


                    <div class="message error-message">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        This appointment could not be cancelled.
                        It may no longer be active.

                    </div>


                    <% } else if ("invalid".equals(error)) { %>


                    <div class="message error-message">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        Invalid appointment request.

                    </div>


                    <% } else if ("server".equals(error)) { %>


                    <div class="message error-message">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        A system error occurred.
                        Please try again.

                    </div>


                    <% } %>


                    <!-- =================================================
                         APPOINTMENT LIST
                         ================================================= -->


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

                            You have not booked any
                            appointments yet.

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

                            if ("PENDING_ADMIN"
                                    .equals(status)) {

                                statusClass
                                        = "pending-admin";

                                statusText
                                        = "Waiting for Admin";

                            } else if ("CONFIRMED"
                                    .equals(status)) {

                                statusClass
                                        = "confirmed";

                                statusText
                                        = "Confirmed";

                            } else if ("REJECTED_BY_DOCTOR"
                                    .equals(status)) {

                                statusClass
                                        = "rejected-doctor";

                                statusText
                                        = "Rejected by Doctor";

                            } else if ("REJECTED_BY_ADMIN"
                                    .equals(status)) {

                                statusClass
                                        = "rejected-admin";

                                statusText
                                        = "Rejected by Admin";

                            } else if ("CANCELLED"
                                    .equals(status)) {

                                statusClass
                                        = "cancelled";

                                statusText
                                        = "Cancelled";
                            }


                            /*
                                 * Only active appointments can
                                 * be rescheduled/cancelled.
                             */
                            boolean canManage
                                    = "PENDING_DOCTOR"
                                            .equals(status)
                                    || "PENDING_ADMIN"
                                            .equals(status)
                                    || "CONFIRMED"
                                            .equals(status);
                    %>


                    <!-- =================================================
                         APPOINTMENT CARD
                         ================================================= -->


                    <div class="appointment-card">


                        <!-- HEADER -->

                        <div class="appointment-header">


                            <div class="appointment-number">


                                <i class="fa-solid fa-calendar-check"></i>


                                <%=a.getAppointmentNo()%>


                            </div>


                            <div class="status <%=statusClass%>">

                                <%=statusText%>

                            </div>


                        </div>


                        <!-- DETAILS -->

                        <div class="details">


                            <!-- DOCTOR -->

                            <div class="detail">


                                <label>
                                    Doctor
                                </label>


                                <strong>

                                    Dr.
                                    <%=a.getDoctorName()%>

                                </strong>


                            </div>


                            <!-- SPECIALIZATION -->

                            <div class="detail">


                                <label>
                                    Specialization
                                </label>


                                <strong>

                                    <%=a.getSpecialization()%>

                                </strong>


                            </div>


                            <!-- TREATMENT -->

                            <div class="detail">


                                <label>
                                    Treatment
                                </label>


                                <strong>

                                    <%=a.getTreatmentType()%>

                                </strong>


                            </div>


                            <!-- DATE -->

                            <div class="detail">


                                <label>
                                    Date
                                </label>


                                <strong>

                                    <%=a.getAppointmentDate()%>

                                </strong>


                            </div>


                            <!-- TIME -->

                            <div class="detail">


                                <label>
                                    Time
                                </label>


                                <strong>

                                    <%=a.getAppointmentTime()%>

                                </strong>


                            </div>


                            <!-- DOCTOR NOTE -->

                            <div class="detail">


                                <label>
                                    Doctor Note
                                </label>


                                <strong>


                                    <%
                                        if (a.getDoctorNote()
                                                == null
                                                || a.getDoctorNote()
                                                        .trim()
                                                        .isEmpty()) {
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


                            <!-- ADMIN NOTE -->

                            <div class="detail">


                                <label>
                                    Admin Note
                                </label>


                                <strong>


                                    <%
                                        if (a.getAdminNote()
                                                == null
                                                || a.getAdminNote()
                                                        .trim()
                                                        .isEmpty()) {
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


                        <!-- =================================================
                             CANCELLATION REASON
                             ================================================= -->


                        <%
                            if ("CANCELLED".equals(status)
                                    && a.getCancellationReason()
                                    != null
                                    && !a.getCancellationReason()
                                            .trim()
                                            .isEmpty()) {
                        %>


                        <div class="cancellation-box">


                            <label>

                                Cancellation Reason

                            </label>


                            <strong>

                                <%=a.getCancellationReason()%>

                            </strong>


                        </div>


                        <%
                            }
                        %>


                        <!-- =================================================
                             ACTION BUTTONS
                             ================================================= -->


                        <%
                            if (canManage) {
                        %>


                        <div class="actions">


                            <!-- RESCHEDULE -->

                            <a class="action-btn reschedule-btn"
                               href="RescheduleAppointmentServlet?appointmentId=<%=a.getId()%>">


                                <i class="fa-solid fa-calendar-days"></i>


                                Reschedule


                            </a>


                            <!-- CANCEL -->

                            <button type="button"
                                    class="action-btn cancel-btn"
                                    onclick="openCancelModal(<%=a.getId()%>)">


                                <i class="fa-solid fa-calendar-xmark"></i>


                                Cancel Appointment


                            </button>


                        </div>


                        <%
                            }
                        %>


                    </div>


                    <%
                            }

                        }
                    %>


                </section>


            </main>


        </div>


        <!-- =========================================================
             CANCEL APPOINTMENT MODAL
             ========================================================= -->


        <div id="cancelModal"
             class="modal">


            <div class="modal-card">


                <h2>

                    <i class="fa-solid fa-calendar-xmark"></i>

                    Cancel Appointment

                </h2>


                <p>

                    Are you sure you want to cancel this
                    appointment? Please provide a reason
                    before confirming.

                </p>


                <form method="post"
                      action="CancelAppointmentServlet">


                    <input type="hidden"
                           id="cancelAppointmentId"
                           name="appointmentId">


                    <label for="reason">

                        Cancellation Reason

                    </label>


                    <textarea
                        id="reason"
                        name="reason"
                        maxlength="500"
                        required
                        placeholder="Please enter your reason for cancelling this appointment..."></textarea>


                    <div class="modal-actions">


                        <button type="button"
                                class="keep-btn"
                                onclick="closeCancelModal()">


                            Keep Appointment


                        </button>


                        <button type="submit"
                                class="confirm-cancel-btn">


                            <i class="fa-solid fa-check"></i>


                            Confirm Cancellation


                        </button>


                    </div>


                </form>


            </div>


        </div>


        <script>

            /*
             * =========================================================
             * OPEN CANCEL MODAL
             * =========================================================
             */

            function openCancelModal(
                    appointmentId) {


                document.getElementById(
                        "cancelAppointmentId"
                        ).value =
                        appointmentId;


                document.getElementById(
                        "reason"
                        ).value =
                        "";


                document.getElementById(
                        "cancelModal"
                        ).style.display =
                        "flex";


                document.getElementById(
                        "reason"
                        ).focus();
            }


            /*
             * =========================================================
             * CLOSE CANCEL MODAL
             * =========================================================
             */

            function closeCancelModal() {


                document.getElementById(
                        "cancelModal"
                        ).style.display =
                        "none";


                document.getElementById(
                        "reason"
                        ).value =
                        "";
            }


            /*
             * =========================================================
             * CLOSE WHEN CLICKING OUTSIDE
             * =========================================================
             */

            window.addEventListener(
                    "click",
                    function (event) {


                        const modal =
                                document.getElementById(
                                        "cancelModal"
                                        );


                        if (event.target === modal) {

                            closeCancelModal();
                        }

                    }
            );


            /*
             * =========================================================
             * ESC KEY CLOSES MODAL
             * =========================================================
             */

            window.addEventListener(
                    "keydown",
                    function (event) {


                        if (event.key === "Escape") {

                            closeCancelModal();
                        }

                    }
            );

        </script>


    </body>

</html>