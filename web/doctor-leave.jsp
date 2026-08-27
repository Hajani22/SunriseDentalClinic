<%@page import="java.util.List"%>
<%@page import="model.DoctorLeave"%>
<%@page import="model.DoctorOption"%>

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

    List<DoctorOption> doctors
            = (List<DoctorOption>) request.getAttribute("doctors");

    List<DoctorLeave> leaves
            = (List<DoctorLeave>) request.getAttribute("leaves");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Doctor Leave Management | Sunrise Dental Clinic</title>

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
                max-width: 1200px;
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
                opacity: 0.9;
            }

            .card {
                background: white;
                padding: 25px;
                border-radius: 14px;
                margin-bottom: 25px;
                border: 1px solid #e5eaf0;
                box-shadow: 0 3px 12px rgba(0,0,0,0.04);
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

            .form-group.full {
                grid-column: 1 / -1;
            }

            label {
                font-size: 13px;
                font-weight: 700;
                margin-bottom: 7px;
                color: #334155;
            }

            input,
            select {
                width: 100%;
                padding: 12px;
                border: 1px solid #d7e0e8;
                border-radius: 8px;
                font-size: 14px;
                background: white;
            }

            input:focus,
            select:focus {
                outline: none;
                border-color: #06a3da;
            }

            .btn {
                border: none;
                padding: 12px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 700;
                color: white;
            }

            .btn-primary {
                background: #06a3da;
            }

            .btn-primary:hover {
                background: #087eac;
            }

            .btn-danger {
                background: #dc3545;
                padding: 8px 12px;
                font-size: 12px;
            }

            .btn-danger:hover {
                background: #b02a37;
            }

            .alert {
                padding: 14px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .alert-success {
                background: #dcfce7;
                color: #166534;
            }

            .alert-error {
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
                padding: 14px;
                border-bottom: 1px solid #edf1f5;
                text-align: left;
                font-size: 13px;
            }

            th {
                background: #f8fafc;
                color: #0b2447;
            }

            tr:hover {
                background: #fafcff;
            }

            .badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
            }

            .badge-active {
                background: #dcfce7;
                color: #15803d;
            }

            .badge-cancelled {
                background: #fee2e2;
                color: #b91c1c;
            }

            .empty {
                text-align: center;
                padding: 30px;
                color: #64748b;
            }

            @media(max-width: 800px) {

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-group.full {
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

                    <i class="fa-solid fa-calendar-xmark"></i>

                    Doctor Leave Management

                </h1>

                <p>

                    Manage doctor leave dates and prevent
                    appointments during approved leave.

                </p>

            </div>


            <% if ("added".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Doctor leave has been added successfully.

            </div>

            <% } %>


            <% if ("cancelled".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Doctor leave has been cancelled successfully.

            </div>

            <% } %>


            <% if (error != null) {%>

            <div class="alert alert-error">

                <i class="fa-solid fa-circle-exclamation"></i>

                <%= error%>

            </div>

            <% }%>


            <!-- ADD LEAVE -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-plus-circle"></i>

                    Add Doctor Leave

                </h2>


                <form method="post"
                      action="<%=request.getContextPath()%>/DoctorLeaveServlet">

                    <input type="hidden"
                           name="action"
                           value="add">


                    <div class="form-grid">


                        <div class="form-group">

                            <label>
                                Doctor
                            </label>

                            <select name="doctorId"
                                    required>

                                <option value="">
                                    Select Doctor
                                </option>

                                <%
                                    if (doctors != null) {

                                        for (DoctorOption doctor : doctors) {
                                %>

                                <option value="<%=doctor.getId()%>">

                                    Dr. <%=doctor.getName()%>

                                </option>

                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>


                        <div class="form-group">

                            <label>
                                Leave Date
                            </label>

                            <input type="date"
                                   name="leaveDate"
                                   min="<%=java.time.LocalDate.now()%>"
                                   required>

                        </div>


                        <div class="form-group">

                            <label>
                                Reason
                            </label>

                            <input type="text"
                                   name="reason"
                                   maxlength="500"
                                   placeholder="Annual leave / Medical leave">

                        </div>


                        <div class="form-group full">

                            <button type="submit"
                                    class="btn btn-primary">

                                <i class="fa-solid fa-plus"></i>

                                Add Leave

                            </button>

                        </div>

                    </div>

                </form>

            </div>


            <!-- LEAVE LIST -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-list"></i>

                    Doctor Leave Schedule

                </h2>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>
                                    Doctor
                                </th>

                                <th>
                                    Leave Date
                                </th>

                                <th>
                                    Reason
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Action
                                </th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                if (leaves == null || leaves.isEmpty()) {
                            %>

                            <tr>

                                <td colspan="5"
                                    class="empty">

                                    No doctor leave records found.

                                </td>

                            </tr>

                            <%
                            } else {

                                for (DoctorLeave leave : leaves) {
                            %>

                            <tr>

                                <td>

                                    <strong>
                                        Dr. <%=leave.getDoctorName()%>
                                    </strong>

                                </td>


                                <td>

                                    <%=leave.getLeaveDate()%>

                                </td>


                                <td>

                                    <%
                                        if (leave.getReason() == null
                                                || leave.getReason().trim().isEmpty()) {
                                    %>

                                    No reason provided

                                    <%
                                    } else {
                                    %>

                                    <%=leave.getReason()%>

                                    <%
                                        }
                                    %>

                                </td>


                                <td>

                                    <% if ("ACTIVE".equalsIgnoreCase(
                                    leave.getStatus())) { %>

                                    <span class="badge badge-active">
                                        ACTIVE
                                    </span>

                                    <% } else { %>

                                    <span class="badge badge-cancelled">
                                        CANCELLED
                                    </span>

                                    <% } %>

                                </td>


                                <td>

                                    <% if ("ACTIVE".equalsIgnoreCase(
                                    leave.getStatus())) {%>

                                    <form method="post"
                                          action="<%=request.getContextPath()%>/DoctorLeaveServlet"
                                          onsubmit="return confirm('Are you sure you want to cancel this leave?');">

                                        <input type="hidden"
                                               name="action"
                                               value="cancel">

                                        <input type="hidden"
                                               name="id"
                                               value="<%=leave.getId()%>">

                                        <button type="submit"
                                                class="btn btn-danger">

                                            <i class="fa-solid fa-xmark"></i>

                                            Cancel

                                        </button>

                                    </form>

                                    <% } else { %>

                                    -

                                    <% } %>

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