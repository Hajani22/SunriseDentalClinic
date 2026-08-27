<%@page import="java.util.List"%>
<%@page import="model.DoctorOption"%>
<%@page import="model.DoctorSchedule"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * SESSION SECURITY
     * =========================================================
     */
    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");
        return;
    }


    /*
     * Check user role.
     */
    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"patient".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /*
     * Get logged-in patient's name.
     */
    String userName
            = (String) session.getAttribute("userName");


    /*
     * =========================================================
     * DATA FROM BookAppointmentServlet
     * =========================================================
     */
    List<DoctorOption> doctors
            = (List<DoctorOption>) request.getAttribute("doctors");

    List<DoctorSchedule> schedules
            = (List<DoctorSchedule>) request.getAttribute("schedules");


    /*
     * Error parameters.
     */
    String error
            = request.getParameter("error");

    String errorMessage
            = request.getParameter("errorMessage");


    /*
     * Success parameter.
     */
    String success
            = request.getParameter("success");
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width,
              initial-scale=1.0">

        <title>
            Book Appointment | Sunrise Dental Clinic
        </title>


        <!-- Google Fonts -->

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <!-- Font Awesome -->

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
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }


            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f4f8fb;

                color:
                    #555;

                min-height:
                    100vh;
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

                z-index:
                    100;
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
                    0.2s ease;
            }


            .menu a:hover {

                background:
                    rgba(6,163,218,0.15);

                color:
                    white;
            }


            .menu a.active {

                background:
                    #06a3da;

                color:
                    white;
            }


            .menu i {

                width:
                    18px;

                text-align:
                    center;
            }


            /*
             * =====================================================
             * LOGOUT
             * =====================================================
             */

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
            }


            .logout a:hover {

                background:
                    rgba(255,255,255,0.08);
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

                min-height:
                    100vh;
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

                position:
                    sticky;

                top:
                    0;

                z-index:
                    50;
            }


            .topbar h2 {

                font:
                    700 25px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .user-info {

                display:
                    flex;

                flex-direction:
                    column;

                align-items:
                    flex-end;
            }


            .user-info strong {

                color:
                    #091e3e;

                font-size:
                    14px;
            }


            .user-info small {

                color:
                    #82909e;

                font-size:
                    12px;
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


            /*
             * =====================================================
             * FORM CARD
             * =====================================================
             */

            .form-card {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    16px;

                padding:
                    32px;

                max-width:
                    1050px;

                margin:
                    0 auto;

                box-shadow:
                    0 5px 20px rgba(9,30,62,0.04);
            }


            .form-title {

                color:
                    #091e3e;

                font:
                    700 30px Jost,
                    sans-serif;

                margin-bottom:
                    8px;
            }


            .form-subtitle {

                color:
                    #7a8795;

                margin-bottom:
                    28px;

                line-height:
                    1.6;
            }


            /*
             * =====================================================
             * ALERT
             * =====================================================
             */

            .alert {

                display:
                    flex;

                align-items:
                    flex-start;

                gap:
                    10px;

                padding:
                    14px 16px;

                background:
                    #fff1f1;

                border:
                    1px solid #ffcaca;

                color:
                    #b42318;

                border-radius:
                    9px;

                margin-bottom:
                    20px;

                font-size:
                    14px;

                line-height:
                    1.5;
            }


            .alert.success {

                background:
                    #edf9f1;

                border-color:
                    #bde8ca;

                color:
                    #157347;
            }


            /*
             * =====================================================
             * GRID
             * =====================================================
             */

            .grid {

                display:
                    grid;

                grid-template-columns:
                    1fr 1fr;

                gap:
                    20px;
            }


            .full {

                grid-column:
                    1 / -1;
            }


            /*
             * =====================================================
             * FORM FIELD
             * =====================================================
             */

            .field {

                min-width:
                    0;
            }


            label {

                display:
                    block;

                color:
                    #091e3e;

                font-weight:
                    600;

                margin-bottom:
                    8px;

                font-size:
                    14px;
            }


            .required {

                color:
                    #d92d20;
            }


            input,
            select,
            textarea {

                width:
                    100%;

                padding:
                    13px 14px;

                border:
                    1px solid #d7e0e8;

                border-radius:
                    9px;

                font-family:
                    inherit;

                font-size:
                    14px;

                outline:
                    none;

                background:
                    white;

                color:
                    #333;

                transition:
                    border-color 0.2s ease,
                    box-shadow 0.2s ease;
            }


            input:focus,
            select:focus,
            textarea:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px
                    rgba(6,163,218,0.10);
            }


            input::placeholder {

                color:
                    #a0aab5;
            }


            /*
             * =====================================================
             * DOCTOR INFORMATION
             * =====================================================
             */

            .doctor-note {

                margin-top:
                    10px;

                padding:
                    13px 15px;

                background:
                    #f0f8fc;

                border:
                    1px solid #d4edf7;

                color:
                    #446579;

                border-radius:
                    8px;

                font-size:
                    12px;

                line-height:
                    1.6;

                min-height:
                    45px;
            }


            .doctor-note i {

                color:
                    #06a3da;

                margin-right:
                    5px;
            }


            .doctor-note strong {

                color:
                    #091e3e;
            }


            /*
             * =====================================================
             * AVAILABILITY STATUS
             * =====================================================
             */

            .availability-card {

                margin-top:
                    20px;

                display:
                    none;

                background:
                    #f8fbfd;

                border:
                    1px solid #dceaf1;

                border-radius:
                    10px;

                padding:
                    17px;
            }


            .availability-card.show {

                display:
                    block;
            }


            .availability-title {

                font:
                    700 15px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    10px;
            }


            .schedule-row {

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

                padding:
                    9px 0;

                border-bottom:
                    1px solid #e9eff3;

                font-size:
                    13px;
            }


            .schedule-row:last-child {

                border-bottom:
                    none;
            }


            .schedule-day {

                font-weight:
                    600;

                color:
                    #091e3e;
            }


            .schedule-time {

                color:
                    #607080;

                text-align:
                    right;
            }


            .schedule-unavailable {

                color:
                    #b42318;

                font-weight:
                    600;
            }


            /*
             * =====================================================
             * BOOKING INFO
             * =====================================================
             */

            .booking-info {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;

                background:
                    #fffaf0;

                border:
                    1px solid #f5dfad;

                color:
                    #805b13;

                padding:
                    13px 15px;

                border-radius:
                    8px;

                margin-top:
                    20px;

                font-size:
                    13px;

                line-height:
                    1.5;
            }


            .booking-info i {

                color:
                    #d99b00;

                font-size:
                    16px;
            }


            /*
             * =====================================================
             * SUBMIT BUTTON
             * =====================================================
             */

            .submit-btn {

                width:
                    100%;

                border:
                    none;

                background:
                    #06a3da;

                color:
                    white;

                padding:
                    15px;

                border-radius:
                    9px;

                margin-top:
                    25px;

                font-weight:
                    700;

                font-size:
                    15px;

                cursor:
                    pointer;

                transition:
                    0.2s ease;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    9px;
            }


            .submit-btn:hover {

                background:
                    #0589b8;

                transform:
                    translateY(-1px);
            }


            .submit-btn:disabled {

                background:
                    #aebbc5;

                cursor:
                    not-allowed;

                transform:
                    none;
            }


            /*
             * =====================================================
             * REQUIRED FIELD MESSAGE
             * =====================================================
             */

            .field-help {

                margin-top:
                    6px;

                color:
                    #82909e;

                font-size:
                    11px;
            }


            /*
             * =====================================================
             * RESPONSIVE
             * =====================================================
             */

            @media(max-width: 900px) {

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

                    margin:
                        10px 0 35px;
                }


                .menu a {

                    justify-content:
                        center;

                    padding:
                        13px 8px;
                }


                .logout {

                    left:
                        10px;

                    right:
                        10px;
                }


                .main {

                    margin-left:
                        70px;

                    width:
                        calc(100% - 70px);
                }
            }


            @media(max-width: 700px) {

                .topbar {

                    padding:
                        0 20px;
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
                        18px;
                }


                .form-card {

                    padding:
                        22px;
                }


                .grid {

                    grid-template-columns:
                        1fr;
                }


                .full {

                    grid-column:
                        auto;
                }


                .schedule-row {

                    flex-direction:
                        column;

                    align-items:
                        flex-start;

                    gap:
                        4px;
                }


                .schedule-time {

                    text-align:
                        left;
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


                    <a
                        class="active"
                        href="BookAppointmentServlet">

                        <i class="fa-solid fa-calendar-plus"></i>

                        <span>
                            Book Appointment
                        </span>

                    </a>


                    <a href="PatientAppointmentsServlet">

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


                    <a href="Help.jsp">

                        <i class="fa-solid fa-circle-question"></i>

                        <span>
                            Help & Support
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


                <!-- TOP BAR -->

                <header class="topbar">


                    <h2>
                        Book Appointment
                    </h2>


                    <div class="user-info">

                        <strong>
                            <%=userName != null
                                    ? userName
                                    : "Patient"%>
                        </strong>

                        <small>
                            Patient
                        </small>

                    </div>


                </header>


                <!-- =================================================
                     CONTENT
                     ================================================= -->

                <section class="content">


                    <div class="form-card">


                        <h1 class="form-title">

                            Book an Appointment

                        </h1>


                        <p class="form-subtitle">

                            Choose your preferred dentist,
                            treatment, date and available time.

                            The system will automatically check
                            the dentist's working schedule.

                        </p>


                        <!-- =========================================
                             SUCCESS MESSAGE
                             ========================================= -->

                        <% if ("booked".equals(success)) { %>

                        <div class="alert success">

                            <i class="fa-solid fa-circle-check"></i>

                            <span>
                                Your appointment request
                                has been submitted successfully.
                            </span>

                        </div>

                        <% } %>


                        <!-- =========================================
                             ERROR MESSAGES
                             ========================================= -->


                        <% if ("slot".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-circle-exclamation"></i>

                            <span>
                                The selected dentist is already
                                booked at this time.
                                Please select another date or time.
                            </span>

                        </div>

                        <% } %>


                        <% if ("server".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-triangle-exclamation"></i>

                            <span>
                                Something went wrong while creating
                                your appointment. Please try again.
                            </span>

                        </div>

                        <% } %>


                        <% if ("database".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-database"></i>

                            <span>
                                A database error occurred.
                                Please make sure MySQL is running
                                and the required tables exist.
                            </span>

                        </div>

                        <% } %>


                        <% if ("empty".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-circle-exclamation"></i>

                            <span>
                                Please complete all required
                                appointment fields.
                            </span>

                        </div>

                        <% } %>


                        <% if ("doctor".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-user-doctor"></i>

                            <span>
                                Please select a valid dentist.
                            </span>

                        </div>

                        <% } %>


                        <% if ("invalid".equals(error)) { %>

                        <div class="alert">

                            <i class="fa-solid fa-calendar-xmark"></i>

                            <span>
                                Please check the appointment
                                date and time.
                            </span>

                        </div>

                        <% } %>


                        <% if (errorMessage != null
                            && !errorMessage.trim().isEmpty()) {%>

                        <div class="alert">

                            <i class="fa-solid fa-circle-exclamation"></i>

                            <span>
                                <%=errorMessage%>
                            </span>

                        </div>

                        <% } %>


                        <!-- =========================================
                             APPOINTMENT FORM
                             ========================================= -->

                        <form
                            method="post"
                            action="BookAppointmentServlet"
                            onsubmit="return validateForm();">


                            <div class="grid">


                                <!-- =================================
                                     DOCTOR
                                     ================================= -->

                                <div class="field full">


                                    <label for="doctorId">

                                        Select Dentist

                                        <span class="required">
                                            *
                                        </span>

                                    </label>


                                    <select
                                        id="doctorId"
                                        name="doctorId"
                                        required>


                                        <option value="">

                                            -- Select Dentist --

                                        </option>


                                        <%
                                            if (doctors != null
                                                    && !doctors.isEmpty()) {

                                                for (DoctorOption doctor
                                                        : doctors) {
                                        %>


                                        <option
                                            value="<%=doctor.getId()%>"
                                            data-doctor-id="<%=doctor.getId()%>">

                                            Dr.
                                            <%=doctor.getName()%>


                                            <%
                                                if (doctor.getSpecialization()
                                                        != null
                                                        && !doctor.getSpecialization()
                                                                .trim()
                                                                .isEmpty()) {
                                            %>

                                            -
                                            <%=doctor.getSpecialization()%>

                                            <%
                                                }
                                            %>

                                        </option>


                                        <%
                                            }

                                        } else {
                                        %>


                                        <option
                                            value=""
                                            disabled>

                                            No dentists available

                                        </option>


                                        <%
                                            }
                                        %>


                                    </select>


                                    <div
                                        class="doctor-note"
                                        id="doctorScheduleInfo">

                                        <i class="fa-solid fa-clock"></i>

                                        Select a dentist to view
                                        available working hours.

                                    </div>


                                    <!-- SCHEDULE LIST -->

                                    <div
                                        class="availability-card"
                                        id="availabilityCard">


                                        <div class="availability-title">

                                            <i class="fa-solid fa-calendar-week"></i>

                                            Dentist Working Schedule

                                        </div>


                                        <div id="scheduleList">

                                        </div>


                                    </div>


                                </div>


                                <!-- =================================
                                     TREATMENT
                                     ================================= -->

                                <div class="field">


                                    <label for="treatmentType">

                                        Treatment

                                        <span class="required">
                                            *
                                        </span>

                                    </label>


                                    <select
                                        id="treatmentType"
                                        name="treatmentType"
                                        required>


                                        <option value="">

                                            -- Select Treatment --

                                        </option>


                                        <option value="Dental Consultation">
                                            Dental Consultation
                                        </option>


                                        <option value="Dental Cleaning">
                                            Dental Cleaning
                                        </option>


                                        <option value="Tooth Filling">
                                            Tooth Filling
                                        </option>


                                        <option value="Tooth Extraction">
                                            Tooth Extraction
                                        </option>


                                        <option value="Root Canal Treatment">
                                            Root Canal Treatment
                                        </option>


                                        <option value="Dental X-Ray">
                                            Dental X-Ray
                                        </option>


                                        <option value="Other">
                                            Other
                                        </option>


                                    </select>


                                </div>


                                <!-- =================================
                                     DATE
                                     ================================= -->

                                <div class="field">


                                    <label for="appointmentDate">

                                        Appointment Date

                                        <span class="required">
                                            *
                                        </span>

                                    </label>


                                    <input
                                        type="date"
                                        id="appointmentDate"
                                        name="appointmentDate"
                                        required>


                                    <div class="field-help">

                                        Select a future date.

                                    </div>


                                </div>


                                <!-- =================================
                                     TIME
                                     ================================= -->

                                <div class="field">


                                    <label for="appointmentTime">

                                        Appointment Time

                                        <span class="required">
                                            *
                                        </span>

                                    </label>


                                    <input
                                        type="time"
                                        id="appointmentTime"
                                        name="appointmentTime"
                                        min="08:00"
                                        max="18:00"
                                        step="1800"
                                        required>


                                    <div class="field-help">

                                        Available times depend on
                                        the selected dentist's schedule.

                                    </div>


                                </div>


                                <!-- =================================
                                     PHONE
                                     ================================= -->

                                <div class="field">


                                    <label for="phone">

                                        Phone Number

                                    </label>


                                    <input
                                        type="text"
                                        id="phone"
                                        name="phone"
                                        placeholder="Enter phone number">


                                </div>


                                <!-- =================================
                                     ADDRESS
                                     ================================= -->

                                <div class="field">


                                    <label for="address">

                                        Address

                                    </label>


                                    <input
                                        type="text"
                                        id="address"
                                        name="address"
                                        placeholder="Enter address">


                                </div>


                            </div>


                            <!-- =====================================
                                 INFORMATION
                                 ===================================== -->

                            <div class="booking-info">

                                <i class="fa-solid fa-circle-info"></i>

                                <span>

                                    Your appointment will first be
                                    reviewed by the dentist and then
                                    confirmed by the clinic administrator.

                                </span>

                            </div>


                            <!-- =====================================
                                 SUBMIT
                                 ===================================== -->

                            <button
                                type="submit"
                                class="submit-btn"
                                id="submitButton">


                                <i class="fa-solid fa-calendar-check"></i>


                                Send Appointment Request


                            </button>


                        </form>


                    </div>


                </section>


            </main>


        </div>


        <script>


            /*
             * =========================================================
             * DATA FROM SERVER
             * =========================================================
             *
             * The servlet sends the schedules list to this JSP.
             *
             * We convert it to JavaScript objects so that the page
             * can display schedules without another database request.
             */

            const schedules = [

            <%
                    if (schedules != null) {

                        for (DoctorSchedule schedule : schedules) {
            %>

                {
                    doctorId:
            <%=schedule.getDoctorId()%>,

                    day:
                            "<%=schedule.getDayOfWeek()%>",

                    start:
                            "<%=schedule.getStartTime()%>",

                    end:
                            "<%=schedule.getEndTime()%>",

                    breakStart:
                            "<%=schedule.getBreakStart() == null
                                ? ""
                                : schedule.getBreakStart()%>",

                    breakEnd:
                            "<%=schedule.getBreakEnd() == null
                                ? ""
                                : schedule.getBreakEnd()%>",

                    available:
            <%=schedule.isAvailable()%>
                },

            <%
                        }
                    }
            %>

            ];


            /*
             * =========================================================
             * ELEMENTS
             * =========================================================
             */

            const doctorSelect =
                    document.getElementById(
                            "doctorId"
                            );


            const dateInput =
                    document.getElementById(
                            "appointmentDate"
                            );


            const timeInput =
                    document.getElementById(
                            "appointmentTime"
                            );


            const scheduleInfo =
                    document.getElementById(
                            "doctorScheduleInfo"
                            );


            const availabilityCard =
                    document.getElementById(
                            "availabilityCard"
                            );


            const scheduleList =
                    document.getElementById(
                            "scheduleList"
                            );


            const submitButton =
                    document.getElementById(
                            "submitButton"
                            );


            /*
             * =========================================================
             * TODAY
             * =========================================================
             */

            const now =
                    new Date();


            const today =
                    now.toISOString()
                    .split("T")[0];


            dateInput.min =
                    today;


            /*
             * =========================================================
             * DAY NAMES
             * =========================================================
             */

            const dayNames = [

                "SUNDAY",

                "MONDAY",

                "TUESDAY",

                "WEDNESDAY",

                "THURSDAY",

                "FRIDAY",

                "SATURDAY"

            ];


            /*
             * =========================================================
             * GET DOCTOR SCHEDULES
             * =========================================================
             */

            function getDoctorSchedules() {


                const doctorId =
                        parseInt(
                                doctorSelect.value
                                );


                if (!doctorId) {

                    return [];

                }


                return schedules.filter(
                        function (schedule) {

                            return schedule.doctorId
                                    === doctorId;

                        }

                );

            }


            /*
             * =========================================================
             * DISPLAY DOCTOR SCHEDULE
             * =========================================================
             */

            function displayDoctorSchedule() {


                const doctorId =
                        parseInt(
                                doctorSelect.value
                                );


                /*
                 * No doctor selected.
                 */

                if (!doctorId) {


                    scheduleInfo.innerHTML =
                            '<i class="fa-solid fa-clock"></i> '

                            + 'Select a dentist to view '

                            + 'available working hours.';


                    availabilityCard.classList.remove(
                            "show"
                            );


                    return;

                }


                /*
                 * Get selected doctor's schedules.
                 */

                const doctorSchedules =
                        getDoctorSchedules();


                /*
                 * No schedule configured.
                 */

                if (doctorSchedules.length === 0) {


                    scheduleInfo.innerHTML =
                            '<i class="fa-solid fa-circle-exclamation"></i> '

                            + '<strong>No schedule configured.</strong> '

                            + 'Please select another dentist or contact '
                            + 'the clinic.';


                    availabilityCard.classList.remove(
                            "show"
                            );


                    return;

                }


                /*
                 * Show short message.
                 */

                scheduleInfo.innerHTML =
                        '<i class="fa-solid fa-circle-check"></i> '

                        + '<strong>Schedule available.</strong> '

                        + 'Select a date and time based on the '
                        + 'dentist working hours.';


                /*
                 * Clear previous schedule.
                 */

                scheduleList.innerHTML = "";


                /*
                 * Display each schedule.
                 */

                doctorSchedules.forEach(
                        function (schedule) {


                            const row =
                                    document.createElement(
                                            "div"
                                            );


                            row.className =
                                    "schedule-row";


                            const day =
                                    document.createElement(
                                            "span"
                                            );


                            day.className =
                                    "schedule-day";


                            day.textContent =
                                    formatDay(
                                            schedule.day
                                            );


                            const time =
                                    document.createElement(
                                            "span"
                                            );


                            time.className =
                                    "schedule-time";


                            if (!schedule.available) {


                                time.className +=
                                        " schedule-unavailable";


                                time.textContent =
                                        "Not Available";


                            } else {


                                let text =
                                        schedule.start
                                        + " - "
                                        + schedule.end;


                                if (
                                        schedule.breakStart
                                        &&
                                        schedule.breakEnd
                                        ) {

                                    text +=
                                            " | Break: "
                                            + schedule.breakStart
                                            + " - "
                                            + schedule.breakEnd;

                                }


                                time.textContent =
                                        text;

                            }


                            row.appendChild(
                                    day
                                    );


                            row.appendChild(
                                    time
                                    );


                            scheduleList.appendChild(
                                    row
                                    );

                        }

                );


                availabilityCard.classList.add(
                        "show"
                        );

            }


            /*
             * =========================================================
             * FORMAT DAY
             * =========================================================
             */

            function formatDay(day) {


                if (!day) {

                    return "";

                }


                return day.charAt(0)
                        + day.substring(1)
                        .toLowerCase();

            }


            /*
             * =========================================================
             * GET SELECTED DAY
             * =========================================================
             */

            function getSelectedDay() {


                if (!dateInput.value) {

                    return null;

                }


                const selectedDate =
                        new Date(
                                dateInput.value
                                + "T00:00:00"
                                );


                return dayNames[
                        selectedDate.getDay()
                ];

            }


            /*
             * =========================================================
             * GET SCHEDULE FOR SELECTED DAY
             * =========================================================
             */

            function getScheduleForSelectedDay() {


                const doctorId =
                        parseInt(
                                doctorSelect.value
                                );


                const selectedDay =
                        getSelectedDay();


                if (!doctorId
                        || !selectedDay) {

                    return null;

                }


                const matching =
                        schedules.filter(
                                function (schedule) {

                                    return schedule.doctorId
                                            === doctorId
                                            &&
                                            schedule.day
                                            === selectedDay;

                                }

                        );


                if (matching.length === 0) {

                    return null;

                }


                return matching[0];

            }


            /*
             * =========================================================
             * CHECK TIME AVAILABILITY
             * =========================================================
             */

            function isTimeAvailable() {


                const schedule =
                        getScheduleForSelectedDay();


                const selectedTime =
                        timeInput.value;


                /*
                 * No schedule.
                 */

                if (!schedule) {

                    return false;

                }


                /*
                 * Dentist unavailable.
                 */

                if (!schedule.available) {

                    return false;

                }


                /*
                 * No time selected.
                 */

                if (!selectedTime) {

                    return false;

                }


                /*
                 * Before working hours.
                 */

                if (
                        selectedTime
                        < schedule.start
                        ) {

                    return false;

                }


                /*
                 * After working hours.
                 */

                if (
                        selectedTime
                        >= schedule.end
                        ) {

                    return false;

                }


                /*
                 * During break.
                 */

                if (
                        schedule.breakStart
                        &&
                        schedule.breakEnd
                        &&
                        selectedTime
                        >= schedule.breakStart
                        &&
                        selectedTime
                        < schedule.breakEnd
                        ) {

                    return false;

                }


                return true;

            }


            /*
             * =========================================================
             * VALIDATE APPOINTMENT FORM
             * =========================================================
             */

            function validateForm() {


                /*
                 * Doctor.
                 */

                const doctorId =
                        parseInt(
                                doctorSelect.value
                                );


                if (!doctorId) {

                    alert(
                            "Please select a dentist."
                            );

                    doctorSelect.focus();

                    return false;

                }


                /*
                 * Treatment.
                 */

                const treatment =
                        document.getElementById(
                                "treatmentType"
                                ).value;


                if (!treatment) {

                    alert(
                            "Please select a treatment."
                            );

                    document.getElementById(
                            "treatmentType"
                            ).focus();

                    return false;

                }


                /*
                 * Date.
                 */

                const selectedDate =
                        dateInput.value;


                if (!selectedDate) {

                    alert(
                            "Please select an appointment date."
                            );

                    dateInput.focus();

                    return false;

                }


                /*
                 * Prevent past date.
                 */

                if (
                        selectedDate
                        < today
                        ) {

                    alert(
                            "Please select a future date."
                            );

                    dateInput.focus();

                    return false;

                }


                /*
                 * Time.
                 */

                const selectedTime =
                        timeInput.value;


                if (!selectedTime) {

                    alert(
                            "Please select an appointment time."
                            );

                    timeInput.focus();

                    return false;

                }


                /*
                 * Check today's appointment time.
                 */

                if (
                        selectedDate
                        === today
                        ) {


                    const currentTime =
                            new Date();


                    const currentHours =
                            String(
                                    currentTime.getHours()
                                    ).padStart(
                            2,
                            "0"
                            );


                    const currentMinutes =
                            String(
                                    currentTime.getMinutes()
                                    ).padStart(
                            2,
                            "0"
                            );


                    const currentTimeString =
                            currentHours
                            + ":"
                            + currentMinutes;


                    if (
                            selectedTime
                            <= currentTimeString
                            ) {

                        alert(
                                "Please select a future appointment time."
                                );

                        timeInput.focus();

                        return false;

                    }

                }


                /*
                 * Get schedule.
                 */

                const schedule =
                        getScheduleForSelectedDay();


                /*
                 * No schedule for selected day.
                 */

                if (!schedule) {


                    const selectedDay =
                            getSelectedDay();


                    alert(
                            "The selected dentist does not "
                            + "have a working schedule on "
                            + formatDay(selectedDay)
                            + ". Please select another date."

                            );


                    dateInput.focus();

                    return false;

                }


                /*
                 * Dentist unavailable.
                 */

                if (!schedule.available) {

                    alert(
                            "The selected dentist is not "
                            + "available on "
                            + formatDay(schedule.day)
                            + "."

                            );


                    dateInput.focus();

                    return false;

                }


                /*
                 * Before working hours.
                 */

                if (
                        selectedTime
                        < schedule.start
                        ) {

                    alert(
                            "The dentist starts working at "
                            + schedule.start
                            + " on "
                            + formatDay(schedule.day)
                            + "."

                            );


                    timeInput.focus();

                    return false;

                }


                /*
                 * After working hours.
                 */

                if (
                        selectedTime
                        >= schedule.end
                        ) {

                    alert(
                            "The dentist's working hours are "
                            + schedule.start
                            + " to "
                            + schedule.end
                            + "."

                            );


                    timeInput.focus();

                    return false;

                }


                /*
                 * During break.
                 */

                if (
                        schedule.breakStart
                        &&
                        schedule.breakEnd
                        &&
                        selectedTime
                        >= schedule.breakStart
                        &&
                        selectedTime
                        < schedule.breakEnd
                        ) {

                    alert(
                            "The selected time is during the "
                            + "dentist's break from "
                            + schedule.breakStart
                            + " to "
                            + schedule.breakEnd
                            + "."

                            );


                    timeInput.focus();

                    return false;

                }


                /*
                 * Final confirmation.
                 */

                return true;

            }


            /*
             * =========================================================
             * DOCTOR CHANGE
             * =========================================================
             */

            doctorSelect.addEventListener(
                    "change",
                    function () {

                        displayDoctorSchedule();

                        /*
                         * Reset date/time when doctor changes.
                         */
                        dateInput.value = "";

                        timeInput.value = "";

                    }

            );


            /*
             * =========================================================
             * DATE CHANGE
             * =========================================================
             */

            dateInput.addEventListener(
                    "change",
                    function () {


                        const schedule =
                                getScheduleForSelectedDay();


                        /*
                         * If doctor has no schedule on this day,
                         * show warning.
                         */

                        if (
                                doctorSelect.value
                                &&
                                dateInput.value
                                &&
                                !schedule
                                ) {


                            const selectedDay =
                                    getSelectedDay();


                            scheduleInfo.innerHTML =
                                    '<i class="fa-solid fa-circle-exclamation"></i> '

                                    + '<strong>No working schedule on '
                                    + formatDay(selectedDay)
                                    + '.</strong> '

                                    + 'Please choose another date.';


                            return;

                        }


                        /*
                         * If schedule exists, show its hours.
                         */

                        if (schedule) {


                            scheduleInfo.innerHTML =
                                    '<i class="fa-solid fa-circle-check"></i> '

                                    + '<strong>Available on '
                                    + formatDay(schedule.day)
                                    + '.</strong> '

                                    + schedule.start
                                    + ' - '
                                    + schedule.end;


                            if (
                                    schedule.breakStart
                                    &&
                                    schedule.breakEnd
                                    ) {

                                scheduleInfo.innerHTML +=
                                        ' | Break: '
                                        + schedule.breakStart
                                        + ' - '
                                        + schedule.breakEnd;

                            }

                        }

                    }

            );


            /*
             * =========================================================
             * TIME CHANGE
             * =========================================================
             */

            timeInput.addEventListener(
                    "change",
                    function () {


                        if (!doctorSelect.value
                                || !dateInput.value
                                || !timeInput.value) {

                            return;

                        }


                        if (!isTimeAvailable()) {


                            const schedule =
                                    getScheduleForSelectedDay();


                            if (!schedule) {

                                return;

                            }


                            if (
                                    timeInput.value
                                    < schedule.start
                                    ||
                                    timeInput.value
                                    >= schedule.end
                                    ) {

                                alert(
                                        "Please select a time between "
                                        + schedule.start
                                        + " and "
                                        + schedule.end
                                        + "."

                                        );


                                timeInput.value = "";

                                return;

                            }


                            if (
                                    schedule.breakStart
                                    &&
                                    schedule.breakEnd
                                    &&
                                    timeInput.value
                                    >= schedule.breakStart
                                    &&
                                    timeInput.value
                                    < schedule.breakEnd
                                    ) {

                                alert(
                                        "The selected time is during "
                                        + "the dentist's break."
                                        + "\n\nBreak: "
                                        + schedule.breakStart
                                        + " - "
                                        + schedule.breakEnd

                                        );


                                timeInput.value = "";

                                return;

                            }

                        }

                    }

            );


            /*
             * =========================================================
             * INITIALIZE
             * =========================================================
             */

            displayDoctorSchedule();


        </script>


    </body>

</html>