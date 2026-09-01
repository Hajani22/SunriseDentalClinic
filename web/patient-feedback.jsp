<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.PatientFeedback"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

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
                    session.getAttribute("userRole")
            );

    if (!"patient".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }

    String success
            = request.getParameter("success");

    String error
            = request.getParameter("error");

    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute(
                    "appointments"
            );

    List<PatientFeedback> feedbackList
            = (List<PatientFeedback>) request.getAttribute(
                    "feedbackList"
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
            Patient Feedback | Sunrise Dental Clinic
        </title>


        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            * {
                box-sizing: border-box;
            }


            body {

                margin: 0;

                font-family:
                    Arial,
                    Helvetica,
                    sans-serif;

                background:
                    #f5f8fc;

                color:
                    #17365d;
            }


            .page {

                min-height:
                    100vh;

                padding:
                    40px 20px;
            }


            .container {

                max-width:
                    900px;

                margin:
                    0 auto;
            }


            .back-link {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    8px;

                margin-bottom:
                    20px;

                text-decoration:
                    none;

                color:
                    #087ea4;

                font-weight:
                    600;
            }


            .card {

                background:
                    white;

                border-radius:
                    18px;

                padding:
                    35px;

                box-shadow:
                    0 10px 35px
                    rgba(11, 36, 71, 0.08);

                border:
                    1px solid #e6edf5;
            }


            .title {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    14px;

                margin-bottom:
                    8px;
            }


            .title i {

                font-size:
                    30px;

                color:
                    #087ea4;
            }


            .title h1 {

                margin:
                    0;

                color:
                    #0b2447;

                font-size:
                    30px;
            }


            .subtitle {

                margin:
                    0 0 30px;

                color:
                    #64748b;

                font-size:
                    15px;
            }


            .alert {

                padding:
                    14px 16px;

                border-radius:
                    10px;

                margin-bottom:
                    20px;

                font-weight:
                    600;
            }


            .success {

                background:
                    #e8f8ef;

                color:
                    #167447;

                border:
                    1px solid #b8e7ca;
            }


            .error {

                background:
                    #fff0f0;

                color:
                    #b42318;

                border:
                    1px solid #f3c2c2;
            }


            .form-group {

                margin-bottom:
                    25px;
            }


            .form-group label {

                display:
                    block;

                margin-bottom:
                    9px;

                font-weight:
                    700;

                color:
                    #17365d;
            }


            .select-box,
            textarea {

                width:
                    100%;

                border:
                    1px solid #d5dfeb;

                border-radius:
                    10px;

                padding:
                    14px 15px;

                font-size:
                    15px;

                outline:
                    none;

                transition:
                    0.2s;
            }


            .select-box:focus,
            textarea:focus {

                border-color:
                    #087ea4;

                box-shadow:
                    0 0 0 3px
                    rgba(8, 126, 164, 0.10);
            }


            textarea {

                min-height:
                    150px;

                resize:
                    vertical;
            }


            .rating {

                display:
                    flex;

                flex-direction:
                    row-reverse;

                justify-content:
                    flex-end;

                gap:
                    6px;
            }


            .rating input {

                display:
                    none;
            }


            .rating label {

                font-size:
                    38px;

                cursor:
                    pointer;

                color:
                    #d4dde8;

                margin:
                    0;
            }


            .rating label:hover,
            .rating label:hover ~ label,
            .rating input:checked ~ label {

                color:
                    #f5b301;
            }


            .button {

                width:
                    100%;

                border:
                    none;

                border-radius:
                    10px;

                padding:
                    15px;

                background:
                    #087ea4;

                color:
                    white;

                font-size:
                    16px;

                font-weight:
                    700;

                cursor:
                    pointer;
            }


            .button:hover {

                background:
                    #066b8a;
            }


            .info {

                background:
                    #f0f8fc;

                border:
                    1px solid #d4edf5;

                padding:
                    14px 16px;

                border-radius:
                    10px;

                margin-bottom:
                    25px;

                color:
                    #36516f;

                font-size:
                    14px;

                line-height:
                    1.5;
            }


            .feedback-history {

                margin-top:
                    40px;

                padding-top:
                    30px;

                border-top:
                    1px solid #e6edf5;
            }


            .feedback-history h2 {

                margin:
                    0 0 20px;

                color:
                    #0b2447;
            }


            .feedback-item {

                border:
                    1px solid #e3eaf2;

                border-radius:
                    12px;

                padding:
                    18px;

                margin-bottom:
                    14px;

                background:
                    #fbfdff;
            }


            .feedback-top {

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

                gap:
                    15px;

                margin-bottom:
                    8px;
            }


            .appointment-number {

                font-weight:
                    700;

                color:
                    #087ea4;
            }


            .stars {

                color:
                    #f5b301;

                letter-spacing:
                    2px;
            }


            .comment {

                color:
                    #52667f;

                line-height:
                    1.5;
            }


            .empty {

                padding:
                    25px;

                text-align:
                    center;

                color:
                    #8a99aa;

                border:
                    1px dashed #ccd7e4;

                border-radius:
                    10px;
            }


            @media(max-width:600px) {

                .card {

                    padding:
                        22px;
                }


                .title h1 {

                    font-size:
                        24px;
                }


                .feedback-top {

                    flex-direction:
                        column;

                    align-items:
                        flex-start;
                }
            }

        </style>

    </head>


    <body>


        <div class="page">

            <div class="container">


                <a href="patient-dashboard.jsp"
                   class="back-link">

                    <i class="fa-solid fa-arrow-left"></i>

                    Back to Dashboard

                </a>


                <div class="card">


                    <!-- =====================================================
                         TITLE
                         ===================================================== -->

                    <div class="title">

                        <i class="fa-solid fa-star"></i>

                        <h1>
                            Submit Feedback
                        </h1>

                    </div>


                    <p class="subtitle">

                        Share your experience with Sunrise Dental Clinic.

                    </p>


                    <!-- =====================================================
                         SUCCESS
                         ===================================================== -->

                    <% if ("submitted".equalsIgnoreCase(success)) { %>

                    <div class="alert success">

                        <i class="fa-solid fa-circle-check"></i>

                        &nbsp;

                        Your feedback has been submitted successfully.
                        The clinic administrator has been notified.

                    </div>

                    <% } %>


                    <!-- =====================================================
                         ERROR
                         ===================================================== -->

                    <% if (error != null
                        && !error.trim().isEmpty()
                        && !"submitted".equalsIgnoreCase(error)) {%>

                    <div class="alert error">

                        <i class="fa-solid fa-triangle-exclamation"></i>

                        &nbsp;

                        <%= error%>

                    </div>

                    <% }%>


                    <!-- =====================================================
                         INFORMATION
                         ===================================================== -->

                    <div class="info">

                        <i class="fa-solid fa-circle-info"></i>

                        &nbsp;

                        Please select the appointment you want to review.
                        Only your own appointments are available.
                        The appointment number is used for display,
                        while the system securely stores the internal
                        appointment ID in the database.

                    </div>


                    <!-- =====================================================
                         FEEDBACK FORM
                         ===================================================== -->

                    <form method="post"
                          action="<%=request.getContextPath()%>/PatientFeedbackServlet">


                        <!-- =================================================
                             APPOINTMENT NUMBER
                             ================================================= -->

                        <div class="form-group">

                            <label for="appointmentNo">

                                Appointment Number

                            </label>


                            <select id="appointmentNo"
                                    name="appointmentNo"
                                    class="select-box"
                                    required>


                                <option value="">

                                    Select your appointment

                                </option>


                                <%
                                    boolean hasAppointments
                                            = false;

                                    if (appointments != null) {

                                        for (Appointment appointment
                                                : appointments) {


                                            /*
                                             * We display appointment number.
                                             *
                                             * NOT appointment.getId()
                                             */
                                            String appointmentNo
                                                    = appointment.getAppointmentNo();

                                            if (appointmentNo == null
                                                    || appointmentNo.trim().isEmpty()) {

                                                continue;
                                            }


                                            /*
                                             * Do not show cancelled/rejected
                                             * appointments for feedback.
                                             */
                                            String status
                                                    = appointment.getStatus();

                                            if ("CANCELLED".equalsIgnoreCase(status)
                                                    || "REJECTED_BY_DOCTOR".equalsIgnoreCase(status)
                                                    || "REJECTED_BY_ADMIN".equalsIgnoreCase(status)) {

                                                continue;
                                            }

                                            hasAppointments = true;
                                %>


                                <option value="<%=appointmentNo%>">

                                    <%=appointmentNo%>

                                    -

                                    <%=appointment.getAppointmentDate()%>

                                    at

                                    <%=appointment.getAppointmentTime()%>

                                </option>


                                <%
                                        }
                                    }
                                %>


                            </select>


                            <% if (!hasAppointments) { %>

                            <small style="
                                   display:block;
                                   margin-top:8px;
                                   color:#b42318;
                                   ">

                                No eligible appointments are available
                                for feedback.

                            </small>

                            <% }%>

                        </div>


                        <!-- =================================================
                             RATING
                             ================================================= -->

                        <div class="form-group">

                            <label>
                                Your Rating
                            </label>


                            <div class="rating">


                                <input type="radio"
                                       id="star5"
                                       name="rating"
                                       value="5"
                                       required>

                                <label for="star5">
                                    ★
                                </label>


                                <input type="radio"
                                       id="star4"
                                       name="rating"
                                       value="4">

                                <label for="star4">
                                    ★
                                </label>


                                <input type="radio"
                                       id="star3"
                                       name="rating"
                                       value="3">

                                <label for="star3">
                                    ★
                                </label>


                                <input type="radio"
                                       id="star2"
                                       name="rating"
                                       value="2">

                                <label for="star2">
                                    ★
                                </label>


                                <input type="radio"
                                       id="star1"
                                       name="rating"
                                       value="1">

                                <label for="star1">
                                    ★
                                </label>


                            </div>

                        </div>


                        <!-- =================================================
                             COMMENTS
                             ================================================= -->

                        <div class="form-group">

                            <label for="comments">

                                Comments

                            </label>


                            <textarea id="comments"
                                      name="comments"
                                      maxlength="1000"
                                      placeholder="Tell us about your experience..."></textarea>

                        </div>


                        <!-- =================================================
                             SUBMIT
                             ================================================= -->

                        <button type="submit"
                                class="button"
                                <%=!hasAppointments ? "disabled" : ""%>>

                            <i class="fa-solid fa-paper-plane"></i>

                            &nbsp;

                            Submit Feedback

                        </button>


                    </form>


                    <!-- =====================================================
                         FEEDBACK HISTORY
                         ===================================================== -->

                    <div class="feedback-history">

                        <h2>

                            <i class="fa-solid fa-clock-rotate-left"></i>

                            Your Previous Feedback

                        </h2>


                        <% if (feedbackList != null
                            && !feedbackList.isEmpty()) { %>


                        <%
                            for (PatientFeedback feedback
                                    : feedbackList) {
                        %>


                        <div class="feedback-item">


                            <div class="feedback-top">


                                <div class="appointment-number">

                                    <i class="fa-solid fa-calendar-check"></i>

                                    &nbsp;

                                    <%=feedback.getAppointmentNo()%>

                                </div>


                                <div class="stars">

                                    <%
                                        for (int i = 1;
                                                i <= feedback.getRating();
                                                i++) {
                                    %>

                                    ★

                                    <%
                                        }
                                    %>

                                </div>


                            </div>


                            <div class="comment">

                                <%
                                    String comment
                                            = feedback.getComments();

                                    if (comment == null
                                            || comment.trim().isEmpty()) {

                                        comment
                                                = "No written comment provided.";
                                    }
                                %>

                                <%=comment%>

                            </div>


                        </div>


                        <%
                            }
                        %>


                        <% } else { %>


                        <div class="empty">

                            <i class="fa-regular fa-comment-dots"></i>

                            <br><br>

                            You have not submitted any feedback yet.

                        </div>


                        <% }%>


                    </div>


                </div>

            </div>

        </div>


    </body>

</html>