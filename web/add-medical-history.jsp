<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="model.Appointment"%>


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

    Appointment appointment
            = (Appointment) request.getAttribute(
                    "appointment"
            );

    if (appointment == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/DoctorAppointmentsServlet"
        );

        return;
    }

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
            Add Medical History | Sunrise Dental Clinic
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


            .topbar {

                height:
                    72px;

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

                color:
                    #091e3e;

                font:
                    700 20px Jost,
                    sans-serif;

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;
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


            .container {

                width:
                    92%;

                max-width:
                    900px;

                margin:
                    30px auto;
            }


            .title {

                margin-bottom:
                    22px;
            }


            .title h1 {

                color:
                    #091e3e;

                font:
                    700 29px Jost,
                    sans-serif;
            }


            .title p {

                color:
                    #7b8794;

                font-size:
                    12px;

                margin-top:
                    5px;
            }


            .error {

                background:
                    #fff0f0;

                border:
                    1px solid #f0c4c4;

                color:
                    #a73535;

                padding:
                    13px;

                border-radius:
                    8px;

                margin-bottom:
                    20px;

                font-size:
                    12px;
            }


            /* =====================================================
               PATIENT BOX
               ===================================================== */

            .patient-box {

                background:
                    linear-gradient(
                    135deg,
                    #091e3e,
                    #06a3da
                    );

                color:
                    white;

                padding:
                    22px;

                border-radius:
                    12px;

                margin-bottom:
                    22px;
            }


            .patient-box h2 {

                font:
                    700 19px Jost,
                    sans-serif;

                margin-bottom:
                    15px;
            }


            .patient-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(3, 1fr);

                gap:
                    12px;
            }


            .patient-info {

                background:
                    rgba(255,255,255,.12);

                padding:
                    12px;

                border-radius:
                    7px;
            }


            .patient-info label {

                display:
                    block;

                font-size:
                    9px;

                opacity:
                    .75;

                text-transform:
                    uppercase;

                margin-bottom:
                    4px;
            }


            .patient-info strong {

                font-size:
                    12px;
            }


            /* =====================================================
               FORM
               ===================================================== */

            .form-card {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    12px;

                padding:
                    28px;

                box-shadow:
                    0 4px 18px
                    rgba(0,0,0,.04);
            }


            .form-title {

                color:
                    #091e3e;

                font:
                    700 19px Jost,
                    sans-serif;

                margin-bottom:
                    22px;
            }


            .form-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    18px;
            }


            .field {

                display:
                    flex;

                flex-direction:
                    column;
            }


            .field.full {

                grid-column:
                    1 / -1;
            }


            label {

                color:
                    #344054;

                font-size:
                    11px;

                font-weight:
                    600;

                margin-bottom:
                    7px;
            }


            .required {

                color:
                    #d93025;
            }


            input,
            textarea {

                width:
                    100%;

                border:
                    1px solid #d9e2ea;

                border-radius:
                    7px;

                padding:
                    11px 12px;

                outline:
                    none;

                font-family:
                    "Open Sans",
                    sans-serif;

                font-size:
                    12px;
            }


            input:focus,
            textarea:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px
                    rgba(6,163,218,.08);
            }


            textarea {

                min-height:
                    100px;

                resize:
                    vertical;
            }


            .actions {

                border-top:
                    1px solid #edf1f4;

                margin-top:
                    25px;

                padding-top:
                    20px;

                display:
                    flex;

                justify-content:
                    flex-end;

                gap:
                    10px;
            }


            .cancel {

                text-decoration:
                    none;

                background:
                    #eef2f5;

                color:
                    #596775;

                padding:
                    11px 18px;

                border-radius:
                    7px;

                font-size:
                    11px;

                font-weight:
                    600;
            }


            .save {

                border:
                    none;

                background:
                    #06a3da;

                color:
                    white;

                padding:
                    11px 20px;

                border-radius:
                    7px;

                cursor:
                    pointer;

                font-size:
                    11px;

                font-weight:
                    600;
            }


            .save:hover {

                background:
                    #078fc0;
            }


            @media(max-width: 700px) {

                .patient-grid,
                .form-grid {

                    grid-template-columns:
                        1fr;
                }


                .field.full {

                    grid-column:
                        auto;
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
                href="<%=request.getContextPath()%>/DoctorPatientDetailsServlet?appointmentId=<%=appointment.getId()%>"
                class="back">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Patient

            </a>


        </header>



        <main class="container">


            <div class="title">

                <h1>
                    Add Medical History
                </h1>

                <p>
                    Record the clinical information for this patient's visit.
                </p>

            </div>



            <% if ("empty".equalsIgnoreCase(error)) { %>

            <div class="error">

                <i class="fa-solid fa-triangle-exclamation"></i>

                Please enter at least one clinical field.

            </div>

            <% } %>



            <% if ("date".equalsIgnoreCase(error)) { %>

            <div class="error">

                <i class="fa-solid fa-triangle-exclamation"></i>

                Please enter a valid visit date.

            </div>

            <% } %>



            <% if ("database".equalsIgnoreCase(error)) { %>

            <div class="error">

                <i class="fa-solid fa-triangle-exclamation"></i>

                A database error occurred while saving the medical history.

            </div>

            <% }%>



            <!-- =====================================================
                 PATIENT
                 ===================================================== -->

            <div class="patient-box">


                <h2>

                    <i class="fa-solid fa-user"></i>

                    Patient Information

                </h2>


                <div class="patient-grid">


                    <div class="patient-info">

                        <label>
                            Patient
                        </label>

                        <strong>
                            <%=appointment.getPatientName()%>
                        </strong>

                    </div>


                    <div class="patient-info">

                        <label>
                            Appointment
                        </label>

                        <strong>
                            <%=appointment.getAppointmentNo()%>
                        </strong>

                    </div>


                    <div class="patient-info">

                        <label>
                            Treatment
                        </label>

                        <strong>
                            <%=appointment.getTreatmentType()%>
                        </strong>

                    </div>


                </div>


            </div>



            <!-- =====================================================
                 FORM
                 ===================================================== -->

            <div class="form-card">


                <div class="form-title">

                    <i class="fa-solid fa-file-medical"></i>

                    Clinical Record

                </div>



                <form
                    method="post"
                    action="<%=request.getContextPath()%>/AddMedicalHistoryServlet">


                    <!-- IMPORTANT -->
                    <!-- Appointment ID comes from the selected appointment -->

                    <input
                        type="hidden"
                        name="appointmentId"
                        value="<%=appointment.getId()%>">


                    <div class="form-grid">


                        <!-- DATE -->

                        <div class="field">

                            <label for="visitDate">

                                Visit Date

                                <span class="required">
                                    *
                                </span>

                            </label>


                            <input
                                type="date"
                                id="visitDate"
                                name="visitDate"
                                value="<%=appointment.getAppointmentDate()%>"
                                required>

                        </div>



                        <!-- SYMPTOMS -->

                        <div class="field">

                            <label for="symptoms">

                                Symptoms

                            </label>


                            <input
                                type="text"
                                id="symptoms"
                                name="symptoms"
                                maxlength="1000"
                                placeholder="Enter patient symptoms">

                        </div>



                        <!-- DIAGNOSIS -->

                        <div class="field full">

                            <label for="diagnosis">

                                Diagnosis

                            </label>


                            <textarea
                                id="diagnosis"
                                name="diagnosis"
                                maxlength="1000"
                                placeholder="Enter diagnosis"></textarea>

                        </div>



                        <!-- TREATMENT -->

                        <div class="field full">

                            <label for="treatment">

                                Treatment Provided

                            </label>


                            <textarea
                                id="treatment"
                                name="treatment"
                                maxlength="1000"
                                placeholder="Enter treatment or procedure"></textarea>

                        </div>



                        <!-- ALLERGIES -->

                        <div class="field">

                            <label for="allergies">

                                Allergies

                            </label>


                            <textarea
                                id="allergies"
                                name="allergies"
                                maxlength="1000"
                                placeholder="Known allergies"></textarea>

                        </div>



                        <!-- MEDICATIONS -->

                        <div class="field">

                            <label for="medications">

                                Medications

                            </label>


                            <textarea
                                id="medications"
                                name="medications"
                                maxlength="1000"
                                placeholder="Current medications"></textarea>

                        </div>



                        <!-- MEDICAL CONDITIONS -->

                        <div class="field full">

                            <label for="medicalConditions">

                                Medical Conditions

                            </label>


                            <textarea
                                id="medicalConditions"
                                name="medicalConditions"
                                maxlength="1000"
                                placeholder="Relevant medical conditions"></textarea>

                        </div>



                        <!-- NOTES -->

                        <div class="field full">

                            <label for="notes">

                                Clinical Notes

                            </label>


                            <textarea
                                id="notes"
                                name="notes"
                                maxlength="5000"
                                placeholder="Additional clinical observations, follow-up instructions or notes"></textarea>

                        </div>


                    </div>



                    <div class="actions">


                        <a
                            href="<%=request.getContextPath()%>/DoctorPatientDetailsServlet?appointmentId=<%=appointment.getId()%>"
                            class="cancel">

                            Cancel

                        </a>


                        <button
                            type="submit"
                            class="save">

                            <i class="fa-solid fa-floppy-disk"></i>

                            Save Medical History

                        </button>


                    </div>


                </form>


            </div>


        </main>


    </body>

</html>