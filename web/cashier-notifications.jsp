<%@page import="java.util.List"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>


<%
    /* =========================================
       LOGIN CHECK
       ========================================= */

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                "Login.jsp?error=session"
        );

        return;
    }


    /* =========================================
       ROLE CHECK
       ========================================= */
    String role
            = String.valueOf(
                    session.getAttribute(
                            "userRole"
                    )
            );

    if (!"cashier".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }


    /* =========================================
       NOTIFICATIONS
       ========================================= */
    List<String[]> notifications
            = (List<String[]>) request.getAttribute(
                    "notifications"
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
            Cashier Notifications | Sunrise Dental Clinic
        </title>


        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
              rel="stylesheet">


        <style>

            * {
                box-sizing: border-box;
            }


            body {

                margin: 0;

                background: #f4f8fb;

                color: #526572;

                font-family:
                    "Open Sans",
                    Arial,
                    sans-serif;
            }


            .header {

                background: #102f43;

                color: white;

                padding: 24px 25px;
            }


            .header-inner {

                max-width: 1000px;

                margin: auto;
            }


            .header h1 {

                margin: 0;

                font-family: "Jost", sans-serif;

                font-size: 27px;
            }


            .header p {

                margin: 5px 0 0;

                color:
                    rgba(255,255,255,.65);

                font-size: 12px;
            }


            .container {

                max-width: 1000px;

                margin: auto;

                padding: 30px 25px;
            }


            .back {

                display: inline-flex;

                align-items: center;

                gap: 8px;

                margin-bottom: 20px;

                color: #087fa8;

                text-decoration: none;

                font-size: 13px;

                font-weight: 700;
            }


            .back:hover {

                text-decoration: underline;
            }


            .notification {

                background: white;

                margin-bottom: 15px;

                padding: 20px;

                border-radius: 14px;

                box-shadow:
                    0 5px 18px
                    rgba(16,47,67,.06);

                border-left:
                    5px solid #087fa8;

                border-top:
                    1px solid #e7eef1;

                border-right:
                    1px solid #e7eef1;

                border-bottom:
                    1px solid #e7eef1;
            }


            .notification h3 {

                margin: 0 0 10px;

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 17px;
            }


            .message {

                color: #526572;

                line-height: 1.7;

                font-size: 13px;
            }


            .date {

                margin-top: 12px;

                padding-top: 10px;

                border-top:
                    1px solid #edf2f4;

                color: #8a9aa4;

                font-size: 11px;
            }


            .empty {

                background: white;

                padding: 65px 25px;

                text-align: center;

                border-radius: 14px;

                box-shadow:
                    0 5px 18px
                    rgba(16,47,67,.06);
            }


            .empty i {

                display: block;

                font-size: 42px;

                margin-bottom: 15px;

                color: #b8cbd3;
            }


            .empty h3 {

                margin: 0 0 8px;

                color: #102f43;

                font-family: "Jost", sans-serif;
            }


            .empty p {

                margin: 0;

                color: #82939e;

                font-size: 13px;
            }


            @media(max-width:600px) {

                .container {

                    padding: 20px 15px;
                }

                .header {

                    padding: 20px 15px;
                }

            }

        </style>

    </head>


    <body>


        <!-- =========================================
             HEADER
             ========================================= -->

        <div class="header">

            <div class="header-inner">

                <h1>

                    <i class="fa-solid fa-bell"></i>

                    Cashier Notifications

                </h1>

                <p>
                    Appointment and payment related notifications.
                </p>

            </div>

        </div>


        <!-- =========================================
             CONTENT
             ========================================= -->

        <div class="container">


            <a class="back"
               href="<%=request.getContextPath()%>/cashier-dashboard.jsp">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Dashboard

            </a>


            <%
                if (notifications == null
                        || notifications.isEmpty()) {
            %>


            <div class="empty">

                <i class="fa-regular fa-bell-slash"></i>

                <h3>
                    No Notifications
                </h3>

                <p>
                    You don't have any notifications yet.
                </p>

            </div>


            <%
            } else {
            %>


            <%
                for (String[] n : notifications) {

                    if (n == null
                            || n.length < 6) {

                        continue;
                    }
            %>


            <div class="notification">


                <h3>

                    <i class="fa-solid fa-circle-info"></i>

                    <%= n[1] != null
                            ? n[1]
                            : "Notification"%>

                </h3>


                <div class="message">

                    <%= n[2] != null
                            ? n[2]
                            : ""%>

                </div>


                <div class="date">

                    <i class="fa-regular fa-clock"></i>

                    <%= n[5] != null
                            ? n[5]
                            : "-"%>

                </div>


            </div>


            <%
                }
            %>


            <%
                }
            %>


        </div>


    </body>

</html>