<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * DOCTOR LOGIN CHECK
     * =========================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }


    /*
     * =========================================================
     * ROLE CHECK
     * =========================================================
     */
    String role
            = (String) session.getAttribute("userRole");

    if (!"doctor".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /*
     * =========================================================
     * DOCTOR NAME
     * =========================================================
     */
    String userName
            = (String) session.getAttribute("userName");

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Doctor";
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
     * MESSAGE PARAMETERS
     * =========================================================
     */
    String error
            = request.getParameter("error");

    String success
            = request.getParameter("success");
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">


        <title>
            Doctor Appointments | Sunrise Dental Clinic
        </title>


        <!-- =====================================================
             GOOGLE FONTS
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

                box-sizing: border-box;

                margin: 0;

                padding: 0;
            }


            /* =====================================================
               BODY
               ===================================================== */

            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f4f8fb;

                color:
                    #555;
            }


            /* =====================================================
               LAYOUT
               ===================================================== */

            .layout {

                min-height: 100vh;

                display: flex;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                width: 250px;

                position: fixed;

                inset: 0 auto 0 0;

                background:
                    #091e3e;

                color: white;

                padding: 25px 18px;

                z-index: 100;
            }


            /* =====================================================
               BRAND
               ===================================================== */

            .brand {

                font:
                    700 21px Jost,
                    sans-serif;

                margin:
                    10px 8px 35px;

                display: flex;

                gap: 10px;

                align-items: center;
            }


            .brand i {

                background:
                    #06a3da;

                padding: 12px;

                border-radius: 10px;
            }


            /* =====================================================
               MENU
               ===================================================== */

            .menu a {

                display: flex;

                gap: 12px;

                padding: 13px 14px;

                color:
                    #c7d2e0;

                text-decoration: none;

                border-radius: 8px;

                margin-bottom: 6px;

                transition:
                    .2s ease;
            }


            .menu a:hover,
            .menu a.active {

                background:
                    #06a3da;

                color: white;
            }


            .menu i {

                width: 18px;

                text-align: center;
            }


            /* =====================================================
               LOGOUT
               ===================================================== */

            .logout {

                position: absolute;

                bottom: 25px;

                left: 18px;

                right: 18px;
            }


            .logout a {

                color:
                    #ffb4b4;

                text-decoration: none;

                display: block;

                padding: 12px;

                border-radius: 8px;
            }


            .logout a:hover {

                background:
                    rgba(255,255,255,.08);
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left: 250px;

                width:
                    calc(100% - 250px);

                min-height: 100vh;
            }


            /* =====================================================
               TOP BAR
               ===================================================== */

            .topbar {

                height: 72px;

                background:
                    white;

                border-bottom:
                    1px solid #e5ebf0;

                padding:
                    0 32px;

                display: flex;

                align-items: center;

                justify-content: space-between;

                position: sticky;

                top: 0;

                z-index: 50;
            }


            .topbar h2 {

                font:
                    700 25px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            /* =====================================================
               USER
               ===================================================== */

            .user {

                display: flex;

                align-items: center;

                gap: 10px;
            }


            .user-info {

                text-align: right;
            }


            .user-info strong {

                display: block;

                color:
                    #091e3e;

                font-size: 13px;
            }


            .user-info small {

                display: block;

                color:
                    #7b8794;

                font-size: 11px;
            }


            .avatar {

                width: 42px;

                height: 42px;

                border-radius: 50%;

                background:
                    #e7f7fc;

                color:
                    #06a3da;

                display: grid;

                place-items: center;
            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding: 30px;
            }


            /* =====================================================
               PAGE TITLE
               ===================================================== */

            .page-title {

                margin-bottom: 25px;
            }


            .page-title h1 {

                font:
                    700 30px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .page-title p {

                margin-top: 5px;

                color:
                    #7b8794;

                font-size: 13px;
            }


            /* =====================================================
               SUCCESS MESSAGE
               ===================================================== */

            .success-message {

                background:
                    #e7f8ee;

                border:
                    1px solid #bde8ce;

                color:
                    #187343;

                padding:
                    13px 16px;

                border-radius:
                    8px;

                margin-bottom:
                    20px;

                font-size:
                    12px;

                display:
                    flex;

                align-items:
                    center;

                gap:
                    8px;
            }


            /* =====================================================
               ERROR MESSAGE
               ===================================================== */

            .error-message {

                background:
                    #fff0f0;

                border:
                    1px solid #f0c4c4;

                color:
                    #a73535;

                padding:
                    13px 16px;

                border-radius:
                    8px;

                margin-bottom:
                    20px;

                font-size:
                    12px;

                display:
                    flex;

                align-items:
                    center;

                gap:
                    8px;
            }


            /* =====================================================
               CARD
               ===================================================== */

            .card {

                background:
                    white;

                border-radius:
                    12px;

                padding:
                    25px;

                box-shadow:
                    0 5px 20px
                    rgba(0,0,0,0.05);

                overflow-x:
                    auto;
            }


            /* =====================================================
               TABLE
               ===================================================== */

            table {

                width:
                    100%;

                border-collapse:
                    collapse;

                min-width:
                    1050px;
            }


            th {

                background:
                    #091e3e;

                color:
                    white;

                padding:
                    14px;

                text-align:
                    left;

                font-size:
                    13px;

                white-space:
                    nowrap;
            }


            td {

                padding:
                    15px 14px;

                border-bottom:
                    1px solid #edf1f5;

                vertical-align:
                    middle;

                font-size:
                    12px;
            }


            tr:hover td {

                background:
                    #f8fbfd;
            }


            /* =====================================================
               APPOINTMENT NUMBER
               ===================================================== */

            .appointment-number {

                color:
                    #091e3e;

                font-weight:
                    700;
            }


            /* =====================================================
               PATIENT NAME
               ===================================================== */

            .patient-name {

                color:
                    #091e3e;

                font-weight:
                    600;
            }


            /* =====================================================
               STATUS
               ===================================================== */

            .status {

                display:
                    inline-block;

                padding:
                    6px 12px;

                border-radius:
                    20px;

                font-size:
                    11px;

                font-weight:
                    600;

                white-space:
                    nowrap;
            }


            .pending {

                background:
                    #fff4d6;

                color:
                    #9a6a00;
            }


            .accepted {

                background:
                    #e4f8ed;

                color:
                    #16834b;
            }


            .rejected {

                background:
                    #ffe7e7;

                color:
                    #c62828;
            }


            .admin {

                background:
                    #e6f0ff;

                color:
                    #1769aa;
            }


            /* =====================================================
               ACTION AREA
               ===================================================== */

            .action-container {

                display:
                    flex;

                flex-direction:
                    column;

                align-items:
                    flex-start;

                gap:
                    8px;

                min-width:
                    240px;
            }


            /* =====================================================
               VIEW PATIENT BUTTON
               ===================================================== */

            .btn-view-patient {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    7px;

                padding:
                    9px 13px;

                border-radius:
                    6px;

                background:
                    #e7f7fc;

                color:
                    #06a3da;

                text-decoration:
                    none;

                font-size:
                    11px;

                font-weight:
                    600;

                border:
                    1px solid #cceef8;

                transition:
                    .2s ease;

                white-space:
                    nowrap;
            }


            .btn-view-patient:hover {

                background:
                    #06a3da;

                color:
                    white;

                border-color:
                    #06a3da;
            }


            /* =====================================================
               ACTION FORM
               ===================================================== */

            .action-form {

                display:
                    flex;

                gap:
                    8px;

                align-items:
                    center;

                flex-wrap:
                    wrap;
            }


            /* =====================================================
               NOTE INPUT
               ===================================================== */

            .note {

                padding:
                    8px 10px;

                border:
                    1px solid #dce3ea;

                border-radius:
                    6px;

                width:
                    180px;

                outline:
                    none;

                font-family:
                    "Open Sans",
                    sans-serif;

                font-size:
                    11px;
            }


            .note:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px
                    rgba(6,163,218,.08);
            }


            /* =====================================================
               BUTTON
               ===================================================== */

            .btn {

                border:
                    none;

                border-radius:
                    6px;

                padding:
                    9px 13px;

                cursor:
                    pointer;

                color:
                    white;

                font-weight:
                    600;

                font-size:
                    11px;

                transition:
                    .2s ease;
            }


            .btn:hover {

                opacity:
                    .9;
            }


            .btn-accept {

                background:
                    #198754;
            }


            .btn-reject {

                background:
                    #dc3545;
            }


            /* =====================================================
               NO ACTION
               ===================================================== */

            .no-action {

                color:
                    #888;

                font-size:
                    11px;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                text-align:
                    center;

                padding:
                    60px 30px;

                color:
                    #888;
            }


            .empty-icon {

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

                font-family:
                    Jost,
                    sans-serif;

                margin-bottom:
                    7px;
            }


            .empty p {

                font-size:
                    12px;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width: 900px) {

                .sidebar {

                    width:
                        70px;

                    padding:
                        20px 10px;
                }


                .brand {

                    justify-content:
                        center;

                    margin-left:
                        0;

                    margin-right:
                        0;
                }


                .brand span {

                    display:
                        none;
                }


                .menu a {

                    justify-content:
                        center;
                }


                .menu a span {

                    display:
                        none;
                }


                .logout {

                    left:
                        10px;

                    right:
                        10px;
                }


                .logout span {

                    display:
                        none;
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


                .content {

                    padding:
                        20px;
                }

            }


            @media(max-width: 600px) {

                .topbar {

                    padding:
                        0 18px;
                }


                .topbar h2 {

                    font-size:
                        20px;
                }


                .user-info {

                    display:
                        none;
                }


                .content {

                    padding:
                        15px;
                }


                .page-title h1 {

                    font-size:
                        24px;
                }


                .card {

                    padding:
                        15px;
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


                <div class="menu">


                    <!-- DASHBOARD -->

                    <a href="doctor-dashboard.jsp">

                        <i class="fa-solid fa-house"></i>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <!-- APPOINTMENTS -->

                    <a
                        href="DoctorAppointmentsServlet"
                        class="active">

                        <i class="fa-solid fa-calendar-check"></i>

                        <span>
                            Appointments
                        </span>

                    </a>


                    <!-- NOTIFICATIONS -->

                    <a href="DoctorNotificationsServlet">

                        <i class="fa-solid fa-bell"></i>

                        <span>
                            Notifications
                        </span>

                    </a>


                </div>


                <!-- LOGOUT -->

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
                     TOP BAR
                     ================================================= -->

                <div class="topbar">


                    <h2>
                        Doctor Appointments
                    </h2>


                    <div class="user">


                        <div class="user-info">

                            <strong>
                                <%= userName%>
                            </strong>

                            <small>
                                Doctor
                            </small>

                        </div>


                        <div class="avatar">

                            <i class="fa-solid fa-user-doctor"></i>

                        </div>


                    </div>


                </div>



                <!-- =================================================
                     CONTENT
                     ================================================= -->

                <div class="content">


                    <div class="page-title">


                        <h1>
                            Appointment Requests
                        </h1>


                        <p>
                            Review appointments and manage your patients.
                        </p>


                    </div>



                    <!-- =================================================
                         SUCCESS MESSAGE
                         ================================================= -->

                    <% if ("accepted".equalsIgnoreCase(success)) { %>


                    <div class="success-message">

                        <i class="fa-solid fa-circle-check"></i>

                        Appointment accepted successfully.

                    </div>


                    <% } %>



                    <% if ("rejected".equalsIgnoreCase(success)) { %>


                    <div class="success-message">

                        <i class="fa-solid fa-circle-check"></i>

                        Appointment rejected successfully.

                    </div>


                    <% } %>



                    <!-- =================================================
                         ERROR MESSAGE
                         ================================================= -->

                    <% if ("access".equalsIgnoreCase(error)) { %>


                    <div class="error-message">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                        You are not authorised to access this appointment.

                    </div>


                    <% } %>



                    <% if ("database".equalsIgnoreCase(error)) { %>


                    <div class="error-message">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                        A database error occurred. Please try again.

                    </div>


                    <% } %>



                    <% if ("notfound".equalsIgnoreCase(error)) { %>


                    <div class="error-message">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                        Appointment could not be found.

                    </div>


                    <% } %>



                    <!-- =================================================
                         APPOINTMENT CARD
                         ================================================= -->

                    <div class="card">


                        <% if (appointments == null
                                    || appointments.isEmpty()) { %>


                        <!-- EMPTY -->

                        <div class="empty">


                            <div class="empty-icon">

                                <i
                                    class="fa-regular fa-calendar-xmark">
                                </i>

                            </div>


                            <h3>
                                No appointments found
                            </h3>


                            <p>
                                There are currently no appointment requests.
                            </p>


                        </div>


                        <% } else { %>


                        <!-- =================================================
                             APPOINTMENT TABLE
                             ================================================= -->

                        <table>


                            <thead>


                                <tr>

                                    <th>
                                        Appointment No
                                    </th>

                                    <th>
                                        Patient
                                    </th>

                                    <th>
                                        Phone
                                    </th>

                                    <th>
                                        Treatment
                                    </th>

                                    <th>
                                        Date
                                    </th>

                                    <th>
                                        Time
                                    </th>

                                    <th>
                                        Status
                                    </th>

                                    <th>
                                        Action
                                    </th>

                                </tr>


                            </thead>



                            <tbody>


                                <% for (Appointment a : appointments) {%>


                                <tr>


                                    <!-- =================================
                                         APPOINTMENT NUMBER
                                         ================================= -->

                                    <td>

                                        <strong
                                            class="appointment-number">

                                            <%= a.getAppointmentNo()%>

                                        </strong>

                                    </td>



                                    <!-- =================================
                                         PATIENT
                                         ================================= -->

                                    <td>

                                        <span
                                            class="patient-name">

                                            <%= a.getPatientName()%>

                                        </span>

                                    </td>



                                    <!-- =================================
                                         PHONE
                                         ================================= -->

                                    <td>

                                        <%= a.getPatientPhone()%>

                                    </td>



                                    <!-- =================================
                                         TREATMENT
                                         ================================= -->

                                    <td>

                                        <%= a.getTreatmentType()%>

                                    </td>



                                    <!-- =================================
                                         DATE
                                         ================================= -->

                                    <td>

                                        <%= a.getAppointmentDate()%>

                                    </td>



                                    <!-- =================================
                                         TIME
                                         ================================= -->

                                    <td>

                                        <%= a.getAppointmentTime()%>

                                    </td>



                                    <!-- =================================
                                         STATUS
                                         ================================= -->

                                    <td>


                                        <%
                                            String status
                                                    = a.getStatus();

                                            String statusClass
                                                    = "pending";

                                            if ("PENDING_ADMIN"
                                                    .equals(status)) {

                                                statusClass
                                                        = "admin";

                                            } else if ("CONFIRMED"
                                                    .equals(status)) {

                                                statusClass
                                                        = "accepted";

                                            } else if (status != null
                                                    && status.startsWith(
                                                            "REJECTED"
                                                    )) {

                                                statusClass
                                                        = "rejected";
                                            }

                                            if (status == null) {

                                                status
                                                        = "UNKNOWN";
                                            }
                                        %>


                                        <span
                                            class="status <%= statusClass%>">

                                            <%= status.replace(
                                                    "_",
                                                    " "
                                            )%>

                                        </span>


                                    </td>



                                    <!-- =================================
                                         ACTION
                                         ================================= -->

                                    <td>

                                        <div class="action-container">

                                            <!-- VIEW PATIENT -->

                                            <a
                                                href="<%=request.getContextPath()%>/DoctorPatientDetailsServlet?appointmentId=<%=a.getId()%>"
                                                class="btn-view-patient">

                                                <i class="fa-solid fa-user"></i>

                                                View Patient

                                            </a>


                                            <!-- ACCEPT / REJECT -->

                                            <% if ("PENDING_DOCTOR".equals(a.getStatus())) {%>

                                            <form
                                                method="post"
                                                action="DoctorDecisionServlet"
                                                class="action-form">


                                                <input
                                                    type="hidden"
                                                    name="appointmentId"
                                                    value="<%=a.getId()%>">


                                                <input
                                                    type="text"
                                                    name="note"
                                                    class="note"
                                                    placeholder="Note (optional)"
                                                    maxlength="500">


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

                                            <span class="no-action">

                                                No action required

                                            </span>

                                            <% } %>


                                        </div>

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

        <jsp:include page="toast.jsp" />

    </body>

</html>