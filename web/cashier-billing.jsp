<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Bill"%>

<%
    if (session == null
            || session.getAttribute("user") == null
            || !"cashier".equalsIgnoreCase(
                    String.valueOf(
                            session.getAttribute(
                                    "userRole"
                            )
                    )
            )) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }

    Bill bill
            = (Bill) request.getAttribute("bill");

    List<Bill> recentBills
            = (List<Bill>) request.getAttribute(
                    "recentBills"
            );

    String error
            = (String) request.getAttribute(
                    "error"
            );

    boolean alreadyPaid
            = Boolean.TRUE.equals(
                    request.getAttribute(
                            "alreadyPaid"
                    )
            );

    BigDecimal treatment
            = bill != null
            && bill.getTreatmentAmount() != null
            ? bill.getTreatmentAmount()
            : BigDecimal.ZERO;

    BigDecimal consultation
            = bill != null
            && bill.getConsultationFee() != null
            ? bill.getConsultationFee()
            : BigDecimal.ZERO;

    BigDecimal discount
            = bill != null
            && bill.getDiscount() != null
            ? bill.getDiscount()
            : BigDecimal.ZERO;

    BigDecimal paid
            = bill != null
            && bill.getPaidAmount() != null
            ? bill.getPaidAmount()
            : BigDecimal.ZERO;

    BigDecimal total
            = bill != null
            && bill.getTotalAmount() != null
            ? bill.getTotalAmount()
            : BigDecimal.ZERO;

    BigDecimal gross
            = treatment.add(
                    consultation
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
            Cashier Billing | Sunrise Dental Clinic
        </title>

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600;700&display=swap"
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

                color: #475569;

                font-family:
                    "Open Sans",
                    Arial,
                    sans-serif;
            }

            .page {

                max-width: 1100px;

                margin: auto;

                padding: 40px 20px;
            }

            .card {

                background: #ffffff;

                border: 1px solid #e2e8f0;

                border-radius: 18px;

                padding: 25px;

                margin-bottom: 22px;

                box-shadow:
                    0 8px 25px
                    rgba(16,47,67,.06);
            }

            h1,
            h2 {

                font-family: Jost, sans-serif;

                color: #102f43;
            }

            .header {

                margin-bottom: 25px;
            }

            .header h1 {

                margin: 0;

                font-size: 34px;
            }

            .header p {

                color: #82939e;
            }

            .search {

                display: flex;

                gap: 12px;
            }

            .search input {

                flex: 1;

                padding: 14px;

                border: 1px solid #d8e3e8;

                border-radius: 10px;

                font-size: 15px;
            }

            .btn {

                border: 0;

                border-radius: 10px;

                padding: 13px 18px;

                background: #087fa8;

                color: #ffffff;

                font-weight: 700;

                cursor: pointer;

                text-decoration: none;

                display: inline-flex;

                gap: 8px;

                align-items: center;
            }

            .btn:hover {

                opacity: .9;
            }

            .btn.secondary {

                background: #64748b;
            }

            .alert {

                padding: 14px;

                border-radius: 10px;

                background: #fff1f2;

                color: #be123c;

                margin-bottom: 20px;
            }

            .grid {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 12px;
            }

            .info {

                background: #f7fafc;

                border-radius: 10px;

                padding: 14px;
            }

            .info small {

                display: block;

                color: #82939e;

                margin-bottom: 5px;
            }

            .info strong {

                color: #102f43;
            }

            .table {

                width: 100%;

                border-collapse: collapse;

                margin-top: 20px;
            }

            .table th,
            .table td {

                padding: 14px;

                border-bottom:
                    1px solid #e2e8f0;

                text-align: left;
            }

            .table th {

                background: #f8fafc;
            }

            .right {

                text-align: right !important;
            }

            .status {

                margin-top: 25px;

                padding: 22px;

                border-radius: 14px;

                background: #ecfdf5;

                color: #047857;

                border:
                    1px solid #a7f3d0;
            }

            .status h2 {

                margin-top: 0;

                color: #047857;
            }

            .status .big {

                font-size: 20px;

                font-weight: 700;

                margin-top: 10px;
            }

            .discount-options {

                display: flex;

                gap: 10px;

                flex-wrap: wrap;

                margin: 15px 0;
            }

            .discount-options label {

                border:
                    1px solid #d8e3e8;

                padding: 12px 18px;

                border-radius: 10px;

                cursor: pointer;

                background: #ffffff;
            }

            .discount-options label:hover {

                background: #f1f8fa;
            }

            .discount-options input {

                margin-right: 7px;
            }

            .actions {

                display: flex;

                gap: 12px;

                margin-top: 22px;

                flex-wrap: wrap;
            }

            .paid-badge {

                display: inline-block;

                padding: 5px 9px;

                border-radius: 20px;

                background: #dcfce7;

                color: #15803d;

                font-size: 12px;

                font-weight: 700;
            }

            .print {

                color: #087fa8;

                font-weight: 700;

                text-decoration: none;
            }

            .recent {

                overflow-x: auto;
            }

            .empty {

                text-align: center;

                padding: 35px;

                color: #82939e;
            }

            @media(max-width:800px) {

                .grid {

                    grid-template-columns:
                        repeat(2,1fr);
                }
            }

            @media(max-width:550px) {

                .grid {

                    grid-template-columns:
                        1fr;
                }

                .search {

                    flex-direction: column;
                }
            }

        </style>

    </head>

    <body>

        <div class="page">

            <div class="header">

                <h1>
                    Billing & Payments
                </h1>

                <p>
                    Search an appointment number to check payment and billing status.
                </p>

            </div>


            <%
                if (error != null
                        && !error.trim().isEmpty()) {
            %>

            <div class="alert">

                <i class="fa-solid fa-circle-exclamation"></i>

                <%=error%>

            </div>

            <%
                }
            %>


            <!-- SEARCH -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-magnifying-glass"></i>

                    Find Appointment

                </h2>

                <form
                    class="search"
                    method="get"
                    action="<%=request.getContextPath()%>/CashierBillingServlet">

                    <input

                        type="text"

                        name="appointmentNo"

                        placeholder="Enter Appointment Number e.g. SDC-0E82E0FE"

                        value="<%=request.getParameter("appointmentNo") != null
                                ? request.getParameter("appointmentNo")
                                : ""%>"

                        required>

                    <button
                        class="btn"
                        type="submit">

                        <i class="fa-solid fa-search"></i>

                        Search

                    </button>

                </form>

            </div>


            <%
                if (bill != null) {
            %>


            <div class="card">

                <h2>

                    <i class="fa-solid fa-file-invoice"></i>

                    Appointment Details

                </h2>


                <div class="grid">

                    <div class="info">

                        <small>
                            Appointment Number
                        </small>

                        <strong>
                            <%=bill.getAppointmentNo()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Patient
                        </small>

                        <strong>
                            <%=bill.getPatientName()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Doctor
                        </small>

                        <strong>
                            Dr. <%=bill.getDoctorName()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Treatment
                        </small>

                        <strong>
                            <%=bill.getTreatmentType()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Date
                        </small>

                        <strong>
                            <%=bill.getAppointmentDate()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Time
                        </small>

                        <strong>
                            <%=bill.getAppointmentTime()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Phone
                        </small>

                        <strong>
                            <%=bill.getPatientPhone()%>
                        </strong>

                    </div>


                    <div class="info">

                        <small>
                            Payment Status
                        </small>

                        <strong>

                            <%=alreadyPaid
                                    ? "PAYMENT RECEIVED"
                                    : "PAYMENT DUE"%>

                        </strong>

                    </div>

                </div>


                <!-- BILL TABLE -->

                <table class="table">

                    <tr>

                        <th>
                            Description
                        </th>

                        <th class="right">
                            Amount (LKR)
                        </th>

                    </tr>


                    <tr>

                        <td>
                            <%=bill.getTreatmentType()%>
                        </td>

                        <td class="right">
                            <%=treatment%>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            Consultation Fee
                        </td>

                        <td class="right">
                            <%=consultation%>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            Discount
                        </td>

                        <td class="right">

                            -
                            <%=discount%>

                        </td>

                    </tr>


                    <tr>

                        <td>
                            Already Paid
                        </td>

                        <td class="right">

                            <%=paid%>

                        </td>

                    </tr>


                    <tr>

                        <th>
                            <%=alreadyPaid
                                    ? "TOTAL BILL"
                                    : "BALANCE / PAYABLE"%>
                        </th>

                        <th class="right">

                            LKR
                            <span id="payableAmount">

                                <%=total%>

                            </span>

                        </th>

                    </tr>

                </table>


                <%
                    if (alreadyPaid) {
                %>


                <!-- ======================================================
                     ALREADY PAID
                     ====================================================== -->

                <div class="status">

                    <h2>

                        <i class="fa-solid fa-circle-check"></i>

                        PAYMENT ALREADY RECEIVED

                    </h2>

                    <p>

                        This appointment has already been fully paid.

                    </p>

                    <p>

                        <b>
                            Cashier must NOT collect payment again.
                        </b>

                    </p>

                    <div class="big">

                        Paid Amount:

                        LKR <%=paid%>

                    </div>

                    <p>

                        Payment Method:

                        <b>
                            <%=bill.getPaymentMethod()%>
                        </b>

                    </p>

                </div>


                <div class="actions">

                    <a

                        class="btn"

                        target="_blank"

                        href="<%=request.getContextPath()%>/CashierReceiptServlet?appointmentNo=<%=bill.getAppointmentNo()%>">

                        <i class="fa-solid fa-print"></i>

                        Print Bill / Receipt

                    </a>

                </div>


                <%
                } else {
                %>


                <!-- ======================================================
                     PAYMENT DUE
                     ====================================================== -->

                <form

                    method="post"

                    action="<%=request.getContextPath()%>/CashierPaymentServlet"

                    id="paymentForm">


                    <input

                        type="hidden"

                        name="appointmentNo"

                        value="<%=bill.getAppointmentNo()%>">


                    <h2>

                        <i class="fa-solid fa-tag"></i>

                        Discount

                    </h2>


                    <div class="discount-options">

                        <label>

                            <input

                                type="radio"

                                name="discountPercent"

                                value="0"

                                checked>

                            0%

                        </label>


                        <label>

                            <input

                                type="radio"

                                name="discountPercent"

                                value="5">

                            5%

                        </label>


                        <label>

                            <input

                                type="radio"

                                name="discountPercent"

                                value="10">

                            10%

                        </label>


                        <label>

                            <input

                                type="radio"

                                name="discountPercent"

                                value="15">

                            15%

                        </label>

                    </div>


                    <h2>

                        <i class="fa-solid fa-credit-card"></i>

                        Payment Method

                    </h2>


                    <div class="discount-options">

                        <label>

                            <input

                                type="radio"

                                name="paymentMethod"

                                value="CASH"

                                required>

                            Cash

                        </label>


                        <label>

                            <input

                                type="radio"

                                name="paymentMethod"

                                value="CARD"

                                required>

                            Card

                        </label>


                        <label>

                            <input

                                type="radio"

                                name="paymentMethod"

                                value="BANK_TRANSFER"

                                required>

                            Bank Transfer

                        </label>

                    </div>


                    <div class="actions">

                        <button

                            class="btn"

                            type="submit">

                            <i class="fa-solid fa-check"></i>

                            Confirm Payment & Generate Receipt

                        </button>


                        <a

                            class="btn secondary"

                            href="<%=request.getContextPath()%>/CashierBillingServlet">

                            Clear

                        </a>

                    </div>

                </form>


                <%
                    }
                %>

            </div>


            <%
                }
            %>


            <!-- RECENT BILLS -->

            <div class="card recent">

                <h2>

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    Recent Bills

                </h2>


                <%
                    if (recentBills != null
                            && !recentBills.isEmpty()) {
                %>


                <table class="table">

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
                            Total
                        </th>

                        <th>
                            Status
                        </th>

                        <th>
                            Receipt
                        </th>

                    </tr>


                    <%
                        for (Bill b : recentBills) {
                    %>


                    <tr>

                        <td>
                            <%=b.getBillNo()%>
                        </td>

                        <td>
                            <%=b.getAppointmentNo()%>
                        </td>

                        <td>
                            <%=b.getPatientName()%>
                        </td>

                        <td>
                            LKR <%=b.getTotalAmount()%>
                        </td>

                        <td>

                            <span class="paid-badge">

                                <%=b.getPaymentStatus()%>

                            </span>

                        </td>

                        <td>

                            <a

                                class="print"

                                target="_blank"

                                href="<%=request.getContextPath()%>/CashierReceiptServlet?id=<%=b.getId()%>">

                                <i class="fa-solid fa-print"></i>

                                Print

                            </a>

                        </td>

                    </tr>


                    <%
                        }
                    %>

                </table>


                <%
                } else {
                %>

                <div class="empty">

                    No recent bills.

                </div>

                <%
                    }
                %>

            </div>


        </div>


        <script>

            /*
             * =========================================================
             * DISCOUNT PREVIEW
             * =========================================================
             */

            const gross =
            <%=gross%>;

            const alreadyPaid =
            <%=paid%>;

            const payableElement =
                    document.getElementById(
                            "payableAmount"
                            );


            document
                    .querySelectorAll(
                            'input[name="discountPercent"]'
                            )
                    .forEach(
                            function (radio) {

                                radio.addEventListener(
                                        "change",
                                        function () {

                                            const selected =
                                                    document.querySelector(
                                                            'input[name="discountPercent"]:checked'
                                                            );

                                            const percent =
                                                    parseFloat(
                                                            selected
                                                            ? selected.value
                                                            : "0"
                                                            );

                                            const discount =
                                                    Math.round(
                                                            gross
                                                            * percent
                                                            ) / 100;

                                            const balance =
                                                    Math.max(
                                                            0,
                                                            gross
                                                            - discount
                                                            - alreadyPaid
                                                            );

                                            if (payableElement) {

                                                payableElement.textContent =
                                                        balance.toFixed(2);
                                            }
                                        }
                                );
                            }
                    );


            /*
             * =========================================================
             * CONFIRM PAYMENT
             * =========================================================
             */

            const paymentForm =
                    document.getElementById(
                            "paymentForm"
                            );


            if (paymentForm) {

                paymentForm.addEventListener(
                        "submit",
                        function (event) {

                            const confirmed =
                                    confirm(
                                            "Confirm this payment?\n\n"
                                            + "After saving, this appointment "
                                            + "cannot be charged again."
                                            );

                            if (!confirmed) {

                                event.preventDefault();
                            }
                        }
                );
            }

        </script>

    </body>

</html>