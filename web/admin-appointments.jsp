<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>

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

    if (!"admin".equalsIgnoreCase(role)) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }

    String userName
            = (String) session.getAttribute(
                    "userName"
            );

    if (userName == null) {
        userName = "Admin";
    }

    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute(
                    "appointments"
            );
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Appointment Approval | Sunrise Dental
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
            }

            body {
                margin: 0;
                background: #f4f8fb;
                font-family: "Open Sans", sans-serif;
                color: #555;
            }

            .topbar {
                height: 72px;
                background: white;
                padding: 0 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #ddd;
            }

            .topbar h2 {
                margin: 0;
                color: #091e3e;
                font-family: Jost, sans-serif;
            }

            .container {
                padding: 30px;
            }

            .back {
                display: inline-block;
                margin-bottom: 20px;
                color: #06a3da;
                text-decoration: none;
                font-weight: 600;
            }

            .card {
                background: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 5px 20px rgba(0,0,0,.05);
                overflow-x: auto;
            }

            table {
                width: 100%;
                min-width: 1000px;
                border-collapse: collapse;
            }

            th {
                background: #091e3e;
                color: white;
                padding: 14px;
                text-align: left;
            }

            td {
                padding: 14px;
                border-bottom: 1px solid #eee;
            }

            .status {
                padding: 6px 10px;
                border-radius: 20px;
                background: #fff3cd;
                color: #856404;
                font-size: 12px;
                font-weight: bold;
            }

            .note {
                width: 160px;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 6px;
            }

            button {
                border: 0;
                padding: 9px 12px;
                border-radius: 6px;
                color: white;
                cursor: pointer;
                font-weight: 600;
                margin: 2px;
            }

            .confirm {
                background: #198754;
            }

            .reject {
                background: #dc3545;
            }

            .empty {
                text-align: center;
                padding: 50px;
            }

            @media(max-width:700px) {

                .topbar {
                    padding: 0 15px;
                }

                .container {
                    padding: 15px;
                }

                .topbar h2 {
                    font-size: 20px;
                }

            }

        </style>

    </head>


    <body>


        <header class="topbar">

            <h2>
                <i class="fa-solid fa-calendar-check"></i>
                Appointment Approval
            </h2>

            <strong>
                <%= userName%>
            </strong>

        </header>


        <div class="container">

            <a class="back"
               href="admin-dashboard.jsp">

                <i class="fa-solid fa-arrow-left"></i>
                Back to Dashboard

            </a>


            <div class="card">

                <% if (appointments == null
                    || appointments.isEmpty()) { %>

                <div class="empty">

                    <i class="fa-regular fa-calendar-xmark"
                       style="font-size:50px;">
                    </i>

                    <h3>
                        No Pending Appointments
                    </h3>

                    <p>
                        There are no doctor-approved
                        appointments waiting for confirmation.
                    </p>

                </div>

                <% } else { %>


                <table>

                    <thead>

                        <tr>

                            <th>Appointment No</th>
                            <th>Patient</th>
                            <th>Phone</th>
                            <th>Doctor</th>
                            <th>Treatment</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Action</th>

                        </tr>

                    </thead>


                    <tbody>

                        <% for (Appointment a : appointments) {%>

                        <tr>

                            <td>
                                <strong>
                                    <%= a.getAppointmentNo()%>
                                </strong>
                            </td>

                            <td>
                                <%= a.getPatientName()%>
                            </td>

                            <td>
                                <%= a.getPatientPhone()%>
                            </td>

                            <td>
                                Dr. <%= a.getDoctorName()%>
                            </td>

                            <td>
                                <%= a.getTreatmentType()%>
                            </td>

                            <td>
                                <%= a.getAppointmentDate()%>
                            </td>

                            <td>
                                <%= a.getAppointmentTime()%>
                            </td>

                            <td>

                                <span class="status">
                                    PENDING ADMIN
                                </span>

                            </td>

                            <td>

                                <form
                                    method="post"
                                    action="AdminDecisionServlet">

                                    <input
                                        type="hidden"
                                        name="appointmentId"
                                        value="<%= a.getId()%>">


                                    <input
                                        class="note"
                                        type="text"
                                        name="note"
                                        placeholder="Optional note">


                                    <br>


                                    <button
                                        class="confirm"
                                        type="submit"
                                        name="decision"
                                        value="confirm">

                                        <i class="fa-solid fa-check"></i>
                                        Confirm

                                    </button>


                                    <button
                                        class="reject"
                                        type="submit"
                                        name="decision"
                                        value="reject">

                                        <i class="fa-solid fa-xmark"></i>
                                        Reject

                                    </button>

                                </form>

                            </td>

                        </tr>

                        <% } %>

                    </tbody>

                </table>


                <% }%>

            </div>

        </div>


    </body>

</html>