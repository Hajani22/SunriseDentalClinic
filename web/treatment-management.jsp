<%@page import="java.util.List"%>
<%@page import="model.Treatment"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(
                request.getContextPath() + "/Login.jsp"
        );
        return;
    }

    String role = String.valueOf(
            session.getAttribute("userRole")
    );

    if (!"admin".equalsIgnoreCase(role)) {
        response.sendRedirect(
                request.getContextPath() + "/Login.jsp?error=access"
        );
        return;
    }

    List<Treatment> treatments
            = (List<Treatment>) request.getAttribute("treatments");

    String success
            = request.getParameter("success");

    String error
            = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Treatment Management | Sunrise Dental Clinic
        </title>

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <style>

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                font-family: Arial, sans-serif;
                background: #f5f8fc;
                color: #334155;
            }

            .container {
                max-width: 1250px;
                margin: auto;
                padding: 30px 20px;
            }

            .back {
                display: inline-block;
                margin-bottom: 20px;
                color: #087eac;
                text-decoration: none;
                font-weight: 600;
            }

            .header {
                background: linear-gradient(
                    135deg,
                    #087eac,
                    #06a3da
                    );
                color: white;
                padding: 30px;
                border-radius: 16px;
                margin-bottom: 25px;
            }

            .header h1 {
                margin: 0 0 8px;
            }

            .header p {
                margin: 0;
                opacity: .9;
            }

            .card {
                background: white;
                padding: 25px;
                border-radius: 14px;
                margin-bottom: 25px;
                border: 1px solid #e5eaf0;
                box-shadow: 0 3px 12px rgba(0,0,0,.04);
            }

            .card h2 {
                margin-top: 0;
                color: #0b2447;
            }

            .form-grid {
                display: grid;
                grid-template-columns:
                    repeat(3, 1fr);
                gap: 18px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            label {
                font-size: 13px;
                font-weight: 700;
                margin-bottom: 7px;
            }

            input {
                padding: 12px;
                border: 1px solid #d7e0e8;
                border-radius: 8px;
                font-size: 14px;
            }

            input:focus {
                outline: none;
                border-color: #06a3da;
            }

            .full {
                grid-column: 1 / -1;
            }

            .btn {
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                cursor: pointer;
                color: white;
                font-weight: 700;
            }

            .btn-primary {
                background: #06a3da;
            }

            .btn-primary:hover {
                background: #087eac;
            }

            .btn-edit {
                background: #f59e0b;
                padding: 7px 11px;
                font-size: 12px;
            }

            .btn-activate {
                background: #16a34a;
                padding: 7px 11px;
                font-size: 12px;
            }

            .btn-deactivate {
                background: #dc3545;
                padding: 7px 11px;
                font-size: 12px;
            }

            .alert {
                padding: 14px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .success {
                background: #dcfce7;
                color: #166534;
            }

            .error {
                background: #fee2e2;
                color: #991b1b;
            }

            .table-wrapper {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                padding: 13px;
                border-bottom: 1px solid #edf1f5;
                text-align: left;
                font-size: 13px;
            }

            th {
                background: #f8fafc;
                color: #0b2447;
            }

            .badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
            }

            .active {
                background: #dcfce7;
                color: #15803d;
            }

            .inactive {
                background: #fee2e2;
                color: #b91c1c;
            }

            .actions {
                display: flex;
                gap: 7px;
                flex-wrap: wrap;
            }

            .edit-box {
                display: none;
                background: #f8fafc;
                padding: 20px;
                border-radius: 10px;
                margin-top: 15px;
            }

            .edit-box:target {
                display: block;
            }

            .cancel-link {
                color: #64748b;
                text-decoration: none;
                margin-left: 10px;
                font-size: 13px;
            }

            @media(max-width: 850px) {

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .full {
                    grid-column: auto;
                }
            }

        </style>

    </head>

    <body>

        <div class="container">


            <a class="back"
               href="<%=request.getContextPath()%>/admin-dashboard.jsp">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Dashboard

            </a>


            <div class="header">

                <h1>

                    <i class="fa-solid fa-tooth"></i>

                    Treatment Management

                </h1>

                <p>

                    Add, edit, activate and deactivate
                    dental treatments and prices.

                </p>

            </div>


            <% if ("added".equals(success)) { %>

            <div class="alert success">

                <i class="fa-solid fa-circle-check"></i>

                Treatment added successfully.

            </div>

            <% } %>


            <% if ("updated".equals(success)) { %>

            <div class="alert success">

                <i class="fa-solid fa-circle-check"></i>

                Treatment updated successfully.

            </div>

            <% } %>


            <% if ("activated".equals(success)) { %>

            <div class="alert success">

                Treatment activated successfully.

            </div>

            <% } %>


            <% if ("deactivated".equals(success)) { %>

            <div class="alert success">

                Treatment deactivated successfully.

            </div>

            <% } %>


            <% if (error != null) {%>

            <div class="alert error">

                <i class="fa-solid fa-circle-exclamation"></i>

                <%=error%>

            </div>

            <% }%>


            <!-- ADD TREATMENT -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-plus-circle"></i>

                    Add New Treatment

                </h2>


                <form method="post"
                      action="<%=request.getContextPath()%>/TreatmentManagementServlet">

                    <input type="hidden"
                           name="action"
                           value="add">


                    <div class="form-grid">


                        <div class="form-group">

                            <label>
                                Treatment Name
                            </label>

                            <input type="text"
                                   name="treatmentName"
                                   maxlength="150"
                                   required
                                   placeholder="Example: Dental Cleaning">

                        </div>


                        <div class="form-group">

                            <label>
                                Treatment Price (Rs.)
                            </label>

                            <input type="number"
                                   name="treatmentPrice"
                                   min="0"
                                   step="0.01"
                                   required
                                   placeholder="5000.00">

                        </div>


                        <div class="form-group">

                            <label>
                                Consultation Fee (Rs.)
                            </label>

                            <input type="number"
                                   name="consultationFee"
                                   min="0"
                                   step="0.01"
                                   value="2000.00"
                                   required>

                        </div>


                        <div class="form-group full">

                            <button type="submit"
                                    class="btn btn-primary">

                                <i class="fa-solid fa-plus"></i>

                                Add Treatment

                            </button>

                        </div>

                    </div>

                </form>

            </div>


            <!-- TREATMENT LIST -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-list"></i>

                    Treatment List

                </h2>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Treatment
                                </th>

                                <th>
                                    Treatment Price
                                </th>

                                <th>
                                    Consultation Fee
                                </th>

                                <th>
                                    Total
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Actions
                                </th>

                            </tr>

                        </thead>


                        <tbody>

                            <%
                                if (treatments == null
                                        || treatments.isEmpty()) {
                            %>

                            <tr>

                                <td colspan="6"
                                    style="text-align:center;padding:30px;">

                                    No treatments found.

                                </td>

                            </tr>

                            <%
                            } else {

                                for (Treatment treatment : treatments) {
                            %>

                            <tr>

                                <td>

                                    <strong>

                                        <%=treatment.getTreatmentName()%>

                                    </strong>

                                </td>


                                <td>

                                    Rs.
                                    <%=treatment.getTreatmentPrice()%>

                                </td>


                                <td>

                                    Rs.
                                    <%=treatment.getConsultationFee()%>

                                </td>


                                <td>

                                    Rs.

                                    <%
                                        java.math.BigDecimal total
                                                = treatment.getTreatmentPrice()
                                                        .add(
                                                                treatment.getConsultationFee()
                                                        );
                                    %>

                                    <%=total%>

                                </td>


                                <td>

                                    <% if (treatment.isActive()) { %>

                                    <span class="badge active">

                                        ACTIVE

                                    </span>

                                    <% } else { %>

                                    <span class="badge inactive">

                                        INACTIVE

                                    </span>

                                    <% }%>

                                </td>


                                <td>

                                    <div class="actions">


                                        <!-- EDIT -->

                                        <a
                                            href="#edit-<%=treatment.getId()%>"
                                            class="btn btn-edit"
                                            style="text-decoration:none;">

                                            <i class="fa-solid fa-pen"></i>

                                            Edit

                                        </a>


                                        <!-- ACTIVATE / DEACTIVATE -->

                                        <form method="post"
                                              action="<%=request.getContextPath()%>/TreatmentManagementServlet"
                                              style="display:inline;">

                                            <input type="hidden"
                                                   name="action"
                                                   value="toggle">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%=treatment.getId()%>">

                                            <input type="hidden"
                                                   name="active"
                                                   value="<%=!treatment.isActive()%>">


                                            <% if (treatment.isActive()) { %>

                                            <button type="submit"
                                                    class="btn btn-deactivate">

                                                <i class="fa-solid fa-ban"></i>

                                                Deactivate

                                            </button>

                                            <% } else { %>

                                            <button type="submit"
                                                    class="btn btn-activate">

                                                <i class="fa-solid fa-check"></i>

                                                Activate

                                            </button>

                                            <% }%>

                                        </form>

                                    </div>


                                    <!-- EDIT FORM -->

                                    <div
                                        id="edit-<%=treatment.getId()%>"
                                        class="edit-box">

                                        <form method="post"
                                              action="<%=request.getContextPath()%>/TreatmentManagementServlet">

                                            <input type="hidden"
                                                   name="action"
                                                   value="update">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%=treatment.getId()%>">


                                            <div class="form-grid">


                                                <div class="form-group">

                                                    <label>
                                                        Treatment Name
                                                    </label>

                                                    <input type="text"
                                                           name="treatmentName"
                                                           value="<%=treatment.getTreatmentName()%>"
                                                           maxlength="150"
                                                           required>

                                                </div>


                                                <div class="form-group">

                                                    <label>
                                                        Treatment Price
                                                    </label>

                                                    <input type="number"
                                                           name="treatmentPrice"
                                                           value="<%=treatment.getTreatmentPrice()%>"
                                                           min="0"
                                                           step="0.01"
                                                           required>

                                                </div>


                                                <div class="form-group">

                                                    <label>
                                                        Consultation Fee
                                                    </label>

                                                    <input type="number"
                                                           name="consultationFee"
                                                           value="<%=treatment.getConsultationFee()%>"
                                                           min="0"
                                                           step="0.01"
                                                           required>

                                                </div>


                                                <div class="form-group full">

                                                    <button type="submit"
                                                            class="btn btn-primary">

                                                        <i class="fa-solid fa-save"></i>

                                                        Save Changes

                                                    </button>


                                                    <a
                                                        href="<%=request.getContextPath()%>/TreatmentManagementServlet"
                                                        class="cancel-link">

                                                        Cancel

                                                    </a>

                                                </div>

                                            </div>

                                        </form>

                                    </div>

                                </td>

                            </tr>

                            <%
                                    }
                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </body>
</html>