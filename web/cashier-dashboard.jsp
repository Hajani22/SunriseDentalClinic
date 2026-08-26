<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="model.Payment" %>
<%@ page import="service.PaymentService" %>
<%@ page import="service.impl.PaymentServiceImpl" %>

<%
    /* =========================================================
       CASHIER ACCESS CHECK
       ========================================================= */

    if (session.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"cashier".equalsIgnoreCase(role)) {
        response.sendRedirect("Login.jsp?error=access");
        return;
    }

    String userName
            = (String) session.getAttribute("userName");

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Cashier";
    }


    /* =========================================================
       LOAD PAYMENTS
       ========================================================= */
    List<Payment> payments = null;

    try {

        PaymentService paymentService
                = new PaymentServiceImpl();

        payments
                = paymentService.getAllPayments();

    } catch (Exception e) {

        e.printStackTrace();

    }


    /* =========================================================
       PAYMENT STATISTICS
       ========================================================= */
    int totalPayments = 0;

    java.math.BigDecimal totalAmount
            = java.math.BigDecimal.ZERO;

    java.math.BigDecimal consultationAmount
            = java.math.BigDecimal.ZERO;

    java.math.BigDecimal treatmentAmount
            = java.math.BigDecimal.ZERO;

    if (payments != null) {

        totalPayments = payments.size();

        for (Payment p : payments) {

            if (p.getAmount() != null) {

                totalAmount
                        = totalAmount.add(
                                p.getAmount()
                        );
            }

            if ("CONSULTATION".equalsIgnoreCase(
                    p.getPaymentType())) {

                if (p.getAmount() != null) {

                    consultationAmount
                            = consultationAmount.add(
                                    p.getAmount()
                            );
                }

            } else if ("TREATMENT".equalsIgnoreCase(
                    p.getPaymentType())) {

                if (p.getAmount() != null) {

                    treatmentAmount
                            = treatmentAmount.add(
                                    p.getAmount()
                            );
                }
            }
        }
    }
%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Cashier Dashboard | Sunrise Dental Clinic
        </title>


        <!-- GOOGLE FONT -->

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <!-- FONT AWESOME -->

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

                background: #f4f8fb;

                color: #555;
            }


            .layout {

                min-height: 100vh;

                display: flex;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                width: 250px;

                position: fixed;

                inset: 0 auto 0 0;

                background: #091e3e;

                color: white;

                padding: 25px 18px;

                z-index: 1000;
            }


            .brand {

                font:
                    700 21px Jost,
                    sans-serif;

                margin:
                    10px 8px 35px;

                display: flex;

                gap: 10px;

                align-items: center;
            }


            .brand i {

                background: #06a3da;

                padding: 12px;

                border-radius: 10px;
            }


            .menu a {

                display: flex;

                gap: 12px;

                padding: 13px 14px;

                color: #c7d2e0;

                text-decoration: none;

                border-radius: 8px;

                margin-bottom: 6px;

                transition: 0.2s;
            }


            .menu a:hover,
            .menu a.active {

                background: #06a3da;

                color: white;
            }


            .menu i {

                width: 18px;
            }


            .logout {

                position: absolute;

                bottom: 25px;

                left: 18px;

                right: 18px;
            }


            .logout a {

                color: #ffb4b4;

                text-decoration: none;

                display: block;

                padding: 12px;

                border-radius: 8px;
            }


            .logout a:hover {

                background: #172b4d;
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left: 250px;

                width:
                    calc(100% - 250px);

                min-height: 100vh;
            }


            .topbar {

                height: 72px;

                background: white;

                border-bottom:
                    1px solid #e5ebf0;

                padding: 0 32px;

                display: flex;

                align-items: center;

                justify-content: space-between;
            }


            .topbar h2 {

                font:
                    700 25px Jost,
                    sans-serif;

                color: #091e3e;
            }


            .user {

                display: flex;

                align-items: center;

                gap: 10px;
            }


            .user strong {

                color: #091e3e;

                font-size: 14px;
            }


            .user small {

                display: block;

                color: #7b8794;

                margin-top: 2px;
            }


            .avatar {

                width: 42px;

                height: 42px;

                border-radius: 50%;

                background: #e7f7fc;

                color: #06a3da;

                display: grid;

                place-items: center;
            }


            .content {

                padding: 32px;
            }


            /* =====================================================
               WELCOME
               ===================================================== */

            .welcome {

                background:
                    linear-gradient(
                    120deg,
                    #06a3da,
                    #0589b8
                    );

                color: white;

                border-radius: 14px;

                padding: 30px;

                margin-bottom: 25px;

                position: relative;

                overflow: hidden;
            }


            .welcome h1 {

                font:
                    700 29px Jost,
                    sans-serif;

                margin-bottom: 7px;
            }


            .welcome p {

                font-size: 14px;

                opacity: .95;
            }


            /* =====================================================
               STAT CARDS
               ===================================================== */

            .cards {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 18px;

                margin-bottom: 25px;
            }


            .card {

                background: white;

                border:
                    1px solid #e5ebf0;

                border-radius: 14px;

                padding: 23px;

                box-shadow:
                    0 5px 18px
                    rgba(9,30,62,.04);
            }


            .card-icon {

                width: 50px;

                height: 50px;

                border-radius: 12px;

                background: #e7f7fc;

                color: #06a3da;

                display: grid;

                place-items: center;

                margin-bottom: 15px;
            }


            .card h3 {

                font:
                    700 21px Jost,
                    sans-serif;

                color: #091e3e;

                margin-bottom: 5px;
            }


            .card p {

                font-size: 13px;

                color: #7b8794;

                line-height: 1.5;
            }


            /* =====================================================
               PANEL
               ===================================================== */

            .panel {

                background: white;

                border:
                    1px solid #e5ebf0;

                border-radius: 14px;

                padding: 25px;

                margin-bottom: 25px;

                box-shadow:
                    0 5px 18px
                    rgba(9,30,62,.04);
            }


            .panel-header {

                display: flex;

                justify-content: space-between;

                align-items: center;

                margin-bottom: 20px;
            }


            .panel-title {

                font:
                    700 20px Jost,
                    sans-serif;

                color: #091e3e;
            }


            .panel-subtitle {

                color: #7b8794;

                font-size: 13px;

                margin-top: 3px;
            }


            /* =====================================================
               PAYMENT TABLE
               ===================================================== */

            .table-wrapper {

                width: 100%;

                overflow-x: auto;
            }


            table {

                width: 100%;

                border-collapse: collapse;

                min-width: 900px;
            }


            th {

                background: #f7fafc;

                color: #64748b;

                font-size: 11px;

                text-align: left;

                padding: 13px;

                border-bottom:
                    1px solid #e5ebf0;
            }


            td {

                padding: 14px 13px;

                border-bottom:
                    1px solid #edf1f5;

                font-size: 12px;

                color: #475569;
            }


            tbody tr:hover {

                background: #f9fcfe;
            }


            .patient-name {

                font-weight: 700;

                color: #091e3e;
            }


            .payment-no {

                font-weight: 600;

                color: #06a3da;
            }


            .amount {

                font-weight: 700;

                color: #091e3e;
            }


            .status {

                display: inline-block;

                padding: 5px 10px;

                border-radius: 20px;

                font-size: 10px;

                font-weight: 700;
            }


            .status-paid {

                background: #dcfce7;

                color: #15803d;
            }


            .payment-type {

                display: inline-block;

                padding: 5px 9px;

                border-radius: 6px;

                background: #eef8fc;

                color: #067da8;

                font-size: 10px;

                font-weight: 600;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                text-align: center;

                padding: 45px 20px;

                color: #94a3b8;
            }


            .empty i {

                font-size: 38px;

                margin-bottom: 12px;

                color: #cbd5e1;
            }


            /* =====================================================
               ACTION GRID
               ===================================================== */

            .action-grid {

                display: grid;

                grid-template-columns:
                    repeat(3, 1fr);

                gap: 15px;
            }


            .action {

                text-decoration: none;

                padding: 18px;

                border-radius: 11px;

                border:
                    1px solid #e5ebf0;

                background: #f9fcfe;

                color: #091e3e;

                display: flex;

                align-items: center;

                gap: 13px;

                transition: .2s;
            }


            .action:hover {

                background: #06a3da;

                color: white;

                border-color: #06a3da;

                transform:
                    translateY(-2px);
            }


            .action-icon {

                width: 42px;

                height: 42px;

                border-radius: 9px;

                background: #e7f7fc;

                color: #06a3da;

                display: grid;

                place-items: center;

                flex-shrink: 0;
            }


            .action-content strong {

                display: block;

                font-size: 14px;

                margin-bottom: 3px;
            }


            .action-content span {

                display: block;

                font-size: 11px;

                color: #7b8794;
            }


            .action:hover
            .action-content span {

                color: white;

                opacity: .9;
            }


            /* =====================================================
               WORKFLOW
               ===================================================== */

            .workflow {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 12px;
            }


            .workflow-step {

                background: #f8fbfd;

                border-radius: 10px;

                padding: 18px;

                text-align: center;
            }


            .workflow-number {

                width: 34px;

                height: 34px;

                background: #06a3da;

                color: white;

                border-radius: 50%;

                display: grid;

                place-items: center;

                margin:
                    0 auto 10px;

                font-weight: 700;
            }


            .workflow-step strong {

                display: block;

                color: #091e3e;

                font-size: 13px;

                margin-bottom: 5px;
            }


            .workflow-step span {

                font-size: 11px;

                color: #7b8794;

                line-height: 1.4;
            }


            /* =====================================================
               FOOTER
               ===================================================== */

            .footer {

                text-align: center;

                padding: 15px;

                color: #94a3b8;

                font-size: 12px;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width:1050px) {

                .cards {

                    grid-template-columns:
                        repeat(2,1fr);
                }

                .action-grid {

                    grid-template-columns:
                        repeat(2,1fr);
                }

                .workflow {

                    grid-template-columns:
                        repeat(2,1fr);
                }
            }


            @media(max-width:800px) {

                .sidebar {

                    width: 70px;

                    padding:
                        20px 10px;
                }


                .brand span,
                .menu span,
                .logout span {

                    display: none;
                }


                .brand {

                    justify-content: center;

                    margin-bottom: 35px;
                }


                .menu a {

                    justify-content: center;
                }


                .main {

                    margin-left: 70px;

                    width:
                        calc(100% - 70px);
                }


                .topbar {

                    padding: 0 20px;
                }


                .content {

                    padding: 20px;
                }


                .cards {

                    grid-template-columns: 1fr;
                }


                .action-grid {

                    grid-template-columns: 1fr;
                }


                .workflow {

                    grid-template-columns: 1fr;
                }
            }


            @media(max-width:500px) {

                .topbar {

                    height: auto;

                    padding: 15px;
                }


                .topbar h2 {

                    font-size: 18px;
                }


                .user strong,
                .user small {

                    display: none;
                }


                .content {

                    padding: 15px;
                }


                .panel {

                    padding: 18px;
                }
            }

        </style>

    </head>


    <body>

        <div class="layout">


            <!-- =====================================================
                 SIDEBAR
                 ===================================================== -->

            <aside class="sidebar">


                <div class="brand">

                    <i class="fa-solid fa-tooth"></i>

                    <span>
                        Sunrise Dental
                    </span>

                </div>


                <nav class="menu">


                    <a class="active"
                       href="cashier-dashboard.jsp">

                        <i class="fa-solid fa-gauge"></i>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <a href="CashierBillingServlet">

                        <i class="fa-solid fa-file-invoice-dollar"></i>

                        <span>
                            Billing
                        </span>

                    </a>


                    <a href="CashierBillingServlet">

                        <i class="fa-solid fa-receipt"></i>

                        <span>
                            Payments
                        </span>

                    </a>


                    <a href="cashier-profile.jsp">

                        <i class="fa-solid fa-user"></i>

                        <span>
                            Profile
                        </span>

                    </a>


                </nav>


                <div class="logout">

                    <a href="LogoutServlet">

                        <i class="fa-solid fa-right-from-bracket"></i>

                        <span>
                            Logout
                        </span>

                    </a>

                </div>

            </aside>



            <!-- =====================================================
                 MAIN
                 ===================================================== -->

            <main class="main">


                <!-- TOP BAR -->

                <header class="topbar">

                    <h2>
                        Cashier Dashboard
                    </h2>


                    <div class="user">

                        <div>

                            <strong>
                                <%= userName%>
                            </strong>

                            <small>
                                Cashier
                            </small>

                        </div>


                        <div class="avatar">

                            <i class="fa-solid fa-cash-register"></i>

                        </div>

                    </div>

                </header>



                <!-- CONTENT -->

                <section class="content">


                    <!-- =================================================
                         WELCOME
                         ================================================= -->

                    <div class="welcome">

                        <h1>
                            Welcome, <%= userName%>!
                        </h1>

                        <p>
                            Manage patient payments,
                            billing and payment records
                            from one place.
                        </p>

                    </div>



                    <!-- =================================================
                         STATISTICS
                         ================================================= -->

                    <div class="cards">


                        <div class="card">

                            <div class="card-icon">

                                <i class="fa-solid fa-receipt"></i>

                            </div>

                            <h3>
                                <%= totalPayments%>
                            </h3>

                            <p>
                                Total Payments
                            </p>

                        </div>


                        <div class="card">

                            <div class="card-icon">

                                <i class="fa-solid fa-money-bill-wave"></i>

                            </div>

                            <h3>
                                Rs.
                                <%= totalAmount%>
                            </h3>

                            <p>
                                Total Amount Received
                            </p>

                        </div>


                        <div class="card">

                            <div class="card-icon">

                                <i class="fa-solid fa-user-doctor"></i>

                            </div>

                            <h3>
                                Rs.
                                <%= consultationAmount%>
                            </h3>

                            <p>
                                Consultation Payments
                            </p>

                        </div>


                        <div class="card">

                            <div class="card-icon">

                                <i class="fa-solid fa-tooth"></i>

                            </div>

                            <h3>
                                Rs.
                                <%= treatmentAmount%>
                            </h3>

                            <p>
                                Treatment Payments
                            </p>

                        </div>

                    </div>



                    <!-- =================================================
                         PATIENT PAYMENT NOTIFICATION / ALERT
                         ================================================= -->

                    <div class="panel">

                        <div class="panel-header">

                            <div>

                                <div class="panel-title">

                                    <i class="fa-solid fa-bell"
                                       style="color:#06a3da;">
                                    </i>

                                    Recent Patient Payments

                                </div>

                                <div class="panel-subtitle">

                                    Payments submitted by patients

                                </div>

                            </div>

                        </div>


                        <% if (payments != null
                            && !payments.isEmpty()) { %>


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
                                        int count = 0;

                                        for (Payment p
                                                : payments) {

                                            if (count >= 10) {
                                                break;
                                            }

                                            count++;
                                    %>


                                    <tr>


                                        <td>

                                            <span class="payment-no">

                                                <%= p.getPaymentNo()%>

                                            </span>

                                        </td>


                                        <td>

                                            <span class="patient-name">

                                                <%= p.getPatientName() == null
                                                        ? "Patient"
                                                        : p.getPatientName()%>

                                            </span>

                                        </td>


                                        <td>

                                            <%= p.getAppointmentNo() == null
                                                    ? "-"
                                                    : p.getAppointmentNo()%>

                                        </td>


                                        <td>

                                            <span class="payment-type">

                                                <%= p.getPaymentType() == null
                                                        ? "-"
                                                        : p.getPaymentType()%>

                                            </span>

                                        </td>


                                        <td>

                                            <span class="amount">

                                                Rs.
                                                <%= p.getAmount() == null
                                                        ? "0.00"
                                                        : p.getAmount()%>

                                            </span>

                                        </td>


                                        <td>

                                            <%= p.getPaymentMethod() == null
                                                    ? "-"
                                                    : p.getPaymentMethod()%>

                                        </td>


                                        <td>

                                            <span class="status status-paid">

                                                <%= p.getPaymentStatus() == null
                                                        ? "PAID"
                                                        : p.getPaymentStatus()%>

                                            </span>

                                        </td>


                                        <td>

                                            <%= p.getCreatedAt() == null
                                                    ? "-"
                                                    : p.getCreatedAt()%>

                                        </td>


                                    </tr>


                                    <%
                                        }
                                    %>


                                </tbody>

                            </table>

                        </div>


                        <% } else { %>


                        <div class="empty">

                            <i class="fa-regular fa-credit-card"></i>

                            <p>
                                No patient payments have been
                                recorded yet.
                            </p>

                        </div>


                        <% }%>

                    </div>



                    <!-- =================================================
                         QUICK ACTIONS
                         ================================================= -->

                    <div class="panel">

                        <div class="panel-header">

                            <div>

                                <div class="panel-title">

                                    Quick Actions

                                </div>

                                <div class="panel-subtitle">

                                    Choose an action to continue

                                </div>

                            </div>

                        </div>


                        <div class="action-grid">


                            <a class="action"
                               href="CashierBillingServlet">

                                <div class="action-icon">

                                    <i class="fa-solid fa-file-invoice-dollar"></i>

                                </div>

                                <div class="action-content">

                                    <strong>
                                        Billing
                                    </strong>

                                    <span>
                                        Search confirmed appointment
                                    </span>

                                </div>

                            </a>


                            <a class="action"
                               href="CashierBillingServlet">

                                <div class="action-icon">

                                    <i class="fa-solid fa-credit-card"></i>

                                </div>

                                <div class="action-content">

                                    <strong>
                                        Payment Records
                                    </strong>

                                    <span>
                                        View patient payments
                                    </span>

                                </div>

                            </a>


                            <a class="action"
                               href="cashier-profile.jsp">

                                <div class="action-icon">

                                    <i class="fa-solid fa-user"></i>

                                </div>

                                <div class="action-content">

                                    <strong>
                                        My Profile
                                    </strong>

                                    <span>
                                        View cashier profile
                                    </span>

                                </div>

                            </a>


                            <a class="action"
                               href="Index.jsp">

                                <div class="action-icon">

                                    <i class="fa-solid fa-house"></i>

                                </div>

                                <div class="action-content">

                                    <strong>
                                        Home
                                    </strong>

                                    <span>
                                        Return to home page
                                    </span>

                                </div>

                            </a>


                            <a class="action"
                               href="LogoutServlet">

                                <div class="action-icon">

                                    <i class="fa-solid fa-right-from-bracket"></i>

                                </div>

                                <div class="action-content">

                                    <strong>
                                        Logout
                                    </strong>

                                    <span>
                                        Securely sign out
                                    </span>

                                </div>

                            </a>


                        </div>

                    </div>



                    <!-- =================================================
                         CASHIER WORKFLOW
                         ================================================= -->

                    <div class="panel">

                        <div class="panel-header">

                            <div>

                                <div class="panel-title">

                                    Cashier Payment Workflow

                                </div>

                                <div class="panel-subtitle">

                                    Patient payment management process

                                </div>

                            </div>

                        </div>


                        <div class="workflow">


                            <div class="workflow-step">

                                <div class="workflow-number">
                                    1
                                </div>

                                <strong>
                                    Patient Pays
                                </strong>

                                <span>
                                    Patient pays the consultation
                                    or treatment amount.
                                </span>

                            </div>


                            <div class="workflow-step">

                                <div class="workflow-number">
                                    2
                                </div>

                                <strong>
                                    Payment Recorded
                                </strong>

                                <span>
                                    The payment is stored in
                                    the payment records.
                                </span>

                            </div>


                            <div class="workflow-step">

                                <div class="workflow-number">
                                    3
                                </div>

                                <strong>
                                    Cashier Verifies
                                </strong>

                                <span>
                                    Cashier can view the
                                    payment details.
                                </span>

                            </div>


                            <div class="workflow-step">

                                <div class="workflow-number">
                                    4
                                </div>

                                <strong>
                                    Receipt
                                </strong>

                                <span>
                                    Payment receipt can be
                                    generated through billing.
                                </span>

                            </div>


                        </div>

                    </div>



                    <!-- FOOTER -->

                    <div class="footer">

                        Sunrise Dental Clinic
                        &nbsp; | &nbsp;
                        Cashier Management System

                    </div>


                </section>

            </main>

        </div>

    </body>

</html>