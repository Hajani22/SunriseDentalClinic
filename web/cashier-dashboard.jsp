```jsp
<%@page import="java.util.*"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Payment"%>
<%@page import="service.PaymentService"%>
<%@page import="service.impl.PaymentServiceImpl"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    /* =========================================================
       CASHIER LOGIN CHECK
       ========================================================= */

    if (session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=session"
        );

        return;
    }


    /* =========================================================
       ROLE CHECK
       ========================================================= */
    String userRole
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"cashier".equalsIgnoreCase(userRole)) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }


    /* =========================================================
       CASHIER NAME
       ========================================================= */
    String cashierName
            = String.valueOf(
                    session.getAttribute("userName")
            );

    if (cashierName == null
            || "null".equalsIgnoreCase(cashierName)
            || cashierName.trim().isEmpty()) {

        cashierName = "Cashier";
    }


    /* =========================================================
       LOAD PAYMENT RECORDS
       ========================================================= */
    PaymentService paymentService
            = new PaymentServiceImpl();

    List<Payment> paymentRecords
            = new ArrayList<>();

    String paymentError = null;

    try {

        paymentRecords
                = paymentService.getAllPayments();

    } catch (Exception e) {

        e.printStackTrace();

        paymentError
                = "Unable to load payment records.";

        paymentRecords
                = new ArrayList<>();
    }


    /* =========================================================
       DASHBOARD STATISTICS
       ========================================================= */
    int totalPayments
            = paymentRecords.size();

    int paidPayments = 0;

    int pendingPayments = 0;

    int failedPayments = 0;

    BigDecimal totalRevenue
            = BigDecimal.ZERO;

    for (Payment payment : paymentRecords) {

        if (payment == null) {
            continue;
        }

        String status
                = payment.getPaymentStatus();

        BigDecimal amount
                = payment.getAmount();

        if ("PAID".equalsIgnoreCase(status)
                || "COMPLETED".equalsIgnoreCase(status)) {

            paidPayments++;

            if (amount != null) {

                totalRevenue
                        = totalRevenue.add(amount);
            }

        } else if ("PENDING".equalsIgnoreCase(status)) {

            pendingPayments++;

        } else if ("FAILED".equalsIgnoreCase(status)) {

            failedPayments++;
        }
    }

%>


<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width,
              initial-scale=1.0">

        <title>
            Cashier Dashboard | Sunrise Dental Clinic
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


            html {
                scroll-behavior: smooth;
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


            /* =====================================================
               MAIN LAYOUT
               ===================================================== */

            .dashboard {

                min-height: 100vh;

                display: flex;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                width: 245px;

                position: fixed;

                left: 0;

                top: 0;

                bottom: 0;

                background: #102f43;

                color: white;

                padding: 22px 15px;

                z-index: 1000;
            }


            .brand {

                display: flex;

                align-items: center;

                gap: 11px;

                padding: 8px 10px 25px;

                margin-bottom: 18px;

                border-bottom:
                    1px solid
                    rgba(255,255,255,.10);
            }


            .brand-icon {

                width: 40px;

                height: 40px;

                flex-shrink: 0;

                border-radius: 10px;

                background: #087fa8;

                color: white;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 18px;
            }


            .brand-text {

                font-family: "Jost", sans-serif;

                font-size: 15px;

                font-weight: 700;
            }


            .menu-title {

                padding: 10px 12px;

                color:
                    rgba(255,255,255,.42);

                font-size: 10px;

                font-weight: 700;

                text-transform: uppercase;

                letter-spacing: 1px;
            }


            .nav-link {

                display: flex;

                align-items: center;

                gap: 12px;

                padding: 12px;

                margin-bottom: 5px;

                border-radius: 9px;

                color:
                    rgba(255,255,255,.72);

                text-decoration: none;

                font-size: 13px;

                transition:
                    background .2s,
                    color .2s;
            }


            .nav-link i {

                width: 20px;

                text-align: center;
            }


            .nav-link:hover {

                background:
                    rgba(255,255,255,.09);

                color: white;
            }


            .nav-link.active {

                background: #087fa8;

                color: white;
            }


            .logout {

                position: absolute;

                left: 15px;

                right: 15px;

                bottom: 20px;
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                width:
                    calc(100% - 245px);

                margin-left: 245px;
            }


            /* =====================================================
               TOPBAR
               ===================================================== */

            .topbar {

                height: 70px;

                background: white;

                border-bottom:
                    1px solid #e4edf1;

                padding: 0 30px;

                display: flex;

                align-items: center;

                justify-content: space-between;

                position: sticky;

                top: 0;

                z-index: 900;
            }


            .topbar-title {

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 20px;

                font-weight: 700;
            }


            .cashier-user {

                display: flex;

                align-items: center;

                gap: 10px;
            }


            .user-avatar {

                width: 38px;

                height: 38px;

                border-radius: 50%;

                background: #eaf6fa;

                color: #087fa8;

                display: flex;

                align-items: center;

                justify-content: center;
            }


            .user-name {

                color: #102f43;

                font-size: 12px;

                font-weight: 700;
            }


            .user-role {

                color: #8a9aa4;

                font-size: 10px;
            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding: 30px;
            }


            .welcome {

                margin-bottom: 25px;
            }


            .welcome h1 {

                margin: 0;

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 29px;
            }


            .welcome p {

                margin: 6px 0 0;

                color: #82939e;

                font-size: 13px;
            }


            /* =====================================================
               STATISTICS
               ===================================================== */

            .stats {

                display: grid;

                grid-template-columns:
                    repeat(3, 1fr);

                gap: 18px;

                margin-bottom: 25px;
            }


            .stat-card {

                padding: 20px;

                background: white;

                border:
                    1px solid #e4edf1;

                border-radius: 14px;

                display: flex;

                align-items: center;

                gap: 15px;

                box-shadow:
                    0 5px 18px
                    rgba(15,23,42,.04);
            }


            .stat-icon {

                width: 48px;

                height: 48px;

                flex-shrink: 0;

                border-radius: 12px;

                background: #eef7fa;

                color: #087fa8;

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 19px;
            }


            .stat-label {

                margin-bottom: 4px;

                color: #82939e;

                font-size: 11px;
            }


            .stat-value {

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 23px;

                font-weight: 700;
            }


            /* =====================================================
               PANEL
               ===================================================== */

            .panel {

                background: white;

                border:
                    1px solid #e4edf1;

                border-radius: 15px;

                overflow: hidden;

                box-shadow:
                    0 5px 18px
                    rgba(15,23,42,.04);
            }


            .panel-header {

                padding: 20px 22px;

                border-bottom:
                    1px solid #edf2f5;

                display: flex;

                align-items: center;

                justify-content: space-between;

                gap: 15px;
            }


            .panel-title {

                color: #102f43;

                font-family: "Jost", sans-serif;

                font-size: 18px;

                font-weight: 700;
            }


            .panel-subtitle {

                margin-top: 4px;

                color: #82939e;

                font-size: 11px;
            }


            .panel-actions {

                display: flex;

                gap: 8px;

                flex-wrap: wrap;
            }


            .action-btn {

                display: inline-flex;

                align-items: center;

                gap: 7px;

                padding: 9px 13px;

                border:
                    1px solid #dce7eb;

                border-radius: 8px;

                background: white;

                color: #526572;

                text-decoration: none;

                font-size: 11px;

                font-weight: 700;

                cursor: pointer;
            }


            .action-btn:hover {

                background: #f5fafc;
            }


            .action-btn.primary {

                background: #087fa8;

                border-color: #087fa8;

                color: white;
            }


            /* =====================================================
               SEARCH
               ===================================================== */

            .search-area {

                padding: 17px 22px;

                background: #fbfdfe;

                border-bottom:
                    1px solid #edf2f5;

                display: flex;

                gap: 10px;
            }


            .search-box {

                flex: 1;

                position: relative;
            }


            .search-box i {

                position: absolute;

                left: 13px;

                top: 50%;

                transform:
                    translateY(-50%);

                color: #9aabb4;

                font-size: 12px;
            }


            .search-box input {

                width: 100%;

                padding:
                    11px 13px 11px 36px;

                border:
                    1px solid #dce7eb;

                border-radius: 9px;

                outline: none;

                font-size: 12px;
            }


            .search-box input:focus {

                border-color: #087fa8;
            }


            .filter-select {

                padding: 10px 12px;

                border:
                    1px solid #dce7eb;

                border-radius: 9px;

                background: white;

                color: #526572;

                outline: none;

                font-size: 11px;
            }


            /* =====================================================
               ERROR
               ===================================================== */

            .database-error {

                margin: 18px 22px;

                padding: 12px 15px;

                border-radius: 8px;

                background: #fff0f0;

                border:
                    1px solid #ffd1d1;

                color: #c62828;

                font-size: 12px;
            }


            /* =====================================================
               TABLE
               ===================================================== */

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

                padding: 14px 17px;

                background: #f8fafb;

                border-bottom:
                    1px solid #e4edf1;

                color: #758791;

                text-align: left;

                white-space: nowrap;

                font-size: 10px;

                font-weight: 700;

                text-transform: uppercase;
            }


            td {

                padding: 15px 17px;

                border-bottom:
                    1px solid #edf2f5;

                color: #526572;

                white-space: nowrap;

                font-size: 12px;
            }


            tr:last-child td {

                border-bottom: none;
            }


            tr:hover td {

                background: #fbfdfe;
            }


            .payment-no {

                color: #102f43;

                font-weight: 700;
            }


            .patient-name {

                color: #102f43;

                font-weight: 600;
            }


            .appointment-no {

                color: #087fa8;

                font-weight: 600;
            }


            .amount {

                color: #102f43;

                font-weight: 700;
            }


            .method {

                display: inline-flex;

                align-items: center;

                gap: 6px;

                color: #087fa8;

                font-weight: 600;
            }


            .status {

                display: inline-block;

                padding: 5px 10px;

                border-radius: 20px;

                font-size: 9px;

                font-weight: 700;

                text-transform: uppercase;
            }


            .status-paid {

                background: #e4f7ed;

                color: #16834b;
            }


            .status-pending {

                background: #fff4d6;

                color: #9a6a00;
            }


            .status-failed {

                background: #ffe6e6;

                color: #c62828;
            }


            /* =====================================================
               EMPTY
               ===================================================== */

            .empty {

                padding: 60px 20px;

                text-align: center;
            }


            .empty i {

                margin-bottom: 13px;

                color: #b8cbd3;

                font-size: 38px;
            }


            .empty h3 {

                margin: 5px 0;

                color: #102f43;

                font-family: "Jost", sans-serif;
            }


            .empty p {

                margin: 0;

                color: #82939e;

                font-size: 12px;
            }


            .table-footer {

                padding: 14px 20px;

                background: #fbfdfe;

                border-top:
                    1px solid #edf2f5;

                color: #82939e;

                font-size: 11px;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width:1050px) {

                .stats {

                    grid-template-columns:
                        repeat(2, 1fr);
                }
            }


            @media(max-width:800px) {

                .sidebar {

                    width: 70px;
                }


                .brand-text,
                .menu-title,
                .nav-link span {

                    display: none;
                }


                .brand {

                    justify-content: center;
                }


                .nav-link {

                    justify-content: center;
                }


                .main {

                    margin-left: 70px;

                    width:
                        calc(100% - 70px);
                }


                .content {

                    padding: 20px;
                }


                .stats {

                    grid-template-columns: 1fr;
                }
            }


            @media(max-width:600px) {

                .topbar {

                    padding: 0 15px;
                }


                .topbar-title {

                    font-size: 17px;
                }


                .user-name,
                .user-role {

                    display: none;
                }


                .panel-header {

                    align-items: flex-start;

                    flex-direction: column;
                }


                .search-area {

                    flex-direction: column;
                }


                .filter-select {

                    width: 100%;
                }
            }

        </style>

    </head>


    <body>


        <div class="dashboard">


            <!-- =====================================================
                 SIDEBAR
                 ===================================================== -->

            <aside class="sidebar">


                <!-- BRAND -->

                <div class="brand">

                    <div class="brand-icon">

                        <i class="fa-solid fa-tooth"></i>

                    </div>


                    <div class="brand-text">

                        Sunrise Dental Clinic

                    </div>

                </div>


                <!-- MAIN MENU -->

                <div class="menu-title">

                    Main Menu

                </div>


                <!-- DASHBOARD -->

                <a href="<%=request.getContextPath()%>/cashier-dashboard.jsp"
                   class="nav-link active">

                    <i class="fa-solid fa-chart-line"></i>

                    <span>
                        Dashboard
                    </span>

                </a>


                <!-- BILLS -->

                <a href="<%=request.getContextPath()%>/CashierBillingServlet"
                   class="nav-link">

                    <i class="fa-solid fa-file-invoice-dollar"></i>

                    <span>
                        Bills
                    </span>

                </a>


                <!-- =================================================
                     PAYMENT RECORDS
                     FIXED
                     ================================================= -->

                <a href="<%=request.getContextPath()%>/CashierPaymentsServlet"
                   class="nav-link">

                    <i class="fa-solid fa-credit-card"></i>

                    <span>
                        Payment Records
                    </span>

                </a>


                <!-- MANAGEMENT -->

                <div class="menu-title">

                    Management

                </div>


                <!-- =================================================
                     NOTIFICATIONS
                     FIXED
                     ================================================= -->

                <a href="<%=request.getContextPath()%>/CashierNotificationsServlet"
                   class="nav-link">

                    <i class="fa-solid fa-bell"></i>

                    <span>
                        Notifications
                    </span>

                </a>


                <!-- LOGOUT -->

                <div class="logout">

                    <a href="<%=request.getContextPath()%>/LogoutServlet"
                       class="nav-link">

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


                <!-- =================================================
                     TOPBAR
                     ================================================= -->

                <header class="topbar">


                    <div class="topbar-title">

                        Cashier Dashboard

                    </div>


                    <div class="cashier-user">


                        <div class="user-avatar">

                            <i class="fa-solid fa-user"></i>

                        </div>


                        <div>

                            <div class="user-name">

                                <%=cashierName%>

                            </div>


                            <div class="user-role">

                                Cashier

                            </div>

                        </div>


                    </div>


                </header>


                <!-- =================================================
                     CONTENT
                     ================================================= -->

                <section class="content">


                    <!-- WELCOME -->

                    <div class="welcome">

                        <h1>

                            Good day, <%=cashierName%>

                        </h1>


                        <p>

                            Manage patient payments and
                            clinic billing records.

                        </p>

                    </div>


                    <!-- =================================================
                         STATISTICS
                         ================================================= -->

                    <div class="stats">


                        <!-- TOTAL PAYMENTS -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-credit-card"></i>

                            </div>


                            <div>

                                <div class="stat-label">

                                    Total Payments

                                </div>


                                <div class="stat-value">

                                    <%=totalPayments%>

                                </div>

                            </div>

                        </div>


                        <!-- PAID PAYMENTS -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-circle-check"></i>

                            </div>


                            <div>

                                <div class="stat-label">

                                    Paid Payments

                                </div>


                                <div class="stat-value">

                                    <%=paidPayments%>

                                </div>

                            </div>

                        </div>


                        <!-- REVENUE -->

                        <div class="stat-card">

                            <div class="stat-icon">

                                <i class="fa-solid fa-money-bill-wave"></i>

                            </div>


                            <div>

                                <div class="stat-label">

                                    Total Revenue

                                </div>


                                <div class="stat-value">

                                    Rs.
                                    <%=totalRevenue.setScale(
                                            2,
                                            java.math.RoundingMode.HALF_UP
                            )%>

                                </div>

                            </div>

                        </div>


                    </div>


                    <!-- =================================================
                         PAYMENT RECORDS PANEL
                         ================================================= -->

                    <div class="panel"
                         id="paymentRecords">


                        <!-- PANEL HEADER -->

                        <div class="panel-header">


                            <div>

                                <div class="panel-title">

                                    Payment Records

                                </div>


                                <div class="panel-subtitle">

                                    All patient payment transactions

                                </div>

                            </div>


                            <div class="panel-actions">


                                <!-- REFRESH -->

                                <a href="<%=request.getContextPath()%>/cashier-dashboard.jsp"
                                   class="action-btn">

                                    <i class="fa-solid fa-rotate"></i>

                                    Refresh

                                </a>


                                <!-- OPEN FULL PAYMENT PAGE -->

                                <a href="<%=request.getContextPath()%>/CashierPaymentsServlet"
                                   class="action-btn primary">

                                    <i class="fa-solid fa-credit-card"></i>

                                    View All Payments

                                </a>


                                <!-- EXPORT -->

                                <button type="button"
                                        class="action-btn"
                                        onclick="exportPayments()">

                                    <i class="fa-solid fa-file-export"></i>

                                    Export CSV

                                </button>


                            </div>

                        </div>


                        <!-- =================================================
                             SEARCH + FILTER
                             ================================================= -->

                        <div class="search-area">


                            <div class="search-box">

                                <i class="fa-solid fa-magnifying-glass"></i>


                                <input type="text"
                                       id="paymentSearch"
                                       placeholder="Search patient, payment number, appointment..."
                                       onkeyup="filterPayments()">

                            </div>


                            <select id="statusFilter"
                                    class="filter-select"
                                    onchange="filterPayments()">


                                <option value="ALL">

                                    All Status

                                </option>


                                <option value="PAID">

                                    Paid

                                </option>


                                <option value="PENDING">

                                    Pending

                                </option>


                                <option value="FAILED">

                                    Failed

                                </option>


                            </select>


                        </div>


                        <!-- DATABASE ERROR -->

                        <%

                            if (paymentError != null) {

                        %>


                        <div class="database-error">

                            <i class="fa-solid fa-triangle-exclamation"></i>

                            <%=paymentError%>

                        </div>


                        <%

                            }

                        %>


                        <!-- =================================================
                             PAYMENT TABLE
                             ================================================= -->

                        <div class="table-wrapper">


                            <table id="paymentTable">


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


                                    <%                            if (paymentRecords != null
                                                && !paymentRecords.isEmpty()) {

                                            for (Payment payment
                                                    : paymentRecords) {

                                                if (payment == null) {

                                                    continue;
                                                }

                                                String status
                                                        = payment.getPaymentStatus();

                                                String statusClass
                                                        = "status-pending";

                                                if ("PAID".equalsIgnoreCase(status)
                                                        || "COMPLETED".equalsIgnoreCase(status)) {

                                                    statusClass
                                                            = "status-paid";

                                                } else if ("FAILED".equalsIgnoreCase(status)) {

                                                    statusClass
                                                            = "status-failed";
                                                }

                                                String method
                                                        = payment.getPaymentMethod();

                                                String methodIcon
                                                        = "fa-credit-card";

                                                if ("CASH".equalsIgnoreCase(method)) {

                                                    methodIcon
                                                            = "fa-money-bill-wave";

                                                } else if ("BANK_TRANSFER".equalsIgnoreCase(method)) {

                                                    methodIcon
                                                            = "fa-building-columns";
                                                }

                                                String paymentType
                                                        = payment.getPaymentType();

                                                String displayType
                                                        = paymentType;

                                                if ("CONSULTATION".equalsIgnoreCase(paymentType)) {

                                                    displayType
                                                            = "Consultation Fee";

                                                } else if ("TREATMENT".equalsIgnoreCase(paymentType)) {

                                                    displayType
                                                            = "Treatment Payment";
                                                }

                                    %>


                                    <tr>


                                        <!-- PAYMENT NUMBER -->

                                        <td>

                                            <span class="payment-no">

                                                <%=payment.getPaymentNo() != null
                                                        ? payment.getPaymentNo()
                                                        : "-"%>

                                            </span>

                                        </td>


                                        <!-- PATIENT -->

                                        <td>

                                            <span class="patient-name">

                                                <%=payment.getPatientName() != null
                                                        ? payment.getPatientName()
                                                        : "Unknown Patient"%>

                                            </span>

                                        </td>


                                        <!-- APPOINTMENT -->

                                        <td>

                                            <span class="appointment-no">

                                                <%=payment.getAppointmentNo() != null
                                                        ? payment.getAppointmentNo()
                                                        : "-"%>

                                            </span>

                                        </td>


                                        <!-- PAYMENT TYPE -->

                                        <td>

                                            <%=displayType != null
                                                    ? displayType
                                                    : "-"%>

                                        </td>


                                        <!-- AMOUNT -->

                                        <td>

                                            <span class="amount">

                                                Rs.

                                                <%=payment.getAmount() != null
                                                        ? payment.getAmount()
                                                        : "0.00"%>

                                            </span>

                                        </td>


                                        <!-- METHOD -->

                                        <td>

                                            <span class="method">

                                                <i class="fa-solid <%=methodIcon%>"></i>


                                                <%=method != null
                                                        ? method.replace("_", " ")
                                                        : "-"%>

                                            </span>

                                        </td>


                                        <!-- STATUS -->

                                        <td>

                                            <span class="status <%=statusClass%>">

                                                <%=status != null
                                                        ? status
                                                        : "UNKNOWN"%>

                                            </span>

                                        </td>


                                        <!-- DATE -->

                                        <td>

                                            <%=payment.getCreatedAt() != null
                                                    ? payment.getCreatedAt()
                                                    : "-"%>

                                        </td>


                                    </tr>


                                    <%

                                        }

                                    } else {

                                    %>


                                    <tr>

                                        <td colspan="8">

                                            <div class="empty">

                                                <i class="fa-solid fa-receipt"></i>

                                                <h3>

                                                    No Payment Records

                                                </h3>

                                                <p>

                                                    There are currently
                                                    no patient payment records.

                                                </p>

                                            </div>

                                        </td>

                                    </tr>


                                    <%                            }

                                    %>


                                </tbody>


                            </table>


                        </div>


                        <!-- FOOTER -->

                        <div class="table-footer">

                            Showing

                            <strong>

                                <%=paymentRecords.size()%>

                            </strong>

                            payment record(s).

                        </div>


                    </div>


                </section>


            </main>


        </div>


        <!-- TOAST -->

        <jsp:include page="toast.jsp" />


        <script>


            /* =========================================================
             SEARCH + STATUS FILTER
             ========================================================= */

            function filterPayments() {


                const searchInput =
                        document.getElementById(
                                "paymentSearch"
                                );


                const statusFilter =
                        document.getElementById(
                                "statusFilter"
                                );


                const search =
                        searchInput.value
                        .toLowerCase()
                        .trim();


                const selectedStatus =
                        statusFilter.value
                        .toUpperCase();


                const rows =
                        document.querySelectorAll(
                                "#paymentTable tbody tr"
                                );


                rows.forEach(
                        function (row) {


                            const statusElement =
                                    row.querySelector(
                                            ".status"
                                            );


                            /*
                             * Ignore empty record row.
                             */

                            if (!statusElement) {

                                return;
                            }


                            const rowText =
                                    row.textContent
                                    .toLowerCase();


                            const rowStatus =
                                    statusElement.textContent
                                    .trim()
                                    .toUpperCase();


                            const matchesSearch =
                                    rowText.includes(
                                            search
                                            );


                            const matchesStatus =
                                    selectedStatus === "ALL"
                                    ||
                                    rowStatus === selectedStatus;


                            if (matchesSearch
                                    && matchesStatus) {

                                row.style.display = "";

                            } else {

                                row.style.display = "none";
                            }

                        }
                );

            }


            /* =========================================================
             EXPORT PAYMENT RECORDS
             ========================================================= */

            function exportPayments() {


                const table =
                        document.getElementById(
                                "paymentTable"
                                );


                const rows =
                        table.querySelectorAll(
                                "tr"
                                );


                let csv = [];


                rows.forEach(
                        function (row) {


                            /*
                             * Don't export hidden rows.
                             */

                            if (
                                    row.style.display
                                    === "none"
                                    ) {

                                return;
                            }


                            const columns =
                                    row.querySelectorAll(
                                            "th, td"
                                            );


                            let rowData = [];


                            columns.forEach(
                                    function (column) {


                                        let value =
                                                column.innerText
                                                .replace(
                                                        /"/g,
                                                        '""'
                                                        )
                                                .replace(
                                                        /\n/g,
                                                        " "
                                                        )
                                                .trim();


                                        rowData.push(
                                                '"' +
                                                value +
                                                '"'
                                                );

                                    }
                            );


                            csv.push(
                                    rowData.join(",")
                                    );

                        }
                );


                if (csv.length <= 1) {


                    if (
                            typeof showSunriseToast
                            === "function"
                            ) {

                        showSunriseToast(
                                "No payment records available to export.",
                                "warning"
                                );

                    } else {

                        alert(
                                "No payment records available to export."
                                );
                    }


                    return;
                }


                const blob =
                        new Blob(
                                [
                                    csv.join("\n")
                                ],
                                {
                                    type:
                                            "text/csv;charset=utf-8;"
                                }
                        );


                const url =
                        URL.createObjectURL(
                                blob
                                );


                const link =
                        document.createElement(
                                "a"
                                );


                link.href = url;


                link.download =
                        "Sunrise_Dental_Payment_Records.csv";


                document.body.appendChild(
                        link
                        );


                link.click();


                document.body.removeChild(
                        link
                        );


                URL.revokeObjectURL(
                        url
                        );


                if (
                        typeof showSunriseToast
                        === "function"
                        ) {

                    showSunriseToast(
                            "Payment records exported successfully.",
                            "success"
                            );

                }

            }

        </script>


    </body>

</html>

