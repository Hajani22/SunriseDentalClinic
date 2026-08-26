<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Bill"%>

<%
    /* =========================================================
       SESSION / ACCESS CONTROL
       ========================================================= */

    if (session == null
            || session.getAttribute("user") == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp"
        );

        return;
    }

    String role
            = String.valueOf(
                    session.getAttribute("userRole")
            );

    if (!"cashier".equalsIgnoreCase(role)) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }

    String userName
            = (String) session.getAttribute("userName");

    if (userName == null
            || userName.trim().isEmpty()) {

        userName = "Cashier";
    }


    /* =========================================================
       REQUEST DATA
       ========================================================= */
    Bill bill
            = (Bill) request.getAttribute("bill");

    List<Bill> recentBills
            = (List<Bill>) request.getAttribute(
                    "recentBills"
            );

    String error
            = (String) request.getAttribute("error");


    /* =========================================================
       SAFE BILL VALUES
       ========================================================= */
    BigDecimal treatmentAmount
            = BigDecimal.ZERO;

    BigDecimal consultationFee
            = BigDecimal.ZERO;

    BigDecimal discount
            = BigDecimal.ZERO;

    BigDecimal totalAmount
            = BigDecimal.ZERO;

    if (bill != null) {

        if (bill.getTreatmentAmount() != null) {

            treatmentAmount
                    = bill.getTreatmentAmount();

        }

        if (bill.getConsultationFee() != null) {

            consultationFee
                    = bill.getConsultationFee();

        }

        if (bill.getDiscount() != null) {

            discount
                    = bill.getDiscount();

        }

        if (bill.getTotalAmount() != null) {

            totalAmount
                    = bill.getTotalAmount();

        }
    }


    /* =========================================================
       SEARCH / ERROR PARAMETERS
       ========================================================= */
    String appointmentNoParam
            = request.getParameter("appointmentNo");

    String errorParam
            = request.getParameter("error");

    if ((error == null || error.trim().isEmpty())
            && errorParam != null) {

        if ("payment".equalsIgnoreCase(errorParam)) {

            error
                    = "Please select a valid payment method.";

        } else if ("bill".equalsIgnoreCase(errorParam)) {

            error
                    = "Unable to prepare the bill. "
                    + "The appointment may already have a bill.";

        } else if ("save".equalsIgnoreCase(errorParam)) {

            error
                    = "Payment could not be saved. "
                    + "Please try again.";

        } else if ("server".equalsIgnoreCase(errorParam)) {

            error
                    = "An unexpected error occurred. "
                    + "Please contact the administrator.";

        } else if ("receipt".equalsIgnoreCase(errorParam)) {

            error
                    = "Receipt could not be loaded.";

        } else if ("access".equalsIgnoreCase(errorParam)) {

            error
                    = "You are not authorised to access this page.";
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
            Billing & Payments | Sunrise Dental Clinic
        </title>


        <!-- =====================================================
             GOOGLE FONTS
             ===================================================== -->

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">


        <!-- =====================================================
             FONT AWESOME
             ===================================================== -->

        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /* =====================================================
               GLOBAL
               ===================================================== */

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }


            body {

                font-family:
                    "Open Sans",
                    Arial,
                    sans-serif;

                background:
                    #f4f8fb;

                color:
                    #475569;

                min-height:
                    100vh;
            }


            /* =====================================================
               LAYOUT
               ===================================================== */

            .layout {

                min-height:
                    100vh;

                display:
                    flex;
            }


            /* =====================================================
               SIDEBAR
               ===================================================== */

            .sidebar {

                width:
                    250px;

                position:
                    fixed;

                inset:
                    0 auto 0 0;

                background:
                    #091e3e;

                color:
                    white;

                padding:
                    25px 18px;

                z-index:
                    1000;
            }


            .brand {

                font:
                    700 21px Jost,
                    sans-serif;

                margin:
                    10px 8px 35px;

                display:
                    flex;

                gap:
                    10px;

                align-items:
                    center;
            }


            .brand i {

                background:
                    #06a3da;

                padding:
                    12px;

                border-radius:
                    10px;
            }


            .menu a {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    12px;

                padding:
                    13px 14px;

                color:
                    #c7d2e0;

                text-decoration:
                    none;

                border-radius:
                    8px;

                margin-bottom:
                    6px;

                transition:
                    .2s ease;
            }


            .menu a:hover,
            .menu a.active {

                background:
                    #06a3da;

                color:
                    white;
            }


            .menu i {

                width:
                    18px;

                text-align:
                    center;
            }


            .logout {

                position:
                    absolute;

                bottom:
                    25px;

                left:
                    18px;

                right:
                    18px;
            }


            .logout a {

                color:
                    #ffb4b4;

                text-decoration:
                    none;

                display:
                    block;

                padding:
                    12px;

                border-radius:
                    8px;
            }


            .logout a:hover {

                background:
                    rgba(255,255,255,.08);
            }


            /* =====================================================
               MAIN
               ===================================================== */

            .main {

                margin-left:
                    250px;

                width:
                    calc(100% - 250px);

                min-height:
                    100vh;
            }


            /* =====================================================
               TOP BAR
               ===================================================== */

            .topbar {

                height:
                    72px;

                background:
                    white;

                border-bottom:
                    1px solid #e5ebf0;

                padding:
                    0 32px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;
            }


            .topbar h2 {

                font:
                    700 24px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .user {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    12px;
            }


            .user-details {

                text-align:
                    right;
            }


            .user-details strong {

                display:
                    block;

                color:
                    #091e3e;

                font-size:
                    14px;
            }


            .user-details small {

                display:
                    block;

                color:
                    #7b8794;

                font-size:
                    12px;

                margin-top:
                    2px;
            }


            .avatar {

                width:
                    42px;

                height:
                    42px;

                border-radius:
                    50%;

                background:
                    #e7f7fc;

                color:
                    #06a3da;

                display:
                    grid;

                place-items:
                    center;

                font-size:
                    17px;
            }


            /* =====================================================
               CONTENT
               ===================================================== */

            .content {

                padding:
                    30px;
            }


            .page-heading {

                margin-bottom:
                    25px;
            }


            .page-heading h1 {

                font:
                    700 32px Jost,
                    sans-serif;

                color:
                    #091e3e;
            }


            .page-heading p {

                margin-top:
                    6px;

                color:
                    #7b8794;

                font-size:
                    14px;
            }


            /* =====================================================
               CARDS
               ===================================================== */

            .card {

                background:
                    white;

                border:
                    1px solid #e5ebf0;

                border-radius:
                    16px;

                padding:
                    25px;

                margin-bottom:
                    22px;

                box-shadow:
                    0 8px 25px rgba(15,23,42,.05);
            }


            .section-title {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;

                font:
                    700 20px Jost,
                    sans-serif;

                color:
                    #091e3e;

                margin-bottom:
                    18px;
            }


            .section-title i {

                color:
                    #06a3da;
            }


            /* =====================================================
               SEARCH
               ===================================================== */

            .search-form {

                display:
                    flex;

                gap:
                    12px;

                width:
                    100%;
            }


            .search-wrapper {

                position:
                    relative;

                flex:
                    1;
            }


            .search-wrapper i {

                position:
                    absolute;

                left:
                    15px;

                top:
                    50%;

                transform:
                    translateY(-50%);

                color:
                    #94a3b8;
            }


            .search-form input {

                width:
                    100%;

                height:
                    50px;

                border:
                    1px solid #dbe3eb;

                border-radius:
                    9px;

                padding:
                    0 15px 0 43px;

                font-size:
                    14px;

                outline:
                    none;

                transition:
                    .2s ease;
            }


            .search-form input:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px rgba(6,163,218,.10);
            }


            .search-form button {

                height:
                    50px;

                border:
                    0;

                background:
                    #06a3da;

                color:
                    white;

                padding:
                    0 27px;

                border-radius:
                    9px;

                font-weight:
                    700;

                cursor:
                    pointer;

                display:
                    flex;

                align-items:
                    center;

                gap:
                    8px;

                transition:
                    .2s ease;
            }


            .search-form button:hover {

                background:
                    #078bb9;
            }


            .helper-text {

                margin-top:
                    10px;

                font-size:
                    12px;

                color:
                    #94a3b8;
            }


            /* =====================================================
               ERROR
               ===================================================== */

            .alert-error {

                display:
                    flex;

                align-items:
                    flex-start;

                gap:
                    10px;

                margin-bottom:
                    20px;

                padding:
                    14px 16px;

                border-radius:
                    10px;

                background:
                    #fff1f2;

                border:
                    1px solid #fecdd3;

                color:
                    #b42318;

                font-size:
                    14px;
            }


            .alert-error i {

                margin-top:
                    2px;
            }


            /* =====================================================
               PATIENT INFORMATION
               ===================================================== */

            .patient-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap:
                    14px;

                margin-bottom:
                    25px;
            }


            .info-box {

                background:
                    #f8fbfd;

                border:
                    1px solid #edf2f7;

                padding:
                    16px;

                border-radius:
                    10px;
            }


            .info-box label {

                display:
                    block;

                font-size:
                    11px;

                font-weight:
                    600;

                color:
                    #7b8794;

                text-transform:
                    uppercase;

                letter-spacing:
                    .3px;

                margin-bottom:
                    6px;
            }


            .info-box strong {

                display:
                    block;

                color:
                    #091e3e;

                font-size:
                    14px;

                line-height:
                    1.5;

                word-break:
                    break-word;
            }


            /* =====================================================
               BILL TABLE
               ===================================================== */

            .table-wrapper {

                overflow-x:
                    auto;
            }


            .bill-table {

                width:
                    100%;

                border-collapse:
                    collapse;

                margin-top:
                    5px;
            }


            .bill-table th {

                background:
                    #091e3e;

                color:
                    white;

                padding:
                    14px;

                text-align:
                    left;

                font-size:
                    13px;

                font-weight:
                    700;
            }


            .bill-table th:last-child {

                text-align:
                    right;
            }


            .bill-table td {

                padding:
                    15px 14px;

                border-bottom:
                    1px solid #edf2f7;

                font-size:
                    14px;
            }


            .bill-table td:last-child {

                text-align:
                    right;
            }


            .bill-table tbody tr:hover {

                background:
                    #fbfdff;
            }


            .description {

                color:
                    #334155;

                font-weight:
                    600;
            }


            .amount {

                color:
                    #091e3e;

                font-weight:
                    700;

                white-space:
                    nowrap;
            }


            /* =====================================================
               DISCOUNT
               ===================================================== */

            .discount-cell {

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

                gap:
                    15px;
            }


            .discount-input {

                width:
                    145px;

                height:
                    40px;

                border:
                    1px solid #dbe3eb;

                border-radius:
                    8px;

                padding:
                    0 11px;

                outline:
                    none;

                font-size:
                    14px;
            }


            .discount-input:focus {

                border-color:
                    #06a3da;

                box-shadow:
                    0 0 0 3px rgba(6,163,218,.08);
            }


            /* =====================================================
               TOTAL
               ===================================================== */

            .total-row td {

                padding-top:
                    20px;

                padding-bottom:
                    20px;

                background:
                    #f8fbfd;

                font-size:
                    17px;
            }


            .total-label {

                color:
                    #091e3e;

                font-weight:
                    700;
            }


            .total-amount {

                color:
                    #06a3da;

                font-size:
                    21px;

                font-weight:
                    700;
            }


            /* =====================================================
               PAYMENT AREA
               ===================================================== */

            .payment-section {

                margin-top:
                    25px;

                padding-top:
                    25px;

                border-top:
                    1px solid #edf2f7;

                display:
                    grid;

                grid-template-columns:
                    1fr 1fr;

                gap:
                    25px;

                align-items:
                    end;
            }


            .field-label {

                display:
                    block;

                font-size:
                    13px;

                font-weight:
                    700;

                color:
                    #091e3e;

                margin-bottom:
                    9px;
            }


            .required {

                color:
                    #dc2626;
            }


            .payment-methods {

                display:
                    grid;

                grid-template-columns:
                    repeat(3, 1fr);

                gap:
                    10px;
            }


            .payment-option {

                position:
                    relative;

                cursor:
                    pointer;
            }


            .payment-option input {

                position:
                    absolute;

                opacity:
                    0;

                pointer-events:
                    none;
            }


            .payment-option span {

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    8px;

                min-height:
                    48px;

                padding:
                    0 12px;

                border:
                    1px solid #dbe3eb;

                border-radius:
                    9px;

                color:
                    #475569;

                background:
                    white;

                font-size:
                    13px;

                font-weight:
                    600;

                transition:
                    .2s ease;
            }


            .payment-option span:hover {

                border-color:
                    #06a3da;

                background:
                    #f5fcff;
            }


            .payment-option input:checked + span {

                border-color:
                    #06a3da;

                background:
                    #eaf8fd;

                color:
                    #067da8;

                box-shadow:
                    0 0 0 2px rgba(6,163,218,.08);
            }


            .payment-option input:focus + span {

                box-shadow:
                    0 0 0 3px rgba(6,163,218,.15);
            }


            /* =====================================================
               PAYMENT ACTIONS
               ===================================================== */

            .payment-actions {

                display:
                    flex;

                flex-direction:
                    column;

                gap:
                    10px;
            }


            .pay-btn {

                width:
                    100%;

                min-height:
                    50px;

                padding:
                    0 20px;

                border:
                    0;

                border-radius:
                    9px;

                background:
                    #198754;

                color:
                    white;

                font-size:
                    14px;

                font-weight:
                    700;

                cursor:
                    pointer;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    9px;

                transition:
                    .2s ease;
            }


            .pay-btn:hover {

                background:
                    #157347;

                transform:
                    translateY(-1px);
            }


            .pay-btn:disabled {

                opacity:
                    .6;

                cursor:
                    not-allowed;

                transform:
                    none;
            }


            .cancel-btn {

                width:
                    100%;

                min-height:
                    44px;

                border:
                    1px solid #dbe3eb;

                background:
                    white;

                color:
                    #64748b;

                border-radius:
                    9px;

                font-weight:
                    600;

                cursor:
                    pointer;

                text-decoration:
                    none;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                transition:
                    .2s ease;
            }


            .cancel-btn:hover {

                background:
                    #f8fafc;

                border-color:
                    #cbd5e1;
            }


            /* =====================================================
               EMPTY STATE
               ===================================================== */

            .empty-state {

                text-align:
                    center;

                padding:
                    45px 20px;

                color:
                    #94a3b8;
            }


            .empty-state i {

                font-size:
                    38px;

                color:
                    #cbd5e1;

                margin-bottom:
                    12px;
            }


            .empty-state h3 {

                color:
                    #475569;

                font-size:
                    17px;

                margin-bottom:
                    5px;
            }


            .empty-state p {

                font-size:
                    13px;
            }


            /* =====================================================
               RECENT BILLS
               ===================================================== */

            .recent-table-wrapper {

                overflow-x:
                    auto;
            }


            .recent-table {

                width:
                    100%;

                border-collapse:
                    collapse;

                min-width:
                    720px;
            }


            .recent-table th {

                text-align:
                    left;

                padding:
                    13px 12px;

                background:
                    #f1f5f9;

                color:
                    #334155;

                font-size:
                    12px;

                text-transform:
                    uppercase;

                letter-spacing:
                    .3px;
            }


            .recent-table td {

                padding:
                    14px 12px;

                border-bottom:
                    1px solid #edf2f7;

                font-size:
                    13px;
            }


            .recent-table tbody tr:hover {

                background:
                    #fbfdff;
            }


            .bill-number {

                color:
                    #091e3e;

                font-weight:
                    700;
            }


            .paid-badge {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    5px;

                padding:
                    5px 9px;

                border-radius:
                    20px;

                background:
                    #e8f8ef;

                color:
                    #16834b;

                font-size:
                    11px;

                font-weight:
                    700;
            }


            .method-badge {

                color:
                    #475569;

                font-weight:
                    600;
            }


            .print-link {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    6px;

                color:
                    #06a3da;

                text-decoration:
                    none;

                font-weight:
                    700;

                font-size:
                    13px;
            }


            .print-link:hover {

                color:
                    #0788b6;

                text-decoration:
                    underline;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media (max-width: 1100px) {

                .patient-grid {

                    grid-template-columns:
                        repeat(2, 1fr);
                }

                .payment-section {

                    grid-template-columns:
                        1fr;
                }
            }


            @media (max-width: 900px) {

                .sidebar {

                    width:
                        72px;

                    padding:
                        20px 10px;
                }


                .brand {

                    justify-content:
                        center;

                    margin:
                        10px 0 35px;
                }


                .brand span,
                .menu span,
                .logout span {

                    display:
                        none;
                }


                .menu a {

                    justify-content:
                        center;

                    padding:
                        13px 8px;
                }


                .logout {

                    left:
                        10px;

                    right:
                        10px;
                }


                .logout a {

                    text-align:
                        center;
                }


                .main {

                    margin-left:
                        72px;

                    width:
                        calc(100% - 72px);
                }
            }


            @media (max-width: 650px) {

                .topbar {

                    padding:
                        0 18px;
                }


                .topbar h2 {

                    font-size:
                        19px;
                }


                .user-details {

                    display:
                        none;
                }


                .content {

                    padding:
                        18px;
                }


                .page-heading h1 {

                    font-size:
                        27px;
                }


                .card {

                    padding:
                        18px;
                }


                .search-form {

                    flex-direction:
                        column;
                }


                .search-form button {

                    width:
                        100%;

                    justify-content:
                        center;
                }


                .patient-grid {

                    grid-template-columns:
                        1fr;
                }


                .payment-methods {

                    grid-template-columns:
                        1fr;
                }


                .discount-cell {

                    flex-direction:
                        column;

                    align-items:
                        flex-start;
                }


                .discount-input {

                    width:
                        100%;
                }
            }


            /* =====================================================
               PRINT
               ===================================================== */

            @media print {

                .sidebar,
                .topbar,
                .search-card,
                .recent-card,
                .payment-section {

                    display:
                        none !important;
                }


                .main {

                    margin:
                        0;

                    width:
                        100%;
                }


                body {

                    background:
                        white;
                }


                .content {

                    padding:
                        0;
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

                    <a href="cashier-dashboard.jsp">

                        <i class="fa-solid fa-gauge"></i>

                        <span>
                            Dashboard
                        </span>

                    </a>


                    <a href="CashierBillingServlet"
                       class="active">

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
                 MAIN CONTENT
                 ===================================================== -->

            <main class="main">


                <!-- =================================================
                     TOP BAR
                     ================================================= -->

                <header class="topbar">

                    <h2>

                        <i class="fa-solid fa-file-invoice-dollar"></i>

                        Billing & Payments

                    </h2>


                    <div class="user">

                        <div class="user-details">

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



                <!-- =================================================
                     PAGE CONTENT
                     ================================================= -->

                <section class="content">


                    <div class="page-heading">

                        <h1>
                            Patient Billing
                        </h1>

                        <p>
                            Search a confirmed appointment, review treatment charges,
                            collect payment and generate a professional receipt.
                        </p>

                    </div>



                    <!-- =================================================
                         ERROR MESSAGE
                         ================================================= -->

                    <% if (error != null
                        && !error.trim().isEmpty()) {%>

                    <div class="alert-error">

                        <i class="fa-solid fa-circle-exclamation"></i>

                        <span>
                            <%= error%>
                        </span>

                    </div>

                    <% }%>



                    <!-- =================================================
                         SEARCH APPOINTMENT
                         ================================================= -->

                    <div class="card search-card">

                        <div class="section-title">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            Find Appointment

                        </div>


                        <form
                            method="get"
                            action="<%= request.getContextPath()%>/CashierBillingServlet"
                            class="search-form">


                            <div class="search-wrapper">

                                <i class="fa-solid fa-calendar-check"></i>

                                <input
                                    type="text"
                                    name="appointmentNo"
                                    value="<%= appointmentNoParam != null
                                            ? appointmentNoParam
                                            : (bill != null
                                            ? bill.getAppointmentNo()
                                            : "")%>"
                                    placeholder="Enter appointment number"
                                    autocomplete="off"
                                    maxlength="50"
                                    required>

                            </div>


                            <button type="submit">

                                <i class="fa-solid fa-search"></i>

                                Search Appointment

                            </button>

                        </form>


                        <div class="helper-text">

                            <i class="fa-solid fa-circle-info"></i>

                            Only confirmed appointments can be billed.

                        </div>

                    </div>



                    <!-- =================================================
                         BILL CARD
                         ================================================= -->

                    <% if (bill != null) {%>


                    <div class="card bill-card">


                        <div class="section-title">

                            <i class="fa-solid fa-file-invoice"></i>

                            Appointment & Patient Details

                        </div>



                        <!-- =========================================
                             PATIENT DETAILS
                             ========================================= -->

                        <div class="patient-grid">


                            <div class="info-box">

                                <label>
                                    Appointment No
                                </label>

                                <strong>
                                    <%= bill.getAppointmentNo()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Patient
                                </label>

                                <strong>
                                    <%= bill.getPatientName()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Contact Number
                                </label>

                                <strong>
                                    <%= bill.getPatientPhone() != null
                                        ? bill.getPatientPhone()
                                        : "Not available"%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Dentist
                                </label>

                                <strong>
                                    Dr. <%= bill.getDoctorName()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Treatment
                                </label>

                                <strong>
                                    <%= bill.getTreatmentType()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Appointment Date
                                </label>

                                <strong>
                                    <%= bill.getAppointmentDate()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Appointment Time
                                </label>

                                <strong>
                                    <%= bill.getAppointmentTime()%>
                                </strong>

                            </div>


                            <div class="info-box">

                                <label>
                                    Billing Status
                                </label>

                                <strong style="color:#198754;">

                                    <i class="fa-solid fa-circle-check"></i>

                                    Ready for Payment

                                </strong>

                            </div>

                        </div>



                        <!-- =========================================
                             PAYMENT FORM
                             ========================================= -->

                        <form
                            method="post"
                            action="<%= request.getContextPath()%>/CashierPaymentServlet"
                            id="paymentForm">


                            <input
                                type="hidden"
                                name="appointmentNo"
                                value="<%= bill.getAppointmentNo()%>">



                            <!-- =====================================
                                 BILL DETAILS
                                 ===================================== -->

                            <div class="section-title">

                                <i class="fa-solid fa-calculator"></i>

                                Bill Summary

                            </div>


                            <div class="table-wrapper">

                                <table class="bill-table">


                                    <thead>

                                        <tr>

                                            <th>
                                                Description
                                            </th>

                                            <th>
                                                Amount (LKR)
                                            </th>

                                        </tr>

                                    </thead>


                                    <tbody>


                                        <!-- Treatment -->
                                        <tr>

                                            <td class="description">

                                                <i class="fa-solid fa-tooth"
                                                   style="color:#06a3da;margin-right:7px;">
                                                </i>

                                                <%= bill.getTreatmentType()%>

                                            </td>

                                            <td class="amount">

                                                LKR
                                                <span id="treatmentAmount">
                                                    <%= treatmentAmount%>
                                                </span>

                                            </td>

                                        </tr>



                                        <!-- Consultation -->
                                        <tr>

                                            <td class="description">

                                                <i class="fa-solid fa-user-doctor"
                                                   style="color:#06a3da;margin-right:7px;">
                                                </i>

                                                Consultation Fee

                                            </td>

                                            <td class="amount">

                                                LKR
                                                <span id="consultationAmount">
                                                    <%= consultationFee%>
                                                </span>

                                            </td>

                                        </tr>



                                        <!-- Discount -->
                                        <tr>

                                            <td>

                                                <div class="discount-cell">

                                                    <span class="description">

                                                        <i class="fa-solid fa-tag"
                                                           style="color:#f59e0b;margin-right:7px;">
                                                        </i>

                                                        Discount

                                                    </span>


                                                    <input
                                                        type="number"
                                                        name="discount"
                                                        id="discount"
                                                        class="discount-input"
                                                        min="0"
                                                        max="<%= treatmentAmount.add(consultationFee)%>"
                                                        step="0.01"
                                                        value="<%= discount%>"
                                                        placeholder="0.00">

                                                </div>

                                            </td>


                                            <td class="amount">

                                                - LKR
                                                <span id="discountAmount">
                                                    <%= discount%>
                                                </span>

                                            </td>

                                        </tr>



                                        <!-- Total -->
                                        <tr class="total-row">

                                            <td class="total-label">

                                                TOTAL PAYABLE

                                            </td>


                                            <td class="total-amount">

                                                LKR
                                                <span id="totalAmount">
                                                    <%= totalAmount%>
                                                </span>

                                            </td>

                                        </tr>


                                    </tbody>

                                </table>

                            </div>



                            <!-- =====================================
                                 PAYMENT METHOD + ACTION
                                 ===================================== -->

                            <div class="payment-section">


                                <!-- PAYMENT METHODS -->

                                <div>

                                    <label class="field-label">

                                        Payment Method

                                        <span class="required">
                                            *
                                        </span>

                                    </label>


                                    <div class="payment-methods">


                                        <label class="payment-option">

                                            <input
                                                type="radio"
                                                name="paymentMethod"
                                                value="CASH"
                                                required>


                                            <span>

                                                <i class="fa-solid fa-money-bill-wave"></i>

                                                Cash

                                            </span>

                                        </label>



                                        <label class="payment-option">

                                            <input
                                                type="radio"
                                                name="paymentMethod"
                                                value="CARD"
                                                required>


                                            <span>

                                                <i class="fa-solid fa-credit-card"></i>

                                                Card

                                            </span>

                                        </label>



                                        <label class="payment-option">

                                            <input
                                                type="radio"
                                                name="paymentMethod"
                                                value="BANK_TRANSFER"
                                                required>


                                            <span>

                                                <i class="fa-solid fa-building-columns"></i>

                                                Bank Transfer

                                            </span>

                                        </label>


                                    </div>

                                </div>



                                <!-- ACTION BUTTONS -->

                                <div class="payment-actions">


                                    <button
                                        type="submit"
                                        class="pay-btn"
                                        id="payButton">

                                        <i class="fa-solid fa-circle-check"></i>

                                        Confirm Payment & Generate Receipt

                                    </button>


                                    <a
                                        href="<%= request.getContextPath()%>/CashierBillingServlet"
                                        class="cancel-btn">

                                        <i class="fa-solid fa-rotate-left"
                                           style="margin-right:7px;">
                                        </i>

                                        Clear Billing

                                    </a>

                                </div>


                            </div>


                        </form>


                    </div>


                    <% } else { %>


                    <!-- =================================================
                         EMPTY BILL STATE
                         ================================================= -->

                    <div class="card">

                        <div class="empty-state">

                            <i class="fa-solid fa-file-invoice-dollar"></i>

                            <h3>
                                No Appointment Selected
                            </h3>

                            <p>
                                Enter a confirmed appointment number above
                                to prepare the patient's bill.
                            </p>

                        </div>

                    </div>

                    <% } %>



                    <!-- =================================================
                         RECENT BILLS
                         ================================================= -->

                    <div class="card recent-card">


                        <div class="section-title">

                            <i class="fa-solid fa-clock-rotate-left"></i>

                            Recent Bills

                        </div>


                        <div class="recent-table-wrapper">

                            <table class="recent-table">


                                <thead>

                                    <tr>

                                        <th>
                                            Bill No
                                        </th>

                                        <th>
                                            Appointment
                                        </th>

                                        <th>
                                            Patient
                                        </th>

                                        <th>
                                            Treatment
                                        </th>

                                        <th>
                                            Total
                                        </th>

                                        <th>
                                            Payment
                                        </th>

                                        <th>
                                            Receipt
                                        </th>

                                    </tr>

                                </thead>


                                <tbody>


                                    <%
                                        if (recentBills != null
                                                && !recentBills.isEmpty()) {

                                            for (Bill recent
                                                    : recentBills) {
                                    %>


                                    <tr>


                                        <td>

                                            <span class="bill-number">

                                                <%= recent.getBillNo()%>

                                            </span>

                                        </td>


                                        <td>

                                            <%= recent.getAppointmentNo()%>

                                        </td>


                                        <td>

                                            <%= recent.getPatientName()%>

                                        </td>


                                        <td>

                                            <%= recent.getTreatmentType()%>

                                        </td>


                                        <td>

                                            <strong>

                                                LKR
                                                <%= recent.getTotalAmount()%>

                                            </strong>

                                        </td>


                                        <td>

                                            <span class="method-badge">

                                                <%= recent.getPaymentMethod()%>

                                            </span>

                                            <br>

                                            <span class="paid-badge">

                                                <i class="fa-solid fa-check"></i>

                                                <%= recent.getPaymentStatus() != null
                                                    ? recent.getPaymentStatus()
                                                    : "PAID"%>

                                            </span>

                                        </td>


                                        <td>

                                            <a
                                                class="print-link"
                                                href="<%= request.getContextPath()%>/CashierReceiptServlet?id=<%= recent.getId()%>">

                                                <i class="fa-solid fa-print"></i>

                                                Receipt

                                            </a>

                                        </td>


                                    </tr>


                                    <%
                                        }

                                    } else {
                                    %>


                                    <tr>

                                        <td colspan="7">

                                            <div class="empty-state"
                                                 style="padding:30px 10px;">

                                                <i class="fa-solid fa-receipt"
                                                   style="font-size:25px;">
                                                </i>

                                                <h3>
                                                    No Recent Bills
                                                </h3>

                                                <p>
                                                    Completed payments will appear here.
                                                </p>

                                            </div>

                                        </td>

                                    </tr>


                                    <%
                                        }
                                    %>


                                </tbody>

                            </table>

                        </div>


                    </div>


                </section>

            </main>

        </div>



        <!-- =========================================================
             JAVASCRIPT
             ========================================================= -->

        <script>

            /* =========================================================
             BILL CALCULATION
             ========================================================= */

            const treatmentElement =
                    document.getElementById(
                            "treatmentAmount"
                            );

            const consultationElement =
                    document.getElementById(
                            "consultationAmount"
                            );

            const discountInput =
                    document.getElementById(
                            "discount"
                            );

            const discountAmountElement =
                    document.getElementById(
                            "discountAmount"
                            );

            const totalElement =
                    document.getElementById(
                            "totalAmount"
                            );


            function getNumber(value) {

                const number =
                        parseFloat(value);

                if (isNaN(number)) {

                    return 0;
                }

                return number;
            }


            function formatAmount(value) {

                return value.toFixed(2);
            }


            function calculateTotal() {

                if (!treatmentElement
                        || !consultationElement
                        || !discountInput
                        || !discountAmountElement
                        || !totalElement) {

                    return;
                }


                const treatment =
                        getNumber(
                                treatmentElement.textContent
                                );


                const consultation =
                        getNumber(
                                consultationElement.textContent
                                );


                let discount =
                        getNumber(
                                discountInput.value
                                );


                const subtotal =
                        treatment + consultation;


                /* Prevent negative discount */
                if (discount < 0) {

                    discount = 0;

                    discountInput.value = "0";
                }


                /* Prevent discount above subtotal */
                if (discount > subtotal) {

                    discount = subtotal;

                    discountInput.value =
                            subtotal.toFixed(2);
                }


                const total =
                        subtotal - discount;


                discountAmountElement.textContent =
                        formatAmount(discount);


                totalElement.textContent =
                        formatAmount(total);
            }


            if (discountInput) {

                discountInput.addEventListener(
                        "input",
                        calculateTotal
                        );

                discountInput.addEventListener(
                        "change",
                        calculateTotal
                        );
            }


            calculateTotal();



            /* =========================================================
             PAYMENT FORM VALIDATION
             ========================================================= */

            const paymentForm =
                    document.getElementById(
                            "paymentForm"
                            );


            if (paymentForm) {

                paymentForm.addEventListener(
                        "submit",
                        function (event) {


                            const paymentMethod =
                                    document.querySelector(
                                            'input[name="paymentMethod"]:checked'
                                            );


                            const discount =
                                    getNumber(
                                            discountInput.value
                                            );


                            const treatment =
                                    getNumber(
                                            treatmentElement.textContent
                                            );


                            const consultation =
                                    getNumber(
                                            consultationElement.textContent
                                            );


                            const subtotal =
                                    treatment + consultation;


                            const total =
                                    subtotal - discount;



                            /* =========================
                             PAYMENT METHOD
                             ========================= */

                            if (!paymentMethod) {

                                event.preventDefault();

                                alert(
                                        "Please select a payment method."
                                        );

                                return;
                            }



                            /* =========================
                             DISCOUNT VALIDATION
                             ========================= */

                            if (discount < 0) {

                                event.preventDefault();

                                alert(
                                        "Discount cannot be negative."
                                        );

                                return;
                            }


                            if (discount > subtotal) {

                                event.preventDefault();

                                alert(
                                        "Discount cannot exceed the bill amount."
                                        );

                                return;
                            }



                            /* =========================
                             TOTAL VALIDATION
                             ========================= */

                            if (total <= 0) {

                                event.preventDefault();

                                alert(
                                        "The total payable amount must be greater than zero."
                                        );

                                return;
                            }



                            /* =========================
                             FINAL CONFIRMATION
                             ========================= */

                            const selectedMethod =
                                    paymentMethod.value
                                    .replace(
                                            "_",
                                            " "
                                            );


                            const confirmation =
                                    confirm(
                                            "Confirm payment?\n\n"
                                            + "Payment Method: "
                                            + selectedMethod
                                            + "\n"
                                            + "Total Amount: LKR "
                                            + total.toFixed(2)
                                            + "\n\n"
                                            + "Click OK to complete the payment."
                                            );


                            if (!confirmation) {

                                event.preventDefault();

                                return;
                            }



                            /* =========================
                             DISABLE BUTTON
                             ========================= */

                            const button =
                                    document.getElementById(
                                            "payButton"
                                            );


                            if (button) {

                                button.disabled =
                                        true;

                                button.innerHTML =
                                        '<i class="fa-solid fa-spinner fa-spin"></i>'
                                        + ' Processing Payment...';
                            }

                        }
                );
            }

        </script>


    </body>

</html>