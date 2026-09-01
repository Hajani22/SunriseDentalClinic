<%@page import="java.util.List"%>
<%@page import="model.Payment"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>


<%
    /* =====================================================
       LOGIN CHECK
       ===================================================== */

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=session"
        );

        return;
    }


    /* =====================================================
       PATIENT ROLE CHECK
       ===================================================== */
    String role
            = String.valueOf(
                    session.getAttribute(
                            "userRole"
                    )
            );

    if (!"patient".equalsIgnoreCase(role)) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }


    /* =====================================================
       PAYMENT DATA
       ===================================================== */
    List<Payment> payments
            = (List<Payment>) request.getAttribute(
                    "payments"
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
            My Bills | Sunrise Dental Clinic
        </title>


        <!-- Font Awesome -->

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <!-- Google Fonts -->

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

                max-width: 1200px;

                margin: auto;

                padding: 40px 25px;

            }


            /* =================================================
               HEADER
               ================================================= */

            .page-header {

                display: flex;

                justify-content: space-between;

                align-items: center;

                margin-bottom: 30px;

                gap: 20px;

            }


            .page-title h1 {

                margin: 0;

                color: #102f43;

                font-family: "Jost",
                    sans-serif;

                font-size: 34px;

            }


            .page-title p {

                margin-top: 8px;

                color: #82939e;

            }


            /* =================================================
               PAYMENT BUTTON
               ================================================= */

            .payment-button {

                display: inline-flex;

                align-items: center;

                gap: 8px;

                padding: 12px 18px;

                border-radius: 10px;

                background: #087fa8;

                color: white;

                text-decoration: none;

                font-size: 13px;

                font-weight: 700;

                transition: .2s;

            }


            .payment-button:hover {

                background: #056582;

            }


            /* =================================================
               CARD
               ================================================= */

            .card {

                background: white;

                border: 1px solid #e1ebef;

                border-radius: 16px;

                box-shadow:
                    0 8px 25px
                    rgba(16,47,67,.06);

                overflow: hidden;

            }


            /* =================================================
               TABLE
               ================================================= */

            .table-wrapper {

                width: 100%;

                overflow-x: auto;

            }


            table {

                width: 100%;

                border-collapse: collapse;

            }


            thead {

                background: #f7fafc;

            }


            th {

                padding: 16px;

                text-align: left;

                color: #687b87;

                font-size: 11px;

                font-weight: 700;

                text-transform: uppercase;

                letter-spacing: .5px;

                border-bottom:
                    1px solid #e5edf1;

            }


            td {

                padding: 16px;

                color: #526572;

                font-size: 13px;

                border-bottom:
                    1px solid #edf2f5;

            }


            tr:last-child td {

                border-bottom: none;

            }


            /* =================================================
               PAYMENT NUMBER
               ================================================= */

            .payment-no {

                font-weight: 700;

                color: #102f43;

            }


            .appointment-no {

                font-weight: 600;

                color: #087fa8;

            }


            /* =================================================
               AMOUNT
               ================================================= */

            .amount {

                font-weight: 700;

                color: #102f43;

            }


            /* =================================================
               PAYMENT METHOD
               ================================================= */

            .method {

                display: inline-flex;

                align-items: center;

                gap: 7px;

                color: #087fa8;

                font-weight: 600;

            }


            /* =================================================
               STATUS
               ================================================= */

            .status {

                display: inline-block;

                padding: 6px 12px;

                border-radius: 20px;

                font-size: 10px;

                font-weight: 700;

                text-transform: uppercase;

            }


            .paid {

                background: #e5f7ed;

                color: #16834b;

            }


            .pending {

                background: #fff4d6;

                color: #9a6a00;

            }


            .failed {

                background: #ffe7e7;

                color: #c62828;

            }


            /* =================================================
               EMPTY
               ================================================= */

            .empty {

                padding: 70px 20px;

                text-align: center;

            }


            .empty-icon {

                width: 70px;

                height: 70px;

                margin: 0 auto 20px;

                border-radius: 50%;

                display: flex;

                align-items: center;

                justify-content: center;

                background: #eef7fa;

                color: #087fa8;

                font-size: 28px;

            }


            .empty h2 {

                margin: 0;

                color: #102f43;

                font-family: "Jost",
                    sans-serif;

            }


            .empty p {

                color: #82939e;

                margin-top: 8px;

            }


            /* =================================================
               RESPONSIVE
               ================================================= */

            @media(max-width: 700px) {

                .page {

                    padding: 25px 15px;

                }


                .page-header {

                    flex-direction: column;

                    align-items: flex-start;

                }


                .page-title h1 {

                    font-size: 28px;

                }

            }

        </style>

    </head>


    <body>


        <div class="page">


            <!-- =================================================
                 HEADER
                 ================================================= -->

            <div class="page-header">


                <div class="page-title">

                    <h1>
                        My Bills
                    </h1>

                    <p>
                        View your payment history and billing records.
                    </p>

                </div>


                <a href="<%=request.getContextPath()%>/PatientPaymentPageServlet"
                   class="payment-button">

                    <i class="fa-solid fa-credit-card"></i>

                    Make Payment

                </a>


            </div>


            <!-- =================================================
                 PAYMENT TABLE
                 ================================================= -->

            <div class="card">


                <%
                    if (payments != null
                            && !payments.isEmpty()) {
                %>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Payment No
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
                                for (Payment payment
                                        : payments) {

                                    String status
                                            = payment.getPaymentStatus();

                                    String statusClass
                                            = "pending";

                                    if ("PAID".equalsIgnoreCase(
                                            status)
                                            || "COMPLETED".equalsIgnoreCase(
                                                    status)) {

                                        statusClass
                                                = "paid";

                                    } else if ("FAILED".equalsIgnoreCase(
                                            status)) {

                                        statusClass
                                                = "failed";

                                    }

                            %>


                            <tr>


                                <!-- Payment Number -->

                                <td>

                                    <span class="payment-no">

                                        <%= payment.getPaymentNo()%>

                                    </span>

                                </td>


                                <!-- Appointment -->

                                <td>

                                    <span class="appointment-no">

                                        <%= payment.getAppointmentNo() == null
                                                ? "N/A"
                                                : payment.getAppointmentNo()%>

                                    </span>

                                </td>


                                <!-- Payment Type -->

                                <td>

                                    <%= payment.getPaymentType() == null
                                            ? "N/A"
                                            : payment.getPaymentType()%>

                                </td>


                                <!-- Amount -->

                                <td>

                                    <span class="amount">

                                        Rs.
                                        <%= payment.getAmount() == null
                                                ? "0.00"
                                                : payment.getAmount()%>

                                    </span>

                                </td>


                                <!-- Payment Method -->

                                <td>

                                    <span class="method">

                                        <i class="fa-solid fa-credit-card"></i>

                                        <%= payment.getPaymentMethod() == null
                                                ? "N/A"
                                                : payment.getPaymentMethod()%>

                                    </span>

                                </td>


                                <!-- Status -->

                                <td>

                                    <span class="status <%=statusClass%>">

                                        <%= status == null
                                                ? "PENDING"
                                                : status%>

                                    </span>

                                </td>


                                <!-- Date -->

                                <td>

                                    <%= payment.getCreatedAt() == null
                                            ? "N/A"
                                            : payment.getCreatedAt()%>

                                </td>


                            </tr>


                            <%
                                }
                            %>


                        </tbody>

                    </table>

                </div>


                <%
                } else {
                %>


                <!-- =================================================
                     NO PAYMENT RECORDS
                     ================================================= -->

                <div class="empty">

                    <div class="empty-icon">

                        <i class="fa-solid fa-file-invoice-dollar"></i>

                    </div>


                    <h2>
                        No Payment Records
                    </h2>


                    <p>
                        You do not have any payment records yet.
                    </p>


                    <br>


                    <a href="<%=request.getContextPath()%>/PatientPaymentPageServlet"
                       class="payment-button">

                        <i class="fa-solid fa-credit-card"></i>

                        Make Payment

                    </a>

                </div>


                <%
                    }
                %>


            </div>


        </div>


        <!-- =====================================================
             COMMON TOAST
             ===================================================== -->

        <jsp:include page="toast.jsp" />


    </body>

</html>