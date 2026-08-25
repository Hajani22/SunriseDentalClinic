<%@page import="java.util.List"%>
<%@page import="model.DoctorOption"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String role
            = (String) session.getAttribute("userRole");

    if (!"patient".equals(role)) {
        response.sendRedirect(
                "Login.jsp?error=access"
        );
        return;
    }

    String userName
            = (String) session.getAttribute("userName");

    List<DoctorOption> doctors
            = (List<DoctorOption>) request.getAttribute("doctors");

    String error
            = request.getParameter("error");
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Book Appointment | Sunrise Dental Clinic</title>

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
                font: 700 25px Jost;
                color: #091e3e;
            }

            .content {
                padding: 32px;
            }

            .form-card {
                background: white;
                border: 1px solid #e5ebf0;
                border-radius: 14px;
                padding: 30px;
                max-width: 1000px;
                margin: auto;
            }

            .form-title {
                color: #091e3e;
                font: 700 28px Jost;
                margin-bottom: 8px;
            }

            .form-subtitle {
                color: #7a8795;
                margin-bottom: 28px;
            }

            .grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .full {
                grid-column: 1 / -1;
            }

            label {
                display: block;
                color: #091e3e;
                font-weight: 600;
                margin-bottom: 8px;
            }

            input,
            select,
            textarea {
                width: 100%;
                padding: 13px 14px;
                border: 1px solid #d7e0e8;
                border-radius: 8px;
                font-family: inherit;
                font-size: 14px;
                outline: none;
            }

            input:focus,
            select:focus,
            textarea:focus {
                border-color: #06a3da;
            }

            textarea {
                min-height: 100px;
                resize: vertical;
            }

            .doctor-note {
                margin-top: 7px;
                font-size: 12px;
                color: #82909e;
            }

            .alert {
                padding: 14px 16px;
                background: #fff1f1;
                border: 1px solid #ffcaca;
                color: #b42318;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .submit-btn {
                width: 100%;
                border: none;
                background: #06a3da;
                color: white;
                padding: 15px;
                border-radius: 8px;
                margin-top: 25px;
                font-weight: 700;
                font-size: 15px;
                cursor: pointer;
            }

            .submit-btn:hover {
                background: #0589b8;
            }

            @media(max-width: 800px) {

                .sidebar {
                    width: 70px;
                    padding: 20px 10px;
                }

                .brand span,
                .menu span {
                    display: none;
                }

                .main {
                    margin-left: 70px;
                    width: calc(100% - 70px);
                }

                .grid {
                    grid-template-columns: 1fr;
                }

                .full {
                    grid-column: auto;
                }

                .content {
                    padding: 20px;
                }
            }

        </style>

    </head>

    <body>

        <div class="layout">

            <aside class="sidebar">

                <div class="brand">
                    <i class="fa-solid fa-tooth"></i>
                    <span>Sunrise Dental</span>
                </div>

                <nav class="menu">

                    <a href="patient-dashboard.jsp">
                        <i class="fa-solid fa-gauge"></i>
                        <span>Dashboard</span>
                    </a>

                    <a class="active"
                       href="BookAppointmentServlet">
                        <i class="fa-solid fa-calendar-plus"></i>
                        <span>Book Appointment</span>
                    </a>

                    <a href="PatientAppointmentsServlet">
                        <i class="fa-solid fa-calendar-check"></i>
                        <span>My Appointments</span>
                    </a>

                    <a href="PatientNotificationsServlet">
                        <i class="fa-solid fa-bell"></i>
                        <span>Notifications</span>
                    </a>

                </nav>

                <div class="logout">

                    <a href="LogoutServlet">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        <span> Logout</span>
                    </a>

                </div>

            </aside>


            <main class="main">

                <header class="topbar">

                    <h2>Book Appointment</h2>

                    <div>
                        <strong><%=userName%></strong>
                        <small>Patient</small>
                    </div>

                </header>


                <section class="content">

                    <div class="form-card">

                        <h1 class="form-title">
                            Book an Appointment
                        </h1>

                        <p class="form-subtitle">
                            Choose your preferred doctor, treatment,
                            date and time.
                        </p>


                        <% if ("slot".equals(error)) { %>

                        <div class="alert">
                            The selected doctor is already booked
                            at this time. Please select another
                            date or time.
                        </div>

                        <% } %>


                        <% if ("server".equals(error)) { %>

                        <div class="alert">
                            Something went wrong while creating
                            your appointment. Please try again.
                        </div>

                        <% } %>

                        <% if ("database".equals(error)) { %>

                        <div class="alert">
                            Database error. Please make sure the
                            appointments table exists and MySQL is running.
                        </div>

                        <% } %>

                        <% if ("empty".equals(error)) { %>

                        <div class="alert">
                            Please complete all required appointment fields.
                        </div>

                        <% } %>

                        <% if ("doctor".equals(error)) { %>

                        <div class="alert">
                            Please select a valid doctor.
                        </div>

                        <% } %>

                        <% if ("invalid".equals(error)) { %>

                        <div class="alert">
                            Please check the appointment date and time.
                        </div>

                        <% } %>


                        <form
                            method="post"
                            action="BookAppointmentServlet"
                            onsubmit="return validateForm();">


                            <div class="grid">


                                <div class="full">

                                    <label>
                                        Select Doctor *
                                    </label>

                                    <select
                                        name="doctorId"
                                        required>

                                        <option value="">
                                            -- Select Doctor --
                                        </option>

                                        <%
                                            if (doctors != null) {

                                                for (DoctorOption doctor : doctors) {
                                        %>

                                        <option value="<%=doctor.getId()%>">

                                            Dr. <%=doctor.getName()%>

                                            <%
                                                if (doctor.getSpecialization() != null
                                                        && !doctor.getSpecialization()
                                                                .trim()
                                                                .isEmpty()) {
                                            %>

                                            - <%=doctor.getSpecialization()%>

                                            <%
                                                }
                                            %>

                                        </option>

                                        <%
                                                }
                                            }
                                        %>

                                    </select>

                                    <div class="doctor-note">
                                        Doctor details are loaded directly
                                        from the database.
                                    </div>

                                </div>


                                <div>

                                    <label>
                                        Treatment *
                                    </label>

                                    <select
                                        name="treatmentType"
                                        required>

                                        <option value="">
                                            -- Select Treatment --
                                        </option>

                                        <option>Dental Consultation</option>
                                        <option>Dental Cleaning</option>
                                        <option>Tooth Filling</option>
                                        <option>Tooth Extraction</option>
                                        <option>Root Canal Treatment</option>
                                        <option>Dental X-Ray</option>
                                        <option>Other</option>

                                    </select>

                                </div>


                                <div>

                                    <label>
                                        Appointment Date *
                                    </label>

                                    <input
                                        type="date"
                                        id="appointmentDate"
                                        name="appointmentDate"
                                        required>

                                </div>


                                <div>

                                    <label>
                                        Appointment Time *
                                    </label>

                                    <input
                                        type="time"
                                        name="appointmentTime"
                                        min="08:00"
                                        max="18:00"
                                        step="1800"
                                        required>

                                </div>


                                <div>

                                    <label>
                                        Phone Number
                                    </label>

                                    <input
                                        type="text"
                                        name="phone"
                                        placeholder="Enter phone number">

                                </div>


                                <div>

                                    <label>
                                        Address
                                    </label>

                                    <input
                                        type="text"
                                        name="address"
                                        placeholder="Enter address">

                                </div>


                            </div>


                            <button
                                type="submit"
                                class="submit-btn">

                                <i class="fa-solid fa-calendar-check"></i>

                                Send Appointment Request

                            </button>

                        </form>

                    </div>

                </section>

            </main>

        </div>


        <script>

            const dateInput =
                    document.getElementById(
                            "appointmentDate"
                            );

            const today =
                    new Date()
                    .toISOString()
                    .split("T")[0];

            dateInput.min = today;


            function validateForm() {

                if (!dateInput.value) {

                    alert(
                            "Please select an appointment date."
                            );

                    return false;
                }

                if (dateInput.value < today) {

                    alert(
                            "Please select a future date."
                            );

                    return false;
                }

                return true;
            }

        </script>

    </body>

</html>