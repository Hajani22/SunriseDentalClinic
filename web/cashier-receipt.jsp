<%@page import="model.Bill"%>

<%
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

    Bill bill
            = (Bill) request.getAttribute("bill");

    if (bill == null) {
        response.sendRedirect(
                "CashierBillingServlet?error=receipt"
        );
        return;
    }
%>

<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Receipt <%= bill.getBillNo()%>
        </title>

        <style>

            body {
                margin: 0;
                background: #eef2f6;
                font-family: Arial, sans-serif;
                color: #1e293b;
            }

            .receipt {
                width: 760px;
                margin: 40px auto;
                background: white;
                padding: 40px;
                box-shadow: 0 10px 35px rgba(0,0,0,.08);
            }

            .header {
                display: flex;
                justify-content: space-between;
                border-bottom: 2px solid #06a3da;
                padding-bottom: 20px;
            }

            .clinic h1 {
                margin: 0;
                color: #091e3e;
            }

            .clinic p {
                color: #64748b;
            }

            .receipt-title {
                text-align: right;
            }

            .receipt-title h2 {
                color: #06a3da;
            }

            .details {
                display: grid;
                grid-template-columns: 1fr 1fr;
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
                border-collapse: collapse;
            }

            th {
                background: #091e3e;
                color: white;
                padding: 12px;
                text-align: left;
            }

            td {
                padding: 13px;
                border-bottom: 1px solid #e2e8f0;
            }

            .right {
                text-align: right;
            }

            .total {
                font-size: 20px;
                font-weight: bold;
                color: #091e3e;
            }

            .paid {
                margin-top: 20px;
                padding: 12px;
                background: #e8f8ef;
                color: #16834b;
                font-weight: bold;
                text-align: center;
            }

            .footer {
                margin-top: 35px;
                text-align: center;
                color: #64748b;
                font-size: 12px;
            }

            .print {
                display: block;
                margin: 25px auto;
                padding: 12px 25px;
                background: #06a3da;
                color: white;
                border: 0;
                border-radius: 7px;
                cursor: pointer;
            }

            @media print {

                body {
                    background: white;
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


                <div class="receipt-title">

                    <h2>
                        PAYMENT RECEIPT
                    </h2>

                    <strong>
                        <%= bill.getBillNo()%>
                    </strong>

                </div>

            </div>


            <div class="details">


                <div class="detail">

                    <small>
                        Appointment Number
                    </small>

                    <strong>
                        <%= bill.getAppointmentNo()%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Payment Date
                    </small>

                    <strong>
                        <%= bill.getCreatedAt()%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Patient
                    </small>

                    <strong>
                        <%= bill.getPatientName()%>
                    </strong>

                </div>


                <div class="detail">

                    <small>
                        Doctor
                    </small>

                    <strong>
                        Dr. <%= bill.getDoctorName()%>
                    </strong>

                </div>


            </div>


            <table>

                <thead>

                    <tr>

                        <th>
                            Description
                        </th>

                        <th class="right">
                            Amount (Rs.)
                        </th>

                    </tr>

                </thead>


                <tbody>

                    <tr>

                        <td>
                            <%= bill.getTreatmentType()%>
                        </td>

                        <td class="right">
                            <%= bill.getTreatmentAmount()%>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            Consultation Fee
                        </td>

                        <td class="right">
                            <%= bill.getConsultationFee()%>
                        </td>

                    </tr>


                    <tr>

                        <td>
                            Discount
                        </td>

                        <td class="right">
                            <%= bill.getDiscount()%>
                        </td>

                    </tr>


                    <tr class="total">

                        <td>
                            TOTAL
                        </td>

                        <td class="right">
                            <%= bill.getTotalAmount()%>
                        </td>

                    </tr>

                </tbody>

            </table>


            <div class="paid">

                PAYMENT RECEIVED ?
                <%= bill.getPaymentMethod()%>

            </div>


            <div class="footer">

                Thank you for choosing Sunrise Dental Clinic.

                <br><br>

                This is a computer-generated receipt.

            </div>


            <button
                class="print"
                onclick="window.print()">

                Print Receipt

            </button>


        </div>

    </body>

</html>