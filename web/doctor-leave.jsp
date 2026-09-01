<%@page import="java.util.List"%>
<%@page import="model.DoctorLeave"%>

<%@page contentType="text/html"
        pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {

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

    boolean isAdmin
            = "admin".equalsIgnoreCase(role);

    boolean isDoctor
            = "doctor".equalsIgnoreCase(role);

    if (!isAdmin && !isDoctor) {

        response.sendRedirect(
                request.getContextPath()
                + "/Login.jsp?error=access"
        );

        return;
    }

    List<DoctorLeave> leaves
            = (List<DoctorLeave>) request.getAttribute("leaves");

    String success
            = request.getParameter("success");

    String error
            = request.getParameter("error");
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Doctor Leave Management |
            Sunrise Dental Clinic
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
                    repeat(2, 1fr);
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

            input {
                width: 100%;
                padding: 12px;
                border: 1px solid #d7e0e8;
                border-radius: 8px;
                font-size: 14px;
            }

            input:focus {
                outline: none;
                border-color: #06a3da;
            }

            .btn {
                border: none;
                padding: 10px 16px;
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

            .btn-success {
                background: #16a34a;
            }

            .btn-success:hover {
                background: #15803d;
            }

            .btn-danger {
                background: #dc3545;
            }

            .btn-danger:hover {
                background: #b02a37;
            }

            .btn-warning {
                background: #f59e0b;
            }

            .alert {
                padding: 14px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-weight: 600;
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
                padding: 6px 11px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 700;
            }

            .badge-pending {
                background: #fef3c7;
                color: #92400e;
            }

            .badge-approved {
                background: #dcfce7;
                color: #166534;
            }

            .badge-rejected {
                background: #fee2e2;
                color: #991b1b;
            }

            .badge-cancelled {
                background: #e5e7eb;
                color: #374151;
            }

            .action-group {
                display: flex;
                gap: 7px;
                flex-wrap: wrap;
            }

            .empty {
                text-align: center;
                padding: 35px;
                color: #64748b;
            }

            .info-box {
                background: #eff6ff;
                border-left: 4px solid #06a3da;
                padding: 14px;
                border-radius: 8px;
                margin-bottom: 20px;
                color: #1e3a8a;
            }

            @media(max-width: 800px) {

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-group.full {
                    grid-column: auto;
                }

                .action-group {
                    flex-direction: column;
                }

                .action-group .btn {
                    width: 100%;
                }
            }

        </style>

    </head>

    <body>

        <div class="container">

            <% if (isAdmin) {%>

            <a class="back"
               href="<%=request.getContextPath()%>/admin-dashboard.jsp">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Admin Dashboard

            </a>

            <% } else {%>

            <a class="back"
               href="<%=request.getContextPath()%>/doctor-dashboard.jsp">

                <i class="fa-solid fa-arrow-left"></i>

                Back to Doctor Dashboard

            </a>

            <% } %>


            <div class="header">

                <h1>

                    <i class="fa-solid fa-calendar-xmark"></i>

                    Doctor Leave Management

                </h1>

                <% if (isAdmin) { %>

                <p>
                    Review and manage doctor leave requests.
                    Approve or reject pending requests.
                </p>

                <% } else { %>

                <p>
                    Submit your leave request and track
                    its approval status.
                </p>

                <% } %>

            </div>


            <!-- SUCCESS -->

            <% if ("requested".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Your leave request has been submitted successfully
                and is waiting for admin approval.

            </div>

            <% } %>


            <% if ("approved".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Leave request approved successfully.

            </div>

            <% } %>


            <% if ("rejected".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Leave request rejected successfully.

            </div>

            <% } %>


            <% if ("cancelled".equals(success)) { %>

            <div class="alert alert-success">

                <i class="fa-solid fa-circle-check"></i>

                Leave has been cancelled successfully.

            </div>

            <% } %>


            <% if (error != null) {%>

            <div class="alert alert-error">

                <i class="fa-solid fa-circle-exclamation"></i>

                <%= error%>

            </div>

            <% } %>


            <!-- =========================================
                 DOCTOR REQUEST FORM
                 ========================================= -->

            <% if (isDoctor) {%>

            <div class="card">

                <h2>

                    <i class="fa-solid fa-paper-plane"></i>

                    Request Leave

                </h2>

                <div class="info-box">

                    <i class="fa-solid fa-info-circle"></i>

                    Your request will be sent to the
                    administrator for approval.

                </div>

                <form method="post"
                      action="<%=request.getContextPath()%>/DoctorLeaveServlet">

                    <input type="hidden"
                           name="action"
                           value="add">

                    <div class="form-grid">

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
                                   placeholder="Annual leave / Medical leave / Personal">

                        </div>


                        <div class="form-group full">

                            <button type="submit"
                                    class="btn btn-primary">

                                <i class="fa-solid fa-paper-plane"></i>

                                Submit Leave Request

                            </button>

                        </div>

                    </div>

                </form>

            </div>

            <% }%>


            <!-- =========================================
                 LEAVE LIST
                 ========================================= -->

            <div class="card">

                <h2>

                    <i class="fa-solid fa-list"></i>

                    <%= isAdmin
                            ? "Doctor Leave Requests"
                            : "My Leave Requests"%>

                </h2>


                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <% if (isAdmin) { %>

                                <th>
                                    Doctor
                                </th>

                                <% } %>

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
                                if (leaves == null
                                        || leaves.isEmpty()) {
                            %>

                            <tr>

                                <td colspan="<%=isAdmin ? 5 : 4%>"
                                    class="empty">

                                    <i class="fa-solid fa-calendar-check"></i>

                                    <br><br>

                                    No leave requests found.

                                </td>

                            </tr>

                            <%
                            } else {

                                for (DoctorLeave leave : leaves) {

                                    String status
                                            = leave.getStatus();
                            %>

                            <tr>

                                <% if (isAdmin) {%>

                                <td>

                                    <strong>

                                        Dr.
                                        <%=leave.getDoctorName()%>

                                    </strong>

                                </td>

                                <% }%>


                                <td>

                                    <%=leave.getLeaveDate()%>

                                </td>


                                <td>

                                    <%
                                        if (leave.getReason() == null
                                                || leave.getReason()
                                                        .trim()
                                                        .isEmpty()) {
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


                                <!-- STATUS -->

                                <td>

                                    <% if ("PENDING".equalsIgnoreCase(status)) { %>

                                    <span class="badge badge-pending">

                                        <i class="fa-solid fa-clock"></i>

                                        PENDING

                                    </span>

                                    <% } else if ("APPROVED".equalsIgnoreCase(status)) { %>

                                    <span class="badge badge-approved">

                                        <i class="fa-solid fa-check"></i>

                                        APPROVED

                                    </span>

                                    <% } else if ("REJECTED".equalsIgnoreCase(status)) { %>

                                    <span class="badge badge-rejected">

                                        <i class="fa-solid fa-xmark"></i>

                                        REJECTED

                                    </span>

                                    <% } else { %>

                                    <span class="badge badge-cancelled">

                                        <i class="fa-solid fa-ban"></i>

                                        CANCELLED

                                    </span>

                                    <% } %>

                                </td>


                                <!-- ACTION -->

                                <td>

                                    <div class="action-group">


                                        <!-- ADMIN ACTIONS -->

                                        <% if (isAdmin
                                            && "PENDING".equalsIgnoreCase(status)) {%>

                                        <form method="post"
                                              action="<%=request.getContextPath()%>/DoctorLeaveServlet">

                                            <input type="hidden"
                                                   name="action"
                                                   value="approve">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%=leave.getId()%>">

                                            <button type="submit"
                                                    class="btn btn-success"
                                                    onclick="return confirm('Approve this doctor leave request?');">

                                                <i class="fa-solid fa-check"></i>

                                                Approve

                                            </button>

                                        </form>


                                        <form method="post"
                                              action="<%=request.getContextPath()%>/DoctorLeaveServlet">

                                            <input type="hidden"
                                                   name="action"
                                                   value="reject">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%=leave.getId()%>">

                                            <button type="submit"
                                                    class="btn btn-danger"
                                                    onclick="return confirm('Reject this doctor leave request?');">

                                                <i class="fa-solid fa-xmark"></i>

                                                Reject

                                            </button>

                                        </form>

                                        <% } %>


                                        <!-- CANCEL PENDING/APPROVED -->

                                        <% if (("PENDING".equalsIgnoreCase(status)
                                            || "APPROVED".equalsIgnoreCase(status))
                                            && (isDoctor || isAdmin)) {%>

                                        <form method="post"
                                              action="<%=request.getContextPath()%>/DoctorLeaveServlet">

                                            <input type="hidden"
                                                   name="action"
                                                   value="cancel">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%=leave.getId()%>">

                                            <button type="submit"
                                                    class="btn btn-warning"
                                                    onclick="return confirm('Are you sure you want to cancel this leave?');">

                                                <i class="fa-solid fa-ban"></i>

                                                Cancel

                                            </button>

                                        </form>

                                        <% } %>


                                        <% if ("REJECTED".equalsIgnoreCase(status)
                                            || "CANCELLED".equalsIgnoreCase(status)) { %>

                                        <span>
                                            -
                                        </span>

                                        <% } %>

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