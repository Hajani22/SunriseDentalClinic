<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.MedicalHistory"%>

<%
    /*
     * =====================================================
     * LOGIN CHECK
     * =====================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp"
        );

        return;
    }


    /*
     * =====================================================
     * DOCTOR CHECK
     * =====================================================
     */
    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"doctor".equalsIgnoreCase(role)) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }


    /*
     * =====================================================
     * GET DATA
     * =====================================================
     */
    Appointment appointment
            = (Appointment) request.getAttribute(
                    "appointment"
            );

    List<MedicalHistory> historyList
            = (List<MedicalHistory>) request.getAttribute(
                    "medicalHistory"
            );


    /*
     * =====================================================
     * SAFETY CHECK
     * =====================================================
     */
    if (appointment == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/DoctorAppointmentsServlet"
        );

        return;
    }

    String success
            = request.getParameter("success");

    String error
            = request.getParameter("error");
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0">

        <title>
            Patient Details | Sunrise Dental Clinic
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
                    #f4f8fb;

                color:
                    #555;
            }


            /* =====================================================
               HEADER
               ===================================================== */

            .topbar {

                height: 72px;

                background:
                    white;

                border-bottom:
                    1px solid #e5ebf0;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;

                padding:
                    0 35px;
            }


            .brand {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;

                color:
                    #091e3e;

                font:
                    700 20px Jost,
                    sans-serif;
            }


            .brand i {

                background:
                    #06a3da;

                color:
                    white;

                padding:
                    11px;

                border-radius:
                    8px;
            }


            .back {

                color:
                    #06a3da;

                text-decoration:
                    none;

                font-size:
                    12px;

                font-weight:
                    600;
            }


            .back:hover {

                text-decoration:
                    underline;
            }


            /* =====================================================
               CONTAINER
               ===================================================== */

            .container {

                width:
                    92%;

                max-width:
                    1100px;

                margin:
                    30px auto;
            }


            .page-title {

                margin-bottom:
                    22px;
            }


            .page-title h1 {

                color:
                    #091e3e;

                font:
                    700 29px Jost,
                    sans-serif;
            }


            .page-title p {

                color:
                    #7b8794;

                font-size:
                    12px;

                margin-top:
                    5px;
            }


            /* =====================================================
               MESSAGES
               ===================================================== */

            .success {

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
            }


            .error {

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
            }


            /* =====================================================
               CARD
               ===================================================== */

            .card {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    12px;

                padding:
                    25px;

                margin-bottom:
                    22px;

                box-shadow:
                    0 4px 18px
                    rgba(0,0,0,.04);
            }


            .card-title {

                color:
                    #091e3e;

                font:
                    700 19px Jost,
                    sans-serif;

                margin-bottom:
                    18px;
            }


            /* =====================================================
               PATIENT INFORMATION
               ===================================================== */

            .info-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(3, 1fr);

                gap:
                    14px;
            }


            .info-box {

                background:
                    #f8fbfd;

                border:
                    1px solid #edf2f5;

                border-radius:
                    8px;

                padding:
                    15px;
            }


            .info-box label {

                display:
                    block;

                color:
                    #06a3da;

                font-size:
                    9px;

                font-weight:
                    700;

                text-transform:
                    uppercase;

                margin-bottom:
                    5px;
            }


            .info-box strong {

                color:
                    #27364a;

                font-size:
                    12px;
            }


            /* =====================================================
               HISTORY HEADER
               ===================================================== */

            .history-header {

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;

                margin-bottom:
                    18px;
            }


            .history-header .card-title {

                margin:
                    0;
            }


            .add-button {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    7px;

                background:
                    #06a3da;

                color:
                    white;

                text-decoration:
                    none;

                padding:
                    10px 15px;

                border-radius:
                    7px;

                font-size:
                    11px;

                font-weight:
                    600;
            }


            .add-button:hover {

                background:
                    #078fc0;
            }


            /* =====================================================
               HISTORY CARD
               ===================================================== */

            .history-item {

                border:
                    1px solid #e5ebf0;

                border-radius:
                    9px;

                overflow:
                    hidden;

                margin-bottom:
                    15px;
            }


            .history-top {

                background:
                    #f7fafc;

                padding:
                    13px 16px;

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

                border-bottom:
                    1px solid #e5ebf0;
            }


            .history-date {

                color:
                    #091e3e;

                font:
                    600 13px Jost,
                    sans-serif;
            }


            .history-doctor {

                color:
                    #7b8794;

                font-size:
                    11px;
            }


            .history-body {

                padding:
                    17px;

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    14px;
            }


            .history-field {

                border:
                    1px solid #edf1f4;

                border-radius:
                    7px;

                padding:
                    13px;
            }


            .history-field.full {

                grid-column:
                    1 / -1;
            }


            .history-field label {

                display:
                    block;

                color:
                    #06a3da;

                font-size:
                    9px;

                text-transform:
                    uppercase;

                font-weight:
                    700;

                margin-bottom:
                    6px;
            }


            .history-field p {

                color:
                    #555;

                font-size:
                    12px;

                line-height:
                    1.7;

                white-space:
                    pre-wrap;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                text-align:
                    center;

                padding:
                    45px 20px;

                color:
                    #7b8794;
            }


            .empty i {

                color:
                    #06a3da;

                font-size:
                    38px;

                margin-bottom:
                    12px;
            }


            .empty h3 {

                color:
                    #091e3e;

                font:
                    600 18px Jost,
                    sans-serif;

                margin-bottom:
                    5px;
            }


            .empty p {

                font-size:
                    11px;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width: 750px) {

                .info-grid,
                .history-body {

                    grid-template-columns:
                        1fr;
                }


                .history-field.full {

                    grid-column:
                        auto;
                }


                .history-header {

                    align-items:
                        flex-start;

                    flex-direction:
                        column;

                    gap:
                        12px;
                }

            }

        </style>

    </head>


    <body>


        <header class="topbar">


            <div class="brand">

                <i class="fa-solid fa-tooth"></i>

                Sunrise Dental Clinic

            </div>


            <a
                href="<%=request.getContextPath()%>/DoctorAppointmentsServlet"
                class="back">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Appointments

            </a>


        </header>



        <main class="container">


            <!-- =====================================================
                 PAGE TITLE
                 ===================================================== -->

            <div class="page-title">

                <h1>
                    Patient Details
                </h1>

                <p>
                    Review appointment information and medical history.
                </p>

            </div>



            <!-- =====================================================
                 SUCCESS
                 ===================================================== -->

            <% if ("history".equalsIgnoreCase(success)) { %>

            <div class="success">

                <i class="fa-solid fa-circle-check"></i>

                Medical history saved successfully.

            </div>

            <% } %>



            <!-- =====================================================
                 ERROR
                 ===================================================== -->

            <% if ("database".equalsIgnoreCase(error)) { %>

            <div class="error">

                <i class="fa-solid fa-triangle-exclamation"></i>

                Unable to load the patient information.

            </div>

            <% }%>



            <!-- =====================================================
                 PATIENT INFORMATION
                 ===================================================== -->

            <div class="card">


                <div class="card-title">

                    <i class="fa-solid fa-user"></i>

                    Patient Information

                </div>


                <div class="info-grid">


                    <div class="info-box">

                        <label>
                            Patient Name
                        </label>

                        <strong>
                            <%=appointment.getPatientName()%>
                        </strong>

                    </div>


                    <div class="info-box">

                        <label>
                            Phone
                        </label>

                        <strong>
                            <%=appointment.getPatientPhone()%>
                        </strong>

                    </div>


                    <div class="info-box">

                        <label>
                            Appointment No
                        </label>

                        <strong>
                            <%=appointment.getAppointmentNo()%>
                        </strong>

                    </div>


                    <div class="info-box">

                        <label>
                            Treatment
                        </label>

                        <strong>
                            <%=appointment.getTreatmentType()%>
                        </strong>

                    </div>


                    <div class="info-box">

                        <label>
                            Appointment Date
                        </label>

                        <strong>
                            <%=appointment.getAppointmentDate()%>
                        </strong>

                    </div>


                    <div class="info-box">

                        <label>
                            Appointment Time
                        </label>

                        <strong>
                            <%=appointment.getAppointmentTime()%>
                        </strong>

                    </div>


                </div>


            </div>



            <!-- =====================================================
                 MEDICAL HISTORY
                 ===================================================== -->

            <div class="card">


                <div class="history-header">


                    <div class="card-title">

                        <i class="fa-solid fa-file-medical"></i>

                        Patient Medical History

                    </div>


                    <a
                        href="<%=request.getContextPath()%>/AddMedicalHistoryServlet?appointmentId=<%=appointment.getId()%>"
                        class="add-button">

                        <i class="fa-solid fa-plus"></i>

                        Add Medical History

                    </a>


                </div>



                <% if (historyList != null
                    && !historyList.isEmpty()) { %>


                <% for (MedicalHistory history : historyList) {%>


                <div class="history-item">


                    <div class="history-top">


                        <div class="history-date">

                            <i class="fa-solid fa-calendar-days"></i>

                            <%=history.getVisitDate()%>

                        </div>


                        <div class="history-doctor">

                            <i class="fa-solid fa-user-doctor"></i>

                            Doctor:

                            <strong>

                                <%=history.getDoctorName() != null
                                        ? history.getDoctorName()
                                        : "Clinic Doctor"%>

                            </strong>

                        </div>


                    </div>



                    <div class="history-body">


                        <% if (history.getSymptoms() != null
                                    && !history.getSymptoms().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Symptoms
                            </label>

                            <p>
                                <%=history.getSymptoms()%>
                            </p>

                        </div>

                        <% } %>



                        <% if (history.getDiagnosis() != null
                                    && !history.getDiagnosis().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Diagnosis
                            </label>

                            <p>
                                <%=history.getDiagnosis()%>
                            </p>

                        </div>

                        <% } %>



                        <% if (history.getTreatment() != null
                                    && !history.getTreatment().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Treatment
                            </label>

                            <p>
                                <%=history.getTreatment()%>
                            </p>

                        </div>

                        <% } %>



                        <% if (history.getAllergies() != null
                                    && !history.getAllergies().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Allergies
                            </label>

                            <p>
                                <%=history.getAllergies()%>
                            </p>

                        </div>

                        <% } %>



                        <% if (history.getMedications() != null
                                    && !history.getMedications().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Medications
                            </label>

                            <p>
                                <%=history.getMedications()%>
                            </p>

                        </div>

                        <% } %>



                        <% if (history.getMedicalConditions() != null
                                    && !history.getMedicalConditions().trim().isEmpty()) {%>

                        <div class="history-field">

                            <label>
                                Medical Conditions
                            </label>

                            <p>
                                <%=history.getMedicalConditions()%>

                            </p>

                        </div>

                        <% } %>



                        <% if (history.getNotes() != null
                                    && !history.getNotes().trim().isEmpty()) {%>

                        <div class="history-field full">

                            <label>
                                Clinical Notes
                            </label>

                            <p>
                                <%=history.getNotes()%>
                            </p>

                        </div>

                        <% } %>


                    </div>


                </div>


                <% } %>


                <% } else { %>


                <div class="empty">

                    <i class="fa-solid fa-file-circle-plus"></i>

                    <h3>
                        No Medical History Yet
                    </h3>

                    <p>
                        No medical history has been recorded for this patient.
                    </p>

                </div>


                <% }%>


            </div>


        </main>


    </body>

</html>