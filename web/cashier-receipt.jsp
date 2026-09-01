<%@page import="model.Bill"%>
<%@page import="java.math.BigDecimal"%>

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
            = (Bill) request.getAttribute(
                    "bill"
            );

    if (bill == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/CashierBillingServlet?error=receipt"
        );

        return;
    }

    BigDecimal treatment
            = bill.getTreatmentAmount() == null
            ? BigDecimal.ZERO
            : bill.getTreatmentAmount();

    BigDecimal consultation
            = bill.getConsultationFee() == null
            ? BigDecimal.ZERO
            : bill.getConsultationFee();

    BigDecimal discount
            = bill.getDiscount() == null
            ? BigDecimal.ZERO
            : bill.getDiscount();

    BigDecimal paid
            = bill.getPaidAmount() == null
            ? BigDecimal.ZERO
            : bill.getPaidAmount();

    BigDecimal total
            = bill.getTotalAmount() == null
            ? BigDecimal.ZERO
            : bill.getTotalAmount();

    BigDecimal gross
            = treatment.add(
                    consultation
            );
%>

<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Receipt - <%=bill.getBillNo()%>
        </title>

        <style>

            body {

                margin: 0;

                background: #eef2f6;

                font-family:
                    Arial,
                    sans-serif;

                color: #1e293b;
            }

            .receipt {

                width: 760px;

                margin: 35px auto;

                background: #ffffff;

                padding: 40px;

                box-shadow:
                    0 10px 35px
                    rgba(0,0,0,.08);
            }

            .header {

                display: flex;

                justify-content:
                    space-between;

                border-bottom:
                    2px solid #087fa8;

                padding-bottom: 20px;
            }

            .clinic h1 {

                margin: 0;

                color: #091e3e;
            }

            .clinic p {

                color: #64748b;
            }

            .title {

                text-align: right;
            }

            .title h2 {

                color: #087fa8;

                margin-bottom: 8px;
            }

            .details {

                display: grid;

                grid-template-columns:
                    1fr 1fr;

                gap: 10px;

                margin: 25px 0;
            }

            .detail {

                background: #f8fafc;

                padding: 12px;
            }

            .detail small {

                display: block;

                color: #64748b;

                margin-bottom: 4px;
            }

            table {

                width: 100%;

                border-collapse:
                    collapse;
            }

            th {

                background: #091e3e;

                color: #ffffff;

                padding: 12px;

                text-align: left;
            }

            td {

                padding: 13px;

                border-bottom:
                    1px solid #e2e8f0;
            }

            .right {

                text-align: right;
            }

            .total {

                font-size: 20px;

                font-weight: bold;
            }

            .paid {

                margin-top: 20px;

                padding: 18px;

                background: #e8f8ef;

                color: #16834b;

                font-weight: bold;

                text-align: center;

                border-radius: 8px;
            }

            .print {

                display: block;

                margin: 25px auto;

                padding: 12px 25px;

                background: #087fa8;

                color: #ffffff;

                border: 0;

                border-radius: 7px;

                cursor: pointer;

                font-weight: bold;
            }

            .footer {

                text-align: center;

                color: #64748b;

                font-size: 12px;

                margin-top: 30px;
            }

            @media print {

                body {

                    background: #ffffff;
                }

                .receipt {

                    margin: 0;

                    width: auto;

                    box-shadow: none;
                }

                .print {

                    display: none;
                }
            }

        </style>

    </head>

    <body>


        <div class="receipt">


            <div class="header">

                <div class="clinic">

                    <h1>
                        Sunrise Dental Clinic
                    </h1>

                    <p>
                        Professional Dental Care
                    </p>

                </div>


                <div class="title">

                    <h2>
                        PAYMENT RECEIPT
                    </h2>

                    <strong>
                        <%=bill.getBillNo()%>
                    </strong>

                </div>

            </div>


            <div class="details">


                <div class="detail">

                    <small>
                        Appointment Number
                    </small>

                    <strong>
                        <%=bill.getAppointmentNo()%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Payment Date
                    </small>

                    <strong>
                        <%=bill.getCreatedAt() != null
                                ? bill.getCreatedAt()
                                : "Today"%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Patient
                    </small>

                    <strong>
                        <%=bill.getPatientName()%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Doctor
                    </small>

                    <strong>
                        Dr. <%=bill.getDoctorName()%>
                    </strong>

                </div>

            </div>


            <table>

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
                        Gross Amount
                    </td>

                    <td class="right">
                        <%=gross%>
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
                        Already Paid / Prepayment
                    </td>

                    <td class="right">
                        <%=paid%>
                    </td>

                </tr>


                <tr class="total">

                    <td>
                        TOTAL BILL
                    </td>

                    <td class="right">

                        LKR
                        <%=total%>

                    </td>

                </tr>

            </table>


            <div class="paid">

                ? PAYMENT RECEIVED

                <br><br>

                Payment Method:

                <%=bill.getPaymentMethod()%>

                <br>

                Paid Amount:

                LKR
                <%=paid.compareTo(BigDecimal.ZERO) > 0
                        ? paid
                        : total%>

            </div>


            <div class="footer">

                Thank you for choosing
                Sunrise Dental Clinic.

                <br><br>

                This is a computer-generated receipt.

            </div>


            <button
                class="print"
                onclick="window.print()">

                ? Print Receipt

            </button>


        </div>

    </body>

</html>