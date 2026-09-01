<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="model.Appointment"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    /*
     * =========================================================
     * SESSION CHECK
     * =========================================================
     */
    if (session == null
            || session.getAttribute("user") == null) {

        response.sendRedirect(
                "Login.jsp?error=session"
        );

        return;
    }

    /*
     * =========================================================
     * ROLE CHECK
     * =========================================================
     */
    if (!"patient".equalsIgnoreCase(
            String.valueOf(
                    session.getAttribute(
                            "userRole"
                    )
            ))) {

        response.sendRedirect(
                "Login.jsp?error=access"
        );

        return;
    }

    /*
     * =========================================================
     * DATA FROM SERVLET
     * =========================================================
     */
    List<Appointment> appointments
            = (List<Appointment>) request.getAttribute(
                    "appointments"
            );

    Map<Integer, BigDecimal> consultationPaidMap
            = (Map<Integer, BigDecimal>) request.getAttribute(
                    "consultationPaidMap"
            );

    Map<Integer, BigDecimal> treatmentPaidMap
            = (Map<Integer, BigDecimal>) request.getAttribute(
                    "treatmentPaidMap"
            );

    Map<Integer, BigDecimal> treatmentAmountMap
            = (Map<Integer, BigDecimal>) request.getAttribute(
                    "treatmentAmountMap"
            );

    BigDecimal consultationFee
            = (BigDecimal) request.getAttribute(
                    "consultationFee"
            );

    if (consultationFee == null) {
        consultationFee
                = new BigDecimal("2000.00");
    }

    /*
     * =========================================================
     * COUNT UNPAID APPOINTMENTS
     * =========================================================
     */
    int unpaidCount = 0;

    if (appointments != null) {

        for (Appointment appointment
                : appointments) {

            if (appointment == null) {
                continue;
            }

            if (!"CONFIRMED".equalsIgnoreCase(
                    appointment.getStatus())) {

                continue;
            }

            int appointmentId
                    = appointment.getId();

            BigDecimal consultationPaid
                    = consultationPaidMap != null
                    && consultationPaidMap.get(
                            appointmentId
                    ) != null
                    ? consultationPaidMap.get(
                            appointmentId
                    )
                    : BigDecimal.ZERO;

            BigDecimal treatmentPaid
                    = treatmentPaidMap != null
                    && treatmentPaidMap.get(
                            appointmentId
                    ) != null
                    ? treatmentPaidMap.get(
                            appointmentId
                    )
                    : BigDecimal.ZERO;

            BigDecimal treatmentAmount
                    = treatmentAmountMap != null
                    && treatmentAmountMap.get(
                            appointmentId
                    ) != null
                    ? treatmentAmountMap.get(
                            appointmentId
                    )
                    : BigDecimal.ZERO;

            boolean consultationPaidFully
                    = consultationPaid.compareTo(
                            consultationFee
                    ) >= 0;

            boolean treatmentPaidFully
                    = treatmentAmount.compareTo(
                            BigDecimal.ZERO
                    ) <= 0
                    || treatmentPaid.compareTo(
                            treatmentAmount
                    ) >= 0;

            /*
             * Appointment is unpaid if either
             * consultation OR treatment remains.
             */
            boolean fullyPaid
                    = consultationPaidFully
                    && treatmentPaidFully;

            if (!fullyPaid) {
                unpaidCount++;
            }
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
            Payments | Sunrise Dental Clinic
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
                    sans-serif;
            }

            .page {

                max-width: 1150px;

                margin: auto;

                padding: 45px 25px;
            }

            .header {

                margin-bottom: 30px;
            }

            .header h1 {

                margin: 0;

                font-family: "Jost",
                    sans-serif;

                font-size: 34px;

                color: #102f43;
            }

            .header p {

                margin-top: 8px;

                color: #82939e;
            }

            .payment-card {

                background: #ffffff;

                border: 1px solid #e1ebef;

                border-radius: 18px;

                padding: 25px;

                margin-bottom: 20px;

                box-shadow:
                    0 8px 25px
                    rgba(16,47,67,.06);
            }

            .payment-card h2 {

                margin: 0 0 8px;

                font-family: "Jost",
                    sans-serif;

                color: #102f43;
            }

            .appointment-info {

                display: grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap: 12px;

                margin: 20px 0;
            }

            .info {

                background: #f7fbfc;

                border-radius: 10px;

                padding: 13px;
            }

            .info span {

                display: block;

                font-size: 11px;

                color: #82939e;

                margin-bottom: 5px;
            }

            .info strong {

                color: #102f43;

                font-size: 13px;
            }

            .amount-box {

                margin-top: 20px;

                padding: 18px;

                border-radius: 12px;

                background: #f8fafc;
            }

            .amount-row {

                display: flex;

                justify-content:
                    space-between;

                padding: 7px 0;
            }

            .amount-row.total {

                border-top:
                    1px solid #dce6eb;

                margin-top: 8px;

                padding-top: 14px;

                font-weight: 700;

                color: #102f43;
            }

            .payment-options {

                display: flex;

                gap: 15px;

                flex-wrap: wrap;

                margin-top: 20px;
            }

            .payment-option {

                flex: 1;

                min-width: 220px;

                border:
                    1px solid #dce9ee;

                border-radius: 13px;

                padding: 18px;

                cursor: pointer;

                transition: .2s;
            }

            .payment-option:hover {

                border-color: #087fa8;

                background: #f7fcfd;
            }

            .payment-option input {

                margin-right: 8px;

                accent-color: #087fa8;
            }

            .payment-option i {

                color: #087fa8;

                margin-right: 7px;
            }

            .card-details {

                margin-top: 20px;

                padding: 20px;

                border-radius: 13px;

                background: #f8fafc;

                border:
                    1px solid #e1ebef;
            }

            .card-details h3 {

                margin-top: 0;

                color: #102f43;

                font-family: "Jost",
                    sans-serif;
            }

            .field-grid {

                display: grid;

                grid-template-columns:
                    2fr 1fr 1fr;

                gap: 12px;
            }

            .field label {

                display: block;

                font-size: 12px;

                font-weight: 700;

                color: #526572;

                margin-bottom: 6px;
            }

            .field input {

                width: 100%;

                padding: 12px;

                border:
                    1px solid #d7e4e9;

                border-radius: 9px;

                font-size: 14px;

                outline: none;
            }

            .field input:focus {

                border-color: #087fa8;
            }

            .secure-note {

                margin-top: 12px;

                font-size: 12px;

                color: #82939e;
            }

            .pay-button {

                margin-top: 20px;

                width: 100%;

                border: none;

                border-radius: 11px;

                padding: 14px;

                background: #087fa8;

                color: #ffffff;

                font-weight: 700;

                cursor: pointer;

                font-size: 15px;
            }

            .pay-button:hover {

                background: #056582;
            }

            .completed {

                border:
                    1px solid #a7e8c4;

                background: #effcf4;
            }

            .completed-icon {

                width: 55px;

                height: 55px;

                display: flex;

                align-items: center;

                justify-content: center;

                border-radius: 50%;

                background: #d8f7e5;

                color: #15803d;

                font-size: 25px;

                margin-bottom: 15px;
            }

            .completed h2 {

                color: #15803d;
            }

            .completed p {

                color: #4b6b59;

                line-height: 1.6;
            }

            .paid-label {

                display: inline-block;

                margin-top: 8px;

                padding: 6px 11px;

                border-radius: 20px;

                background: #dcfce7;

                color: #15803d;

                font-size: 12px;

                font-weight: 700;
            }

            .empty {

                text-align: center;

                padding: 60px 20px;

                color: #82939e;
            }

            .empty i {

                font-size: 40px;

                margin-bottom: 15px;

                color: #b8cbd3;
            }

            .history-button {

                display: inline-block;

                margin-top: 12px;

                text-decoration: none;

                color: #087fa8;

                font-weight: 700;
            }

            .error-message {

                margin-bottom: 20px;

                padding: 14px;

                border-radius: 10px;

                background: #fff1f2;

                color: #be123c;
            }

            .success-message {

                margin-bottom: 20px;

                padding: 14px;

                border-radius: 10px;

                background: #ecfdf5;

                color: #047857;
            }

            @media(max-width:700px) {

                .appointment-info {

                    grid-template-columns: 1fr;
                }

                .field-grid {

                    grid-template-columns: 1fr;
                }

            }

        </style>

    </head>

    <body>

        <div class="page">

            <div class="header">

                <h1>
                    Make Payment
                </h1>

                <p>
                    Pay securely for your confirmed appointment.
                </p>

            </div>


            <%
                String paymentStatus
                        = request.getParameter("payment");

                String success
                        = request.getParameter("success");
            %>


            <%
                if ("failed".equalsIgnoreCase(
                        paymentStatus)) {
            %>

            <div class="error-message">

                <i class="fa-solid fa-circle-exclamation"></i>

                Payment could not be completed.
                Please try again.

            </div>

            <%
                }
            %>


            <%
                if ("error".equalsIgnoreCase(
                        paymentStatus)) {
            %>

            <div class="error-message">

                <i class="fa-solid fa-circle-exclamation"></i>

                Something went wrong while processing
                the payment.

            </div>

            <%
                }
            %>


            <%
                if ("payment".equalsIgnoreCase(
                        success)) {
            %>

            <div class="success-message">

                <i class="fa-solid fa-circle-check"></i>

                Payment completed successfully.

            </div>

            <%
                }
            %>


            <%
                boolean displayedUnpaid
                        = false;

                boolean displayedCompleted
                        = false;

                if (appointments != null) {

                    for (Appointment appointment
                            : appointments) {

                        if (appointment == null) {
                            continue;
                        }

                        if (!"CONFIRMED".equalsIgnoreCase(
                                appointment.getStatus())) {

                            continue;
                        }

                        int appointmentId
                                = appointment.getId();

                        BigDecimal consultationPaid
                                = consultationPaidMap != null
                                && consultationPaidMap.get(
                                        appointmentId
                                ) != null
                                ? consultationPaidMap.get(
                                        appointmentId
                                )
                                : BigDecimal.ZERO;

                        BigDecimal treatmentPaid
                                = treatmentPaidMap != null
                                && treatmentPaidMap.get(
                                        appointmentId
                                ) != null
                                ? treatmentPaidMap.get(
                                        appointmentId
                                )
                                : BigDecimal.ZERO;

                        BigDecimal treatmentAmount
                                = treatmentAmountMap != null
                                && treatmentAmountMap.get(
                                        appointmentId
                                ) != null
                                ? treatmentAmountMap.get(
                                        appointmentId
                                )
                                : BigDecimal.ZERO;

                        boolean consultationFullyPaid
                                = consultationPaid.compareTo(
                                        consultationFee
                                ) >= 0;

                        boolean treatmentFullyPaid
                                = treatmentAmount.compareTo(
                                        BigDecimal.ZERO
                                ) <= 0
                                || treatmentPaid.compareTo(
                                        treatmentAmount
                                ) >= 0;

                        boolean fullyPaid
                                = consultationFullyPaid
                                && treatmentFullyPaid;

                        /*
                         * =================================================
                         * FULLY PAID
                         *
                         * Do NOT show Pay Securely.
                         * =================================================
                         */
                        if (fullyPaid) {

                            displayedCompleted = true;
            %>


            <div class="payment-card completed">

                <div class="completed-icon">

                    <i class="fa-solid fa-check"></i>

                </div>

                <h2>

                    <%=appointment.getAppointmentNo()%>

                </h2>

                <span class="paid-label">

                    PAYMENT COMPLETED

                </span>

                <p>

                    This appointment has already been
                    fully paid.

                    <br>

                    You cannot make another payment
                    for this appointment.

                </p>

                <div class="amount-box">

                    <div class="amount-row">

                        <span>
                            Consultation Paid
                        </span>

                        <strong>
                            LKR <%=consultationPaid%>
                        </strong>

                    </div>

                    <div class="amount-row">

                        <span>
                            Treatment Paid
                        </span>

                        <strong>
                            LKR <%=treatmentPaid%>
                        </strong>

                    </div>

                    <div class="amount-row total">

                        <span>
                            Payment Status
                        </span>

                        <strong>
                            PAID
                        </strong>

                    </div>

                </div>

                <a
                    class="history-button"
                    href="patient-payment-history.jsp">

                    <i class="fa-solid fa-clock-rotate-left"></i>

                    View Payment History

                </a>

            </div>


            <%
                    continue;
                }

                /*
                         * =================================================
                         * UNPAID APPOINTMENT
                         *
                         * ONLY THESE APPOINTMENTS GET
                         * THE PAY SECURELY BUTTON.
                         * =================================================
                 */
                displayedUnpaid = true;

                BigDecimal consultationBalance
                        = consultationFee.subtract(
                                consultationPaid
                        );

                if (consultationBalance.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

                    consultationBalance
                            = BigDecimal.ZERO;
                }

                BigDecimal treatmentBalance
                        = treatmentAmount.subtract(
                                treatmentPaid
                        );

                if (treatmentBalance.compareTo(
                        BigDecimal.ZERO
                ) < 0) {

                    treatmentBalance
                            = BigDecimal.ZERO;
                }

                BigDecimal totalBalance
                        = consultationBalance.add(
                                treatmentBalance
                        );
            %>


            <div class="payment-card">

                <h2>

                    <%=appointment.getAppointmentNo()%>

                </h2>


                <div class="appointment-info">

                    <div class="info">

                        <span>
                            Doctor
                        </span>

                        <strong>

                            Dr.
                            <%=appointment.getDoctorName()%>

                        </strong>

                    </div>


                    <div class="info">

                        <span>
                            Treatment
                        </span>

                        <strong>

                            <%=appointment.getTreatmentType()%>

                        </strong>

                    </div>


                    <div class="info">

                        <span>
                            Date
                        </span>

                        <strong>

                            <%=appointment.getAppointmentDate()%>

                        </strong>

                    </div>


                    <div class="info">

                        <span>
                            Time
                        </span>

                        <strong>

                            <%=appointment.getAppointmentTime()%>

                        </strong>

                    </div>

                </div>


                <!-- =====================================================
                     BALANCE
                     ===================================================== -->

                <div class="amount-box">

                    <div class="amount-row">

                        <span>
                            Consultation Fee
                        </span>

                        <strong>
                            LKR <%=consultationFee%>
                        </strong>

                    </div>


                    <div class="amount-row">

                        <span>
                            Consultation Already Paid
                        </span>

                        <strong>
                            LKR <%=consultationPaid%>
                        </strong>

                    </div>


                    <div class="amount-row">

                        <span>
                            Treatment Amount
                        </span>

                        <strong>
                            LKR <%=treatmentAmount%>
                        </strong>

                    </div>


                    <div class="amount-row">

                        <span>
                            Treatment Already Paid
                        </span>

                        <strong>
                            LKR <%=treatmentPaid%>
                        </strong>

                    </div>


                    <div class="amount-row total">

                        <span>
                            Remaining Balance
                        </span>

                        <strong>

                            LKR <%=totalBalance%>

                        </strong>

                    </div>

                </div>


                <!-- =====================================================
                     PAYMENT FORM
                     ===================================================== -->

                <form
                    method="post"
                    action="PatientPaymentServlet"
                    class="payment-form"
                    onsubmit="return validatePayment(this);">


                    <input
                        type="hidden"
                        name="appointmentId"
                        value="<%=appointment.getId()%>">


                    <input
                        type="hidden"
                        name="appointmentNo"
                        value="<%=appointment.getAppointmentNo()%>">


                    <!-- =================================================
                         PAYMENT TYPE
                         ================================================= -->

                    <div class="payment-options">


                        <%
                            if (!consultationFullyPaid) {
                        %>

                        <label class="payment-option">

                            <input
                                type="radio"
                                name="paymentType"
                                value="CONSULTATION"
                                required>

                            <i class="fa-solid fa-user-doctor"></i>

                            Consultation Fee

                            <br>

                            <small>
                                Payable:
                                LKR <%=consultationBalance%>
                            </small>

                        </label>

                        <%
                            }
                        %>


                        <%
                            if (!treatmentFullyPaid
                                    && treatmentAmount.compareTo(
                                            BigDecimal.ZERO
                                    ) > 0) {
                        %>

                        <label class="payment-option">

                            <input
                                type="radio"
                                name="paymentType"
                                value="TREATMENT"
                                required>

                            <i class="fa-solid fa-tooth"></i>

                            Treatment Payment

                            <br>

                            <small>
                                Payable:
                                LKR <%=treatmentBalance%>
                            </small>

                        </label>

                        <%
                            }
                        %>

                    </div>


                    <!-- =================================================
                         PAYMENT METHOD
                         ================================================= -->

                    <div class="payment-options">

                        <label class="payment-option">

                            <input
                                type="radio"
                                name="paymentMethod"
                                value="CARD"
                                checked
                                required>

                            <i class="fa-solid fa-credit-card"></i>

                            Card Payment

                        </label>

                    </div>


                    <!-- =================================================
                         CARD DETAILS
                         ================================================= -->

                    <div class="card-details">

                        <h3>

                            <i class="fa-solid fa-lock"></i>

                            Secure Card Payment

                        </h3>


                        <div class="field-grid">


                            <div class="field">

                                <label>
                                    Card Number
                                </label>

                                <input
                                    type="text"
                                    name="cardNumber"
                                    maxlength="19"
                                    placeholder="1234 5678 9012 3456"
                                    autocomplete="cc-number"
                                    required>

                            </div>


                            <div class="field">

                                <label>
                                    Expiry
                                </label>

                                <input
                                    type="text"
                                    name="expiry"
                                    maxlength="5"
                                    placeholder="MM/YY"
                                    autocomplete="cc-exp"
                                    required>

                            </div>


                            <div class="field">

                                <label>
                                    CVV
                                </label>

                                <input
                                    type="password"
                                    name="cvv"
                                    maxlength="4"
                                    placeholder="123"
                                    autocomplete="cc-csc"
                                    required>

                            </div>

                        </div>


                        <div class="secure-note">

                            <i class="fa-solid fa-shield-halved"></i>

                            Your card details are used only
                            for payment verification and are
                            not stored in the dental clinic
                            database.

                        </div>

                    </div>


                    <button
                        type="submit"
                        class="pay-button">

                        <i class="fa-solid fa-lock"></i>

                        Pay Securely

                    </button>


                </form>

            </div>


            <%
                    }
                }
            %>


            <%
                /*
                 * =====================================================
                 * NO UNPAID PAYMENTS
                 * =====================================================
                 */
                if (!displayedUnpaid
                        && !displayedCompleted) {
            %>


            <div class="payment-card empty">

                <i class="fa-solid fa-credit-card"></i>

                <h2>

                    No Payment Available

                </h2>

                <p>

                    You do not have any confirmed
                    appointment with an outstanding
                    payment.

                </p>

            </div>


            <%
                }
            %>


        </div>


        <jsp:include page="toast.jsp" />


        <script>

            /*
             * =========================================================
             * CARD NUMBER FORMAT
             * =========================================================
             */
            document
                    .querySelectorAll(
                            'input[name="cardNumber"]'
                            )
                    .forEach(function (input) {

                        input.addEventListener(
                                "input",
                                function () {

                                    let value =
                                            this.value
                                            .replace(/\D/g, "")
                                            .substring(0, 16);

                                    value =
                                            value.match(
                                                    /.{1,4}/g
                                                    );

                                    this.value =
                                            value
                                            ? value.join(" ")
                                            : "";
                                }
                        );
                    });


            /*
             * =========================================================
             * EXPIRY FORMAT
             * =========================================================
             */
            document
                    .querySelectorAll(
                            'input[name="expiry"]'
                            )
                    .forEach(function (input) {

                        input.addEventListener(
                                "input",
                                function () {

                                    let value =
                                            this.value
                                            .replace(/\D/g, "")
                                            .substring(0, 4);

                                    if (value.length >= 3) {

                                        value =
                                                value.substring(0, 2)
                                                + "/"
                                                + value.substring(2);
                                    }

                                    this.value = value;
                                }
                        );
                    });


            /*
             * =========================================================
             * PAYMENT VALIDATION
             * =========================================================
             */
            function validatePayment(form) {

                const cardNumber =
                        form.querySelector(
                                'input[name="cardNumber"]'
                                ).value
                        .replace(/\s/g, "");

                const expiry =
                        form.querySelector(
                                'input[name="expiry"]'
                                ).value;

                const cvv =
                        form.querySelector(
                                'input[name="cvv"]'
                                ).value;


                /*
                 * Card number
                 */
                if (!/^\d{16}$/.test(cardNumber)) {

                    alert(
                            "Please enter a valid 16-digit card number."
                            );

                    return false;
                }


                /*
                 * Expiry
                 */
                if (!/^\d{2}\/\d{2}$/.test(expiry)) {

                    alert(
                            "Please enter expiry date in MM/YY format."
                            );

                    return false;
                }


                /*
                 * CVV
                 */
                if (!/^\d{3,4}$/.test(cvv)) {

                    alert(
                            "Please enter a valid CVV."
                            );

                    return false;
                }


                /*
                 * Payment type
                 */
                const paymentType =
                        form.querySelector(
                                'input[name="paymentType"]:checked'
                                );

                if (!paymentType) {

                    alert(
                            "Please select what you want to pay."
                            );

                    return false;
                }


                /*
                 * Final confirmation
                 */
                return confirm(
                        "Confirm this secure payment?\n\n"
                        + "After successful payment, "
                        + "this payment option will no longer "
                        + "be available for this appointment."
                        );
            }

        </script>

    </body>

</html>