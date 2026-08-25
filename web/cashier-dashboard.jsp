<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    String role = (String) session.getAttribute("userRole");

    if (!"cashier".equals(role)) {
        response.sendRedirect("Login.jsp?error=access");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    if (userName == null || userName.trim().isEmpty()) {
        userName = "Cashier";
    }
%>

<!DOCTYPE html>

<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Cashier Dashboard | Sunrise Dental Clinic</title>

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">

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
                font-family: "Open Sans", sans-serif;
                background: #f4f8fb;
                color: #555;
            }

            .layout {
                min-height: 100vh;
                display: flex;
            }

            .sidebar {
                width: 250px;
                position: fixed;
                inset: 0 auto 0 0;
                background: #091e3e;
                color: white;
                padding: 25px 18px;
            }

            .brand {
                font: 700 21px Jost, sans-serif;
                margin: 10px 8px 35px;
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
            }

            .main {
                margin-left: 250px;
                width: calc(100% - 250px);
            }

            .topbar {
                height: 72px;
                background: white;
                border-bottom: 1px solid #e5ebf0;
                padding: 0 32px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .topbar h2 {
                font: 700 25px Jost, sans-serif;
                color: #091e3e;
            }

            .user {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .user small {
                display: block;
                color: #7b8794;
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

            .welcome {
                background: linear-gradient(
                    120deg,
                    #06a3da,
                    #0589b8
                    );

                color: white;
                border-radius: 14px;
                padding: 28px;
                margin-bottom: 24px;
            }

            .welcome h1 {
                font: 700 28px Jost, sans-serif;
                margin-bottom: 6px;
            }

            .cards {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 18px;
                margin-bottom: 24px;
            }

            .card {
                background: white;
                border: 1px solid #e5ebf0;
                border-radius: 12px;
                padding: 22px;
            }

            .card i {
                font-size: 24px;
                color: #06a3da;
                margin-bottom: 14px;
            }

            .card h3 {
                font: 700 22px Jost, sans-serif;
                color: #091e3e;
            }

            .card p {
                font-size: 12px;
                margin-top: 4px;
            }

            .panel {
                background: white;
                border: 1px solid #e5ebf0;
                border-radius: 12px;
                padding: 22px;
            }

            .panel h3 {
                font: 700 20px Jost, sans-serif;
                color: #091e3e;
                margin-bottom: 15px;
            }

            .action {
                display: inline-block;
                text-decoration: none;
                background: #06a3da;
                color: white;
                padding: 12px 18px;
                border-radius: 8px;
                margin: 5px 6px 0 0;
            }

            .action.secondary {
                background: #091e3e;
            }

            @media(max-width:800px) {

                .sidebar {
                    width: 70px;
                    padding: 20px 10px;
                }

                .brand span,
                .menu span,
                .logout span {
                    display: none;
                }

                .main {
                    margin-left: 70px;
                    width: calc(100% - 70px);
                }

                .cards {
                    grid-template-columns: 1fr;
                }

                .content {
                    padding: 20px;
                }

            }

        </style>

    </head>

    <body>

        <div class="layout">


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


                    <a href="#">

                        <i class="fa-solid fa-file-invoice-dollar"></i>

                        <span>
                            Billing
                        </span>

                    </a>


                    <a href="#">

                        <i class="fa-solid fa-receipt"></i>

                        <span>
                            Payments
                        </span>

                    </a>


                    <a href="#">

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


            <main class="main">


                <header class="topbar">

                    <h2>
                        Cashier Dashboard
                    </h2>


                    <div class="user">

                        <div class="avatar">

                            <i class="fa-solid fa-cash-register"></i>

                        </div>


                        <div>

                            <strong>
                                <%= userName%>
                            </strong>

                            <small>
                                Cashier
                            </small>

                        </div>

                    </div>

                </header>


                <section class="content">


                    <div class="welcome">

                        <h1>
                            Welcome, <%= userName%>!
                        </h1>

                        <p>
                            Manage billing and payment activities
                            for Sunrise Dental Clinic.
                        </p>

                    </div>


                    <div class="cards">


                        <div class="card">

                            <i class="fa-solid fa-file-invoice-dollar"></i>

                            <h3>
                                Billing
                            </h3>

                            <p>
                                Manage patient billing
                            </p>

                        </div>


                        <div class="card">

                            <i class="fa-solid fa-receipt"></i>

                            <h3>
                                Payments
                            </h3>

                            <p>
                                Manage received payments
                            </p>

                        </div>


                        <div class="card">

                            <i class="fa-solid fa-user-check"></i>

                            <h3>
                                Active
                            </h3>

                            <p>
                                Account Status
                            </p>

                        </div>


                    </div>


                    <div class="panel">

                        <h3>
                            Quick Actions
                        </h3>


                        <a class="action"
                           href="#">

                            <i class="fa-solid fa-file-invoice-dollar"></i>

                            Manage Billing

                        </a>


                        <a class="action"
                           href="#">

                            <i class="fa-solid fa-receipt"></i>

                            Payments

                        </a>


                        <a class="action secondary"
                           href="#">

                            <i class="fa-solid fa-user"></i>

                            View Profile

                        </a>


                        <a class="action"
                           href="Index.jsp">

                            <i class="fa-solid fa-house"></i>

                            Home

                        </a>

                    </div>


                </section>

            </main>

        </div>

    </body>

</html>