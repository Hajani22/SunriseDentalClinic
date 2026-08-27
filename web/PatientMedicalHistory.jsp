<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="model.MedicalHistory"%>

<%
    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }

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

    List<MedicalHistory> historyList
            = (List<MedicalHistory>) request.getAttribute(
                    "medicalHistory"
            );

    String errorMessage
            = (String) request.getAttribute(
                    "errorMessage"
            );
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Patient Medical History | Sunrise Dental Clinic
        </title>


        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }


            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f5f8fb;

                color:
                    #555;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                position: fixed;

                left: 0;

                top: 0;

                bottom: 0;

                width: 250px;

                background:
                    #0b1f44;

                color: white;

                padding: 25px 18px;
            }


            .brand {

                display: flex;

                align-items: center;

                gap: 10px;

                margin-bottom: 35px;

                color: white;

                font-family: Jost;

                font-size: 20px;

                font-weight: 700;
            }


            .brand-icon {

                width: 42px;

                height: 42px;

                display: flex;

                align-items: center;

                justify-content: center;

                background: #149ddd;

                border-radius: 10px;
            }


            .menu a {

                display: flex;

                align-items: center;

                gap: 12px;

                color: #c9d5e5;

                text-decoration: none;

                padding: 13px 14px;

                margin-bottom: 6px;

                border-radius: 8px;

                font-size: 13px;
            }


            .menu a:hover {

                background:
                    rgba(20,157,221,0.15);

                color: white;
            }


            .menu a.active {

                background:
                    #149ddd;

                color: white;
            }


            .menu i {

                width: 18px;

                text-align: center;
            }


            .logout {

                position: absolute;

                left: 18px;

                right: 18px;

                bottom: 25px;
            }


            .logout a {

                display: block;

                color: #ffbaba;

                text-decoration: none;

                padding: 12px;
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left: 250px;

                min-height: 100vh;
            }


            .topbar {

                height: 72px;

                background: white;

                border-bottom:
                    1px solid #e5ebf0;

                display: flex;

                align-items: center;

                justify-content: space-between;

                padding: 0 32px;

                position: sticky;

                top: 0;

                z-index: 10;
            }


            .topbar h1 {

                font-family: Jost;

                font-size: 24px;

                color: #0b1f44;
            }


            .patient-label {

                font-size: 13px;

                color: #718096;
            }


            .content {

                padding: 32px;
            }


            /* =====================================================
               PAGE INTRO
               ===================================================== */

            .page-intro {

                background:
                    linear-gradient(
                    135deg,
                    #0b1f44,
                    #149ddd
                    );

                color: white;

                padding: 30px;

                border-radius: 14px;

                margin-bottom: 25px;
            }


            .page-intro h2 {

                font-family: Jost;

                font-size: 27px;

                margin-bottom: 8px;
            }


            .page-intro p {

                font-size: 13px;

                opacity: .9;

                max-width: 700px;
            }


            /* =====================================================
               INFORMATION NOTICE
               ===================================================== */

            .notice {

                background: #eef8fc;

                border:
                    1px solid #ccebf7;

                color: #315b6c;

                padding: 14px 17px;

                border-radius: 8px;

                margin-bottom: 20px;

                font-size: 12px;

                display: flex;

                gap: 10px;

                align-items: flex-start;
            }


            .notice i {

                color: #149ddd;

                margin-top: 3px;
            }


            /* =====================================================
               ERROR
               ===================================================== */

            .error {

                background: #fff0f0;

                color: #a33a3a;

                border:
                    1px solid #f1c4c4;

                padding: 14px;

                border-radius: 8px;

                margin-bottom: 20px;
            }


            /* =====================================================
               HISTORY
               ===================================================== */

            .history-list {

                display: flex;

                flex-direction: column;

                gap: 18px;
            }


            .history-card {

                background: white;

                border:
                    1px solid #e5ebf0;

                border-radius: 12px;

                overflow: hidden;

                box-shadow:
                    0 4px 15px
                    rgba(16,42,67,.04);
            }


            .history-header {

                display: flex;

                justify-content: space-between;

                align-items: center;

                padding: 18px 22px;

                background: #fbfdff;

                border-bottom:
                    1px solid #edf1f4;
            }


            .date {

                display: flex;

                align-items: center;

                gap: 10px;

                color: #0b1f44;

                font-family: Jost;

                font-weight: 600;

                font-size: 15px;
            }


            .date i {

                color: #149ddd;
            }


            .doctor {

                font-size: 12px;

                color: #718096;
            }


            .history-body {

                padding: 22px;

                display: grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap: 18px;
            }


            .field {

                border:
                    1px solid #edf1f4;

                border-radius: 8px;

                padding: 15px;

                background: #fff;
            }


            .field.full {

                grid-column:
                    1 / -1;
            }


            .field-label {

                color: #149ddd;

                font-size: 11px;

                text-transform: uppercase;

                letter-spacing: .5px;

                font-weight: 700;

                margin-bottom: 6px;
            }


            .field-value {

                color: #4a5568;

                font-size: 13px;

                line-height: 1.7;

                white-space: pre-wrap;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                background: white;

                border:
                    1px solid #e5ebf0;

                border-radius: 12px;

                text-align: center;

                padding: 55px 20px;
            }


            .empty-icon {

                width: 65px;

                height: 65px;

                margin: auto;

                border-radius: 50%;

                display: flex;

                align-items: center;

                justify-content: center;

                background: #eaf7fc;

                color: #149ddd;

                font-size: 25px;

                margin-bottom: 15px;
            }


            .empty h3 {

                color: #0b1f44;

                font-family: Jost;

                margin-bottom: 7px;
            }


            .empty p {

                font-size: 12px;

                color: #7b8794;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width: 900px) {

                .sidebar {

                    width: 70px;

                    padding: 20px 10px;
                }


                .brand span,
                .menu span,
                .logout span {

                    display: none;
                }


                .brand {

                    justify-content: center;
                }


                .menu a {

                    justify-content: center;
                }


                .main {

                    margin-left: 70px;
                }


                .history-body {

                    grid-template-columns: 1fr;
                }


                .field.full {

                    grid-column: auto;
                }
            }


            @media(max-width: 600px) {

                .content {

                    padding: 18px;
                }


                .topbar {

                    padding: 0 18px;
                }


                .topbar h1 {

                    font-size: 19px;
                }


                .patient-label {

                    display: none;
                }


                .history-header {

                    flex-direction: column;

                    align-items: flex-start;

                    gap: 7px;
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


                <a href="PatientAppointmentsServlet">

                    <i class="fa-solid fa-calendar-check"></i>

                    <span>
                        My Appointments
                    </span>

                </a>


                <a
                    class="active"
                    href="PatientMedicalHistoryServlet">

                    <i class="fa-solid fa-file-medical"></i>

                    <span>
                        Medical History
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



        <!-- =========================================================
             MAIN
             ========================================================= -->

        <main class="main">


            <header class="topbar">


                <h1>
                    Patient Medical History
                </h1>


                <div class="patient-label">

                    <i class="fa-solid fa-shield-halved"></i>

                    Private Medical Record

                </div>


            </header>



            <div class="content">


                <!-- INTRO -->

                <div class="page-intro">

                    <h2>
                        My Medical History
                    </h2>

                    <p>

                        View your previous dental visits, diagnoses,
                        treatments, allergies, medications and clinical
                        notes recorded by your dental care team.

                    </p>

                </div>



                <!-- PRIVACY NOTICE -->

                <div class="notice">

                    <i class="fa-solid fa-lock"></i>

                    <span>

                        Your medical history is private and can only be
                        accessed by authorised users of the Sunrise Dental
                        Clinic system.

                    </span>

                </div>



                <!-- ERROR -->

                <% if (errorMessage != null) {%>

                <div class="error">

                    <i class="fa-solid fa-triangle-exclamation"></i>

                    <%=errorMessage%>

                </div>

                <% } %>



                <!-- HISTORY -->

                <div class="history-list">


                    <%
                        if (historyList != null
                                && !historyList.isEmpty()) {

                            for (MedicalHistory history
                                    : historyList) {
                    %>


                    <div class="history-card">


                        <!-- HEADER -->

                        <div class="history-header">


                            <div class="date">

                                <i class="fa-solid fa-calendar-days"></i>

                                <span>

                                    <%=history.getVisitDate()%>

                                </span>

                            </div>


                            <div class="doctor">

                                <i class="fa-solid fa-user-doctor"></i>

                                Doctor:

                                <strong>

                                    <%=history.getDoctorName() != null
                                            ? history.getDoctorName()
                                            : "Clinic Staff"%>

                                </strong>

                            </div>


                        </div>



                        <!-- BODY -->

                        <div class="history-body">


                            <!-- SYMPTOMS -->

                            <% if (history.getSymptoms() != null
                                    && !history.getSymptoms()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Symptoms

                                </div>


                                <div class="field-value">

                                    <%=history.getSymptoms()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- DIAGNOSIS -->

                            <% if (history.getDiagnosis() != null
                                    && !history.getDiagnosis()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Diagnosis

                                </div>


                                <div class="field-value">

                                    <%=history.getDiagnosis()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- TREATMENT -->

                            <% if (history.getTreatment() != null
                                    && !history.getTreatment()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Treatment

                                </div>


                                <div class="field-value">

                                    <%=history.getTreatment()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- ALLERGIES -->

                            <% if (history.getAllergies() != null
                                    && !history.getAllergies()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Allergies

                                </div>


                                <div class="field-value">

                                    <%=history.getAllergies()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- MEDICATIONS -->

                            <% if (history.getMedications() != null
                                    && !history.getMedications()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Current Medications

                                </div>


                                <div class="field-value">

                                    <%=history.getMedications()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- MEDICAL CONDITIONS -->

                            <% if (history.getMedicalConditions() != null
                                    && !history.getMedicalConditions()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field">


                                <div class="field-label">

                                    Medical Conditions

                                </div>


                                <div class="field-value">

                                    <%=history.getMedicalConditions()%>

                                </div>


                            </div>


                            <% } %>



                            <!-- NOTES -->

                            <% if (history.getNotes() != null
                                    && !history.getNotes()
                                            .trim()
                                            .isEmpty()) {%>


                            <div class="field full">


                                <div class="field-label">

                                    Clinical Notes

                                </div>


                                <div class="field-value">

                                    <%=history.getNotes()%>

                                </div>


                            </div>


                            <% } %>


                        </div>


                    </div>


                    <%
                        }

                    } else {
                    %>


                    <!-- EMPTY -->

                    <div class="empty">


                        <div class="empty-icon">

                            <i class="fa-solid fa-file-medical"></i>

                        </div>


                        <h3>
                            No Medical History Available
                        </h3>


                        <p>

                            Your dental medical history has not been
                            recorded yet.

                        </p>


                    </div>


                    <%
                        }
                    %>


                </div>


            </div>


        </main>


    </body>

</html>