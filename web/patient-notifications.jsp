<%@page import="java.util.List"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
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

    if (!"patient".equalsIgnoreCase(role)) {
        response.sendRedirect(
                "Login.jsp?error=access"
        );
        return;
    }

    List<String[]> notifications
            = (List<String[]>) request.getAttribute(
                    "notifications"
            );
%>

<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>My Notifications</title>

        <style>

            body {
                margin: 0;
                background: #f4f8fb;
                font-family: Arial, sans-serif;
            }

            .header {
                background: #091e3e;
                color: white;
                padding: 20px;
            }

            .container {
                max-width: 900px;
                margin: auto;
                padding: 25px;
            }

            .back {
                color: #06a3da;
                text-decoration: none;
                font-weight: bold;
            }

            .notification {
                background: white;
                margin-top: 15px;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,.06);
            }

            .notification h3 {
                margin: 0 0 10px;
                color: #091e3e;
            }

            .message {
                line-height: 1.6;
            }

            .date {
                margin-top: 12px;
                font-size: 12px;
                color: #888;
            }

            .empty {
                background: white;
                padding: 50px;
                text-align: center;
                border-radius: 12px;
                margin-top: 20px;
            }

            @media(max-width:600px) {

                .container {
                    padding: 15px;
                }

                .notification {
                    padding: 15px;
                }

            }

        </style>

    </head>


    <body>

        <div class="header">

            <h2>
                My Notifications
            </h2>

        </div>


        <div class="container">

            <a class="back"
               href="patient-dashboard.jsp">

                ← Back to Dashboard

            </a>


            <% if (notifications == null
                || notifications.isEmpty()) { %>


            <div class="empty">

                <h3>
                    No Notifications
                </h3>

                <p>
                    Your appointment updates will appear here.
                </p>

            </div>


            <% } else { %>


            <% for (String[] n : notifications) {%>

            <div class="notification">

                <h3>
                    <%= n[1]%>
                </h3>

                <div class="message">
                    <%= n[2]%>
                </div>

                <div class="date">
                    <%= n[4]%>
                </div>

            </div>

            <% } %>


            <% }%>

        </div>


    </body>

</html>