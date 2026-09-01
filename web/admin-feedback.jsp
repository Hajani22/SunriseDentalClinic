<%@page import="java.util.List"%>
<%@page import="model.PatientFeedback"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=session"
        );

        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute(
                            "userRole"
                    )
            );

    if (!"admin".equalsIgnoreCase(role)) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }

    List<PatientFeedback> feedbackList
            = (List<PatientFeedback>) request.getAttribute(
                    "feedbackList"
            );

    int totalFeedback
            = feedbackList == null
                    ? 0
                    : feedbackList.size();

    double averageRating = 0;

    if (feedbackList != null
            && !feedbackList.isEmpty()) {

        int totalRating = 0;

        for (PatientFeedback feedback
                : feedbackList) {

            totalRating
                    += feedback.getRating();
        }

        averageRating
                = (double) totalRating
                / feedbackList.size();
    }
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Patient Feedback | Sunrise Dental Clinic
        </title>


        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            * {
                box-sizing:border-box;
            }


            body {

                margin:0;

                font-family:
                    Arial,
                    sans-serif;

                background:#f5f8fc;

                color:#475569;
            }


            .topbar {

                background:#0b2447;

                color:white;

                padding:25px 35px;
            }


            .topbar h1 {

                margin:0;

                font-size:24px;
            }


            .topbar p {

                margin:6px 0 0;

                color:#cbd5e1;

                font-size:13px;
            }


            .container {

                max-width:1150px;

                margin:auto;

                padding:30px 20px;
            }


            .back {

                display:inline-block;

                margin-bottom:22px;

                color:#087eac;

                text-decoration:none;

                font-weight:700;
            }


            .summary {

                display:grid;

                grid-template-columns:
                    repeat(3,1fr);

                gap:18px;

                margin-bottom:22px;
            }


            .stat {

                background:white;

                border:
                    1px solid #e5eaf0;

                border-radius:14px;

                padding:20px;

                box-shadow:
                    0 3px 12px
                    rgba(0,0,0,.04);
            }


            .stat i {

                color:#06a3da;

                font-size:22px;
            }


            .stat-number {

                margin-top:10px;

                font-size:25px;

                font-weight:800;

                color:#0b2447;
            }


            .stat-label {

                margin-top:4px;

                font-size:12px;

                color:#64748b;
            }


            .card {

                background:white;

                border:
                    1px solid #e5eaf0;

                border-radius:14px;

                padding:24px;

                box-shadow:
                    0 3px 12px
                    rgba(0,0,0,.04);
            }


            .card-header {

                display:flex;

                justify-content:
                    space-between;

                align-items:center;

                margin-bottom:20px;
            }


            .card-header h2 {

                margin:0;

                color:#0b2447;

                font-size:19px;
            }


            .feedback {

                padding:20px 0;

                border-bottom:
                    1px solid #edf1f5;
            }


            .feedback:last-child {

                border-bottom:none;
            }


            .feedback-top {

                display:flex;

                justify-content:
                    space-between;

                gap:20px;
            }


            .patient {

                font-weight:800;

                color:#0b2447;

                font-size:15px;
            }


            .appointment {

                margin-top:5px;

                color:#64748b;

                font-size:12px;
            }


            .stars {

                color:#f59e0b;

                letter-spacing:2px;

                white-space:nowrap;
            }


            .rating-text {

                font-size:11px;

                color:#94a3b8;

                margin-left:6px;

                letter-spacing:0;
            }


            .comments {

                margin-top:14px;

                padding:14px;

                background:#f8fafc;

                border-radius:10px;

                line-height:1.6;

                color:#475569;
            }


            .date {

                margin-top:9px;

                color:#94a3b8;

                font-size:11px;
            }


            .empty {

                padding:55px 20px;

                text-align:center;

                color:#64748b;
            }


            .empty i {

                font-size:40px;

                color:#cbd5e1;

                margin-bottom:12px;
            }


            @media(max-width:700px) {

                .summary {

                    grid-template-columns:1fr;
                }

                .feedback-top {

                    flex-direction:column;
                }

                .topbar {

                    padding:20px;
                }
            }

        </style>

    </head>


    <body>


        <header class="topbar">

            <h1>

                <i class="fa-solid fa-comment-dots"></i>

                Patient Feedback

            </h1>


            <p>

                Review feedback submitted by
                patients to Sunrise Dental Clinic.

            </p>

        </header>


        <div class="container">


            <a
                href="<%=request.getContextPath()%>/admin-dashboard.jsp"
                class="back">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Dashboard

            </a>


            <!-- =====================================================
                 SUMMARY
                 ===================================================== -->

            <div class="summary">


                <div class="stat">

                    <i class="fa-solid fa-comments"></i>

                    <div class="stat-number">

                        <%=totalFeedback%>

                    </div>

                    <div class="stat-label">

                        Total Feedback

                    </div>

                </div>


                <div class="stat">

                    <i class="fa-solid fa-star"></i>

                    <div class="stat-number">

                        <%=String.format(
                                "%.1f",
                                averageRating
                )%>/5

                    </div>

                    <div class="stat-label">

                        Average Rating

                    </div>

                </div>


                <div class="stat">

                    <i class="fa-solid fa-user-shield"></i>

                    <div class="stat-number">

                        Admin

                    </div>

                    <div class="stat-label">

                        Feedback Recipient

                    </div>

                </div>

            </div>


            <!-- =====================================================
                 FEEDBACK LIST
                 ===================================================== -->

            <div class="card">


                <div class="card-header">

                    <h2>

                        Recent Patient Feedback

                    </h2>

                </div>


                <% if (feedbackList == null
                    || feedbackList.isEmpty()) { %>


                <div class="empty">

                    <i class="fa-regular fa-comment-slash"></i>

                    <h3>

                        No patient feedback yet

                    </h3>

                    <p>

                        Submitted patient feedback
                        will appear here automatically.

                    </p>

                </div>


                <% } else { %>


                <% for (PatientFeedback feedback
                    : feedbackList) {%>


                <div class="feedback">


                    <div class="feedback-top">


                        <div>

                            <div class="patient">

                                <i class="fa-solid fa-user"></i>

                                <%=feedback.getPatientName()
                                == null
                                        ? "Patient"
                                        : feedback.getPatientName()%>

                            </div>


                            <div class="appointment">

                                <i class="fa-solid fa-calendar-check"></i>

                                Appointment:

                                <%=feedback.getAppointmentNo()
                                == null
                                        ? feedback.getAppointmentId()
                                        : feedback.getAppointmentNo()%>

                            </div>

                        </div>


                        <div class="stars">

                            <%
                                for (int i = 1;
                                        i <= 5;
                                        i++) {
                            %>

                            <% if (i <= feedback.getRating()) { %>

                            ★

                            <% } else { %>

                            ☆

                            <% } %>

                            <%
                                }
                            %>


                            <span class="rating-text">

                                <%=feedback.getRating()%>/5

                            </span>

                        </div>

                    </div>


                    <div class="comments">

                        <i class="fa-solid fa-quote-left"></i>

                        <%=feedback.getComments()
                                == null
                                || feedback.getComments()
                                        .trim()
                                        .isEmpty()
                                        ? "No written comment provided."
                                : feedback.getComments()%>

                    </div>


                    <div class="date">

                        Submitted:

                        <%=feedback.getCreatedAt()%>

                    </div>


                </div>


                <% } %>


                <% }%>


            </div>

        </div>


    </body>

</html>