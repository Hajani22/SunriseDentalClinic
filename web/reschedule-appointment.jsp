<%@page import="model.Appointment"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * LOGIN CHECK
     * =========================================================
     */

    if (session.getAttribute("user") == null) {

        response.sendRedirect("Login.jsp");

        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute(
                            "userRole"
                    )
            );


    /*
     * Only patients can reschedule
     */
    if (!"patient".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /*
     * Appointment received from servlet
     */
    Appointment appointment
            = (Appointment) request.getAttribute(
                    "appointment"
            );


    /*
     * If appointment does not exist
     */
    if (appointment == null) {

        response.sendRedirect(
                "PatientAppointmentsServlet"
                + "?error=invalid"
        );

        return;
    }

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
            Reschedule Appointment |
            Sunrise Dental Clinic
        </title>


        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

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
                    #334155;

                min-height:
                    100vh;
            }


            .page {

                width:
                    min(760px, 94%);

                margin:
                    45px auto;
            }


            .card {

                background:
                    #ffffff;

                border-radius:
                    16px;

                padding:
                    32px;

                box-shadow:
                    0 10px 30px
                    rgba(15,23,42,.08);

                border:
                    1px solid #e5ebf0;
            }


            .back-link {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    7px;

                text-decoration:
                    none;

                color:
                    #64748b;

                font-size:
                    14px;

                font-weight:
                    600;

                margin-bottom:
                    20px;
            }


            .back-link:hover {

                color:
                    #06a3da;
            }


            h1 {

                font:
                    700 29px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    7px;
            }


            .subtitle {

                color:
                    #64748b;

                line-height:
                    1.6;

                margin-bottom:
                    25px;
            }


            /*
             * =====================================================
             * ERROR MESSAGE
             * =====================================================
             */

            .error {

                background:
                    #fee2e2;

                border:
                    1px solid #fecaca;

                color:
                    #991b1b;

                padding:
                    13px 15px;

                border-radius:
                    9px;

                margin-bottom:
                    20px;

                font-size:
                    14px;

                font-weight:
                    600;
            }


            /*
             * =====================================================
             * APPOINTMENT INFORMATION
             * =====================================================
             */

            .appointment-info {

                background:
                    #f1f8fb;

                border:
                    1px solid #dceef5;

                border-radius:
                    12px;

                padding:
                    20px;

                margin-bottom:
                    25px;
            }


            .appointment-info h3 {

                font:
                    700 18px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    15px;
            }


            .info-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    12px;
            }


            .info-item {

                background:
                    white;

                padding:
                    13px;

                border-radius:
                    8px;
            }


            .info-item label {

                display:
                    block;

                color:
                    #7b8794;

                font-size:
                    12px;

                margin-bottom:
                    5px;

                font-weight:
                    600;
            }


            .info-item strong {

                color:
                    #091e3e;

                font-size:
                    14px;
            }


            /*
             * =====================================================
             * FORM
             * =====================================================
             */

            .form-title {

                font:
                    700 20px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    16px;
            }


            .form-group {

                margin-bottom:
                    18px;
            }


            .form-group label {

                display:
                    block;

                color:
                    #091e3e;

                font-size:
                    14px;

                font-weight:
                    700;

                margin-bottom:
                    7px;
            }


            .form-group input {

                width:
                    100%;

                height:
                    46px;

                padding:
                    0 13px;

                border:
                    1px solid #d7e1e8;

                border-radius:
                    8px;

                font:
                    14px "Open Sans",
                    sans-serif;

                color:
                    #334155;

                outline:
                    none;

                background:
                    #ffffff;
            }


            .form-group input:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px
                    rgba(6,163,218,.10);
            }


            /*
             * =====================================================
             * INFORMATION BOX
             * =====================================================
             */

            .notice {

                display:
                    flex;

                gap:
                    10px;

                align-items:
                    flex-start;

                background:
                    #fff8dc;

                border:
                    1px solid #f4df8b;

                color:
                    #7c5c00;

                padding:
                    14px;

                border-radius:
                    9px;

                font-size:
                    13px;

                line-height:
                    1.6;

                margin-bottom:
                    22px;
            }


            .notice i {

                margin-top:
                    2px;
            }


            /*
             * =====================================================
             * BUTTONS
             * =====================================================
             */

            .buttons {

                display:
                    flex;

                gap:
                    12px;

                flex-wrap:
                    wrap;

                margin-top:
                    25px;
            }


            .btn {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    8px;

                min-height:
                    45px;

                padding:
                    0 18px;

                border-radius:
                    8px;

                border:
                    none;

                text-decoration:
                    none;

                font-size:
                    14px;

                font-weight:
                    700;

                cursor:
                    pointer;
            }


            .btn-back {

                background:
                    #e8eef3;

                color:
                    #334155;
            }


            .btn-back:hover {

                background:
                    #dce5ec;
            }


            .btn-submit {

                background:
                    #06a3da;

                color:
                    #ffffff;
            }


            .btn-submit:hover {

                background:
                    #0589b8;
            }


            /*
             * =====================================================
             * MOBILE
             * =====================================================
             */

            @media(max-width:600px) {

                .page {

                    width:
                        94%;

                    margin:
                        20px auto;
                }


                .card {

                    padding:
                        22px;
                }


                h1 {

                    font-size:
                        24px;
                }


                .info-grid {

                    grid-template-columns:
                        1fr;
                }


                .buttons {

                    flex-direction:
                        column;
                }


                .btn {

                    width:
                        100%;
                }
            }

        </style>

    </head>


    <body>


        <div class="page">


            <div class="card">


                <!-- =================================================
                     BACK
                     ================================================= -->

                <a class="back-link"
                   href="PatientAppointmentsServlet">

                    <i class="fa-solid fa-arrow-left"></i>

                    Back to My Appointments

                </a>


                <!-- =================================================
                     TITLE
                     ================================================= -->

                <h1>

                    <i class="fa-solid fa-calendar-days"></i>

                    Reschedule Appointment

                </h1>


                <p class="subtitle">

                    Select a new date and time for your
                    appointment. Your rescheduled appointment
                    will require doctor approval again.

                </p>


                <!-- =================================================
                     ERROR
                     ================================================= -->

                <% if ("slot".equals(error)) { %>


                <div class="error">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    The selected date and time is already
                    booked or unavailable. Please select
                    another time.

                </div>


                <% } else if ("empty".equals(error)) { %>


                <div class="error">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    Please select both a date and a time.

                </div>


                <% } else if ("invalid".equals(error)) { %>


                <div class="error">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    The appointment information is invalid.

                </div>


                <% }%>


                <!-- =================================================
                     CURRENT APPOINTMENT
                     ================================================= -->

                <div class="appointment-info">


                    <h3>

                        Current Appointment

                    </h3>


                    <div class="info-grid">


                        <div class="info-item">

                            <label>
                                Appointment Number
                            </label>

                            <strong>
                                <%=appointment.getAppointmentNo()%>
                            </strong>

                        </div>


                        <div class="info-item">

                            <label>
                                Doctor
                            </label>

                            <strong>

                                Dr.
                                <%=appointment.getDoctorName()%>

                            </strong>

                        </div>


                        <div class="info-item">

                            <label>
                                Treatment
                            </label>

                            <strong>
                                <%=appointment.getTreatmentType()%>
                            </strong>

                        </div>


                        <div class="info-item">

                            <label>
                                Current Date
                            </label>

                            <strong>
                                <%=appointment.getAppointmentDate()%>
                            </strong>

                        </div>


                        <div class="info-item">

                            <label>
                                Current Time
                            </label>

                            <strong>
                                <%=appointment.getAppointmentTime()%>
                            </strong>

                        </div>


                        <div class="info-item">

                            <label>
                                Current Status
                            </label>

                            <strong>
                                <%=appointment.getStatus()%>
                            </strong>

                        </div>


                    </div>

                </div>


                <!-- =================================================
                     RESCHEDULE FORM
                     ================================================= -->

                <h2 class="form-title">

                    Select New Appointment Time

                </h2>


                <form method="post"
                      action="RescheduleAppointmentServlet">


                    <input type="hidden"
                           name="appointmentId"
                           value="<%=appointment.getId()%>">


                    <div class="form-group">

                        <label for="appointmentDate">

                            New Appointment Date

                        </label>


                        <input
                            type="date"
                            id="appointmentDate"
                            name="appointmentDate"
                            required>

                    </div>


                    <div class="form-group">

                        <label for="appointmentTime">

                            New Appointment Time

                        </label>


                        <input
                            type="time"
                            id="appointmentTime"
                            name="appointmentTime"
                            required>

                    </div>


                    <!-- =================================================
                         NOTICE
                         ================================================= -->

                    <div class="notice">

                        <i class="fa-solid fa-circle-info"></i>


                        <span>

                            The new time must be available for
                            the selected dentist. After
                            rescheduling, the appointment will
                            return to <strong>Waiting for Doctor</strong>
                            status.

                        </span>

                    </div>


                    <!-- =================================================
                         BUTTONS
                         ================================================= -->

                    <div class="buttons">


                        <a class="btn btn-back"
                           href="PatientAppointmentsServlet">

                            <i class="fa-solid fa-arrow-left"></i>

                            Cancel

                        </a>


                        <button
                            type="submit"
                            class="btn btn-submit">

                            <i class="fa-solid fa-calendar-check"></i>

                            Confirm Reschedule

                        </button>


                    </div>


                </form>


            </div>

        </div>


        <script>

            /*
             * =========================================================
             * PREVENT PAST DATE
             * =========================================================
             */

            const dateInput =
                    document.getElementById(
                            "appointmentDate"
                            );


            const timeInput =
                    document.getElementById(
                            "appointmentTime"
                            );


            const now =
                    new Date();


            const year =
                    now.getFullYear();


            const month =
                    String(
                            now.getMonth() + 1
                            ).padStart(
                    2,
                    "0"
                    );


            const day =
                    String(
                            now.getDate()
                            ).padStart(
                    2,
                    "0"
                    );


            const today =
                    year
                    + "-"
                    + month
                    + "-"
                    + day;


            dateInput.min =
                    today;


            /*
             * =========================================================
             * IF TODAY IS SELECTED, PREVENT PAST TIME
             * =========================================================
             */

            dateInput.addEventListener(
                    "change",
                    function () {


                        if (dateInput.value === today) {


                            const currentHours =
                                    String(
                                            now.getHours()
                                            ).padStart(
                                    2,
                                    "0"
                                    );


                            const currentMinutes =
                                    String(
                                            now.getMinutes()
                                            ).padStart(
                                    2,
                                    "0"
                                    );


                            timeInput.min =
                                    currentHours
                                    + ":"
                                    + currentMinutes;


                        } else {


                            timeInput.removeAttribute(
                                    "min"
                                    );

                        }

                    }
            );

        </script>


    </body>

</html>