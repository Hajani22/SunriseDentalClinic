<%@page import="java.util.List"%>
<%@page import="model.Payment"%>

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
       PAYMENT RECORDS
       ========================================= */
    List<Payment> paymentRecords
            = (List<Payment>) request.getAttribute(
                    "paymentRecords"
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
            Payment Records | Sunrise Dental Clinic
        </title>


        <!-- FONT AWESOME -->

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <!-- GOOGLE FONT -->

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


            .page {

                max-width: 1250px;

                margin: auto;

                padding: 35px 25px;
            }


            .header {

                display: flex;

                justify-content: space-between;

                align-items: center;

                margin-bottom: 25px;

                gap: 20px;

                flex-wrap: wrap;
            }


            .header h1 {

                margin: 0;

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 30px;
            }


            .header p {

                margin: 6px 0 0;

                color: #82939e;

                font-size: 13px;
            }


            .back-btn {

                display: inline-flex;

                align-items: center;

                gap: 8px;

                padding: 11px 17px;

                border-radius: 9px;

                background: #087fa8;

                color: white;

                text-decoration: none;

                font-size: 13px;

                font-weight: 700;
            }


            .back-btn:hover {

                background: #056582;
            }


            .card {

                background: white;

                border: 1px solid #e1ebef;

                border-radius: 16px;

                box-shadow:
                    0 7px 22px
                    rgba(16,47,67,.06);

                overflow: hidden;
            }


            .card-header {

                padding: 20px 22px;

                border-bottom:
                    1px solid #e5eef2;

                display: flex;

                justify-content: space-between;

                align-items: center;

                gap: 15px;

                flex-wrap: wrap;
            }


            .card-header h2 {

                margin: 0;

                font-family: "Jost", sans-serif;

                color: #102f43;

                font-size: 19px;
            }


            .count {

                background: #eef7fa;

                color: #087fa8;

                padding: 6px 11px;

                border-radius: 20px;

                font-size: 11px;

                font-weight: 700;
            }


            .table-wrapper {

                width: 100%;

                overflow-x: auto;
            }


            table {

                width: 100%;

                border-collapse: collapse;

                min-width: 850px;
            }


            th {

                background: #f7fbfc;

                color: #6f828d;

                font-size: 11px;

                text-transform: uppercase;

                letter-spacing: .5px;

                text-align: left;

                padding: 14px 15px;

                border-bottom:
                    1px solid #e4edf1;
            }


            td {

                padding: 15px;

                font-size: 12px;

                color: #526572;

                border-bottom:
                    1px solid #edf2f4;

                vertical-align: middle;
            }


            tr:hover td {

                background: #fbfdfe;
            }


            .payment-no {

                font-weight: 700;

                color: #087fa8;
            }


            .patient {

                font-weight: 700;

                color: #102f43;
            }


            .amount {

                font-weight: 700;

                color: #102f43;
            }


            .status {

                display: inline-block;

                padding: 6px 10px;

                border-radius: 20px;

                font-size: 10px;

                font-weight: 700;
            }


            .paid {

                background: #e8f7ef;

                color: #16834b;
            }


            .pending {

                background: #fff5dc;

                color: #a36d00;
            }


            .failed {

                background: #fdebec;

                color: #c0392b;
            }


            .unknown {

                background: #edf1f3;

                color: #6c7a80;
            }


            .empty {

                text-align: center;

                padding: 65px 20px;

                color: #82939e;
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

                font-size: 13px;
            }


            @media(max-width:700px) {

                .page {

                    padding: 25px 15px;
                }

                .header h1 {

                    font-size: 25px;
                }

            }

        </style>

    </head>


    <body>


        <div class="page">


            <!-- =========================================
                 HEADER
                 ========================================= -->

            <div class="header">

                <div>

                    <h1>
                        Payment Records
                    </h1>

                    <p>
                        View all patient payment transactions.
                    </p>

                </div>


                <a class="back-btn"
                   href="<%=request.getContextPath()%>/cashier-dashboard.jsp">

                    <i class="fa-solid fa-arrow-left"></i>

                    Back to Dashboard

                </a>

            </div>


            <!-- =========================================
                 PAYMENT CARD
                 ========================================= -->

            <div class="card">


                <div class="card-header">

                    <h2>
                        All Payment Transactions
                    </h2>


                    <span class="count">

                        <%= paymentRecords != null
                                ? paymentRecords.size()
                                : 0%>

                        Records

                    </span>

                </div>


                <%
                    if (paymentRecords == null
                            || paymentRecords.isEmpty()) {
                %>


                <div class="empty">

                    <i class="fa-solid fa-credit-card"></i>

                    <h3>
                        No Payment Records
                    </h3>

                    <p>
                        No patient payment transactions
                        are available yet.
                    </p>

                </div>


                <%
                } else {
                %>


                <div class="table-wrapper">


                    <table>


                        <thead>

                            <tr>

                                <th>
                                    Payment No
                                </th>

                                <th>
                                    Patient
                                </th>

                                <th>
                                    Appointment
                                </th>

                                <th>
                                    Payment Type
                                </th>

                                <th>
                                    Amount
                                </th>

                                <th>
                                    Method
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Date
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                            <%
                                for (Payment payment : paymentRecords) {

                                    if (payment == null) {
                                        continue;
                                    }

                                    String status
                                            = payment.getPaymentStatus();

                                    String statusClass
                                            = "unknown";

                                    if ("PAID".equalsIgnoreCase(status)
                                            || "COMPLETED".equalsIgnoreCase(status)) {

                                        statusClass = "paid";

                                    } else if ("PENDING".equalsIgnoreCase(status)) {

                                        statusClass = "pending";

                                    } else if ("FAILED".equalsIgnoreCase(status)) {

                                        statusClass = "failed";
                                    }

                                    String paymentType
                                            = payment.getPaymentType();

                                    String method
                                            = payment.getPaymentMethod();

                            %>


                            <tr>


                                <!-- PAYMENT NO -->

                                <td>

                                    <span class="payment-no">

                                        <%= payment.getPaymentNo() != null
                                                ? payment.getPaymentNo()
                                                : "-"%>

                                    </span>

                                </td>


                                <!-- PATIENT -->

                                <td>

                                    <span class="patient">

                                        <%= payment.getPatientName() != null
                                                ? payment.getPatientName()
                                                : "-"%>

                                    </span>

                                </td>


                                <!-- APPOINTMENT -->

                                <td>

                                    <%= payment.getAppointmentNo() != null
                                            ? payment.getAppointmentNo()
                                            : "-"%>

                                </td>


                                <!-- PAYMENT TYPE -->

                                <td>

                                    <%= paymentType != null
                                            ? paymentType
                                            : "-"%>

                                </td>


                                <!-- AMOUNT -->

                                <td>

                                    <span class="amount">

                                        Rs.

                                        <%= payment.getAmount() != null
                                                ? payment.getAmount()
                                                : "0.00"%>

                                    </span>

                                </td>


                                <!-- METHOD -->

                                <td>

                                    <%= method != null
                                            ? method.replace("_", " ")
                                            : "-"%>

                                </td>


                                <!-- STATUS -->

                                <td>

                                    <span class="status <%=statusClass%>">

                                        <%= status != null
                                                ? status
                                                : "UNKNOWN"%>

                                    </span>

                                </td>


                                <!-- DATE -->

                                <td>

                                    <%= payment.getCreatedAt() != null
                                            ? payment.getCreatedAt()
                                            : "-"%>

                                </td>


                            </tr>


                            <%
                                }
                            %>


                        </tbody>


                    </table>

                </div>


                <%
                    }
                %>


            </div>


        </div>


    </body>

</html>