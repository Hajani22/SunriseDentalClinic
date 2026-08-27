<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    /*
     * ============================================================
     * SUNRISE DENTAL CLINIC - HELP PAGE
     * ============================================================
     *
     * IMPORTANT:
     * This Help page is PUBLIC.
     *
     * Users DO NOT need to log in to view this page.
     *
     * If a user is already logged in, the Back button will
     * return the user to the appropriate dashboard.
     *
     * If the user is not logged in, the Back button will
     * return the user to Index.jsp.
     * ============================================================
     */

    String role = "guest";
    String backPage = "Index.jsp";
    String backText = "Back to Home";

    /*
     * Check whether a session already exists.
     * We DO NOT create a new session here.
     */
    HttpSession helpSession
            = request.getSession(false);

    /*
     * If the user is already logged in,
     * identify the user's role and dashboard.
     */
    if (helpSession != null
            && helpSession.getAttribute("user") != null) {

        Object roleObject
                = helpSession.getAttribute("userRole");

        if (roleObject != null) {

            role = String.valueOf(roleObject)
                    .toLowerCase()
                    .trim();
        }

        if ("patient".equals(role)) {

            backPage = "patient-dashboard.jsp";
            backText = "Back to Dashboard";

        } else if ("doctor".equals(role)) {

            backPage = "doctor-dashboard.jsp";
            backText = "Back to Dashboard";

        } else if ("cashier".equals(role)) {

            backPage = "cashier-dashboard.jsp";
            backText = "Back to Dashboard";

        } else if ("admin".equals(role)) {

            backPage = "admin-dashboard.jsp";
            backText = "Back to Dashboard";
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
            Help | Sunrise Dental Clinic
        </title>


        <!-- =========================================================
             GOOGLE FONTS
             ========================================================= -->

        <link rel="preconnect"
              href="https://fonts.googleapis.com">

        <link rel="preconnect"
              href="https://fonts.gstatic.com"
              crossorigin>

        <link href=
              "https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
              rel="stylesheet">


        <!-- =========================================================
             FONT AWESOME
             ========================================================= -->

        <link rel="stylesheet"
              href=
              "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /* ========================================================
               GLOBAL
               ======================================================== */

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }


            body {

                font-family:
                    'Open Sans',
                    Arial,
                    sans-serif;

                background:
                    #f4f8fb;

                color:
                    #243447;

                line-height:
                    1.6;
            }


            a {
                text-decoration: none;
            }


            /* ========================================================
               TOP NAVIGATION
               ======================================================== */

            .topbar {

                background:
                    #0b2447;

                color:
                    #ffffff;

                min-height:
                    76px;

                padding:
                    15px 5%;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;

                gap:
                    20px;
            }


            .brand {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    13px;
            }


            .brand-icon {

                width:
                    46px;

                height:
                    46px;

                border-radius:
                    50%;

                background:
                    #06a3da;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    22px;
            }


            .brand-text {

                font-family:
                    'Jost',
                    sans-serif;
            }


            .brand-text strong {

                display:
                    block;

                font-size:
                    21px;

                line-height:
                    1.1;
            }


            .brand-text span {

                display:
                    block;

                font-size:
                    12px;

                color:
                    rgba(255,255,255,.75);

                margin-top:
                    3px;
            }


            .back-link {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    8px;

                color:
                    #ffffff;

                border:
                    1px solid rgba(255,255,255,.45);

                padding:
                    10px 16px;

                border-radius:
                    8px;

                font-size:
                    14px;

                transition:
                    .25s ease;
            }


            .back-link:hover {

                background:
                    #ffffff;

                color:
                    #0b2447;
            }


            /* ========================================================
               MAIN CONTAINER
               ======================================================== */

            .container {

                width:
                    min(1120px, 92%);

                margin:
                    35px auto 55px;
            }


            /* ========================================================
               HERO
               ======================================================== */

            .hero {

                background:
                    #ffffff;

                border-radius:
                    16px;

                padding:
                    34px;

                margin-bottom:
                    24px;

                box-shadow:
                    0 8px 25px rgba(11,36,71,.08);

                border:
                    1px solid #e6edf3;
            }


            .hero-badge {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    8px;

                background:
                    #eaf8fd;

                color:
                    #0589b7;

                padding:
                    7px 13px;

                border-radius:
                    30px;

                font-size:
                    13px;

                font-weight:
                    600;

                margin-bottom:
                    14px;
            }


            .hero h1 {

                font-family:
                    'Jost',
                    sans-serif;

                color:
                    #0b2447;

                font-size:
                    clamp(28px, 4vw, 40px);

                line-height:
                    1.15;

                margin-bottom:
                    10px;
            }


            .hero p {

                color:
                    #64748b;

                max-width:
                    780px;

                font-size:
                    15px;
            }


            .role-display {

                margin-top:
                    18px;

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    8px;

                padding:
                    8px 13px;

                border-radius:
                    7px;

                background:
                    #f1f5f9;

                color:
                    #475569;

                font-size:
                    13px;
            }


            .role-display strong {

                color:
                    #0b2447;

                text-transform:
                    capitalize;
            }


            /* ========================================================
               HELP GRID
               ======================================================== */

            .help-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, minmax(0, 1fr));

                gap:
                    20px;
            }


            /* ========================================================
               HELP CARD
               ======================================================== */

            .help-card {

                background:
                    #ffffff;

                border:
                    1px solid #e4ebf1;

                border-radius:
                    14px;

                padding:
                    25px;

                box-shadow:
                    0 6px 20px rgba(11,36,71,.06);

                transition:
                    transform .25s ease,
                    box-shadow .25s ease;
            }


            .help-card:hover {

                transform:
                    translateY(-3px);

                box-shadow:
                    0 10px 28px rgba(11,36,71,.10);
            }


            .card-heading {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    13px;

                margin-bottom:
                    17px;
            }


            .card-icon {

                width:
                    45px;

                height:
                    45px;

                min-width:
                    45px;

                border-radius:
                    10px;

                background:
                    #eaf8fd;

                color:
                    #06a3da;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    19px;
            }


            .help-card h2 {

                font-family:
                    'Jost',
                    sans-serif;

                font-size:
                    19px;

                color:
                    #0b2447;
            }


            .help-card ol {

                padding-left:
                    22px;
            }


            .help-card ul {

                padding-left:
                    22px;
            }


            .help-card li {

                margin:
                    9px 0;

                color:
                    #526274;

                font-size:
                    14px;
            }


            .help-card li strong {

                color:
                    #243447;
            }


            /* ========================================================
               INFORMATION BOX
               ======================================================== */

            .information-box {

                margin-top:
                    22px;

                background:
                    linear-gradient(
                    135deg,
                    #eef8fc,
                    #f8fcfe
                    );

                border-left:
                    5px solid #06a3da;

                border-radius:
                    10px;

                padding:
                    20px 22px;
            }


            .information-box h3 {

                font-family:
                    'Jost',
                    sans-serif;

                color:
                    #0b2447;

                margin-bottom:
                    7px;

                font-size:
                    18px;
            }


            .information-box p {

                color:
                    #526274;

                font-size:
                    14px;
            }


            /* ========================================================
               QUICK LINKS
               ======================================================== */

            .quick-links {

                margin-top:
                    22px;

                background:
                    #ffffff;

                border:
                    1px solid #e4ebf1;

                border-radius:
                    14px;

                padding:
                    24px;

                box-shadow:
                    0 6px 20px rgba(11,36,71,.05);
            }


            .quick-links h2 {

                font-family:
                    'Jost',
                    sans-serif;

                color:
                    #0b2447;

                margin-bottom:
                    16px;
            }


            .quick-link-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap:
                    12px;
            }


            .quick-link {

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                gap:
                    8px;

                padding:
                    12px;

                border:
                    1px solid #dce6ee;

                border-radius:
                    8px;

                color:
                    #0b2447;

                font-size:
                    13px;

                font-weight:
                    600;

                transition:
                    .25s ease;
            }


            .quick-link i {

                color:
                    #06a3da;
            }


            .quick-link:hover {

                background:
                    #0b2447;

                color:
                    #ffffff;

                border-color:
                    #0b2447;
            }


            /* ========================================================
               FOOTER
               ======================================================== */

            footer {

                background:
                    #0b2447;

                color:
                    rgba(255,255,255,.75);

                text-align:
                    center;

                padding:
                    22px 5%;

                font-size:
                    13px;
            }


            footer strong {

                color:
                    #ffffff;
            }


            /* ========================================================
               RESPONSIVE DESIGN
               ======================================================== */

            @media (max-width: 850px) {

                .help-grid {

                    grid-template-columns:
                        1fr;
                }


                .quick-link-grid {

                    grid-template-columns:
                        repeat(2, 1fr);
                }
            }


            @media (max-width: 600px) {

                .topbar {

                    flex-direction:
                        column;

                    align-items:
                        stretch;
                }


                .back-link {

                    justify-content:
                        center;
                }


                .hero {

                    padding:
                        24px;
                }


                .help-card {

                    padding:
                        20px;
                }


                .quick-link-grid {

                    grid-template-columns:
                        1fr;
                }
            }

        </style>

    </head>


    <body>


        <!-- ============================================================
             HEADER
             ============================================================ -->

        <header class="topbar">

            <div class="brand">

                <div class="brand-icon">

                    <i class="fa-solid fa-tooth"></i>

                </div>


                <div class="brand-text">

                    <strong>
                        Sunrise Dental Clinic
                    </strong>

                    <span>
                        Help &amp; User Guide
                    </span>

                </div>

            </div>


            <a href="<%= backPage%>"
               class="back-link">

                <i class="fa-solid fa-arrow-left"></i>

                <%= backText%>

            </a>

        </header>



        <!-- ============================================================
             MAIN CONTENT
             ============================================================ -->

        <main class="container">


            <!-- ========================================================
                 HERO
                 ======================================================== -->

            <section class="hero">

                <div class="hero-badge">

                    <i class="fa-solid fa-circle-question"></i>

                    Help Centre

                </div>


                <h1>
                    How to Use Sunrise Dental Clinic
                </h1>


                <p>

                    Welcome to the Sunrise Dental Clinic
                    Help Centre. Follow the step-by-step
                    instructions below to understand the
                    main functions of the system.

                    This Help page can be accessed without
                    logging in.

                </p>


                <div class="role-display">

                    <i class="fa-solid fa-user"></i>

                    Current user:

                    <strong>
                        <%= role%>
                    </strong>

                </div>

            </section>



            <!-- ========================================================
                 HELP CARDS
                 ======================================================== -->

            <section class="help-grid">


                <!-- ====================================================
                     1. LOGIN
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-right-to-bracket"></i>

                        </div>

                        <h2>
                            1. Login
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Open the Sunrise Dental Clinic
                            Login page.
                        </li>

                        <li>
                            Enter your registered
                            username/email.
                        </li>

                        <li>
                            Enter your password.
                        </li>

                        <li>
                            Select or use your authorised
                            user role.
                        </li>

                        <li>
                            Click the <strong>Login</strong>
                            button.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     2. PATIENT ACCOUNT
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-user-plus"></i>

                        </div>

                        <h2>
                            2. Create a Patient Account
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Open the <strong>Sign Up</strong>
                            page.
                        </li>

                        <li>
                            Enter the required personal
                            information.
                        </li>

                        <li>
                            Enter valid contact details.
                        </li>

                        <li>
                            Create a secure password.
                        </li>

                        <li>
                            Submit the registration form.
                        </li>

                        <li>
                            After successful registration,
                            use your account to log in.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     3. APPOINTMENT
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-calendar-plus"></i>

                        </div>

                        <h2>
                            3. Book an Appointment
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Log in to your patient account.
                        </li>

                        <li>
                            Open <strong>Book Appointment</strong>.
                        </li>

                        <li>
                            Select the required dentist.
                        </li>

                        <li>
                            Select the required treatment.
                        </li>

                        <li>
                            Select the appointment date.
                        </li>

                        <li>
                            Select the available time.
                        </li>

                        <li>
                            Check all information carefully.
                        </li>

                        <li>
                            Submit the appointment request.
                        </li>

                        <li>
                            The system validates the appointment
                            information and checks the selected
                            dentist's availability.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     4. DOCTOR
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-user-doctor"></i>

                        </div>

                        <h2>
                            4. Doctor Workflow
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Log in using your authorised
                            doctor account.
                        </li>

                        <li>
                            Open the <strong>Appointments</strong>
                            section.
                        </li>

                        <li>
                            Review pending appointment
                            requests.
                        </li>

                        <li>
                            Open the appointment details.
                        </li>

                        <li>
                            Check the patient, treatment,
                            date and time.
                        </li>

                        <li>
                            Approve or reject the appointment.
                        </li>

                        <li>
                            Add a note when required.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     5. ADMIN
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-user-shield"></i>

                        </div>

                        <h2>
                            5. Administrator Workflow
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Log in using the administrator
                            account.
                        </li>

                        <li>
                            Open the appointment management
                            section.
                        </li>

                        <li>
                            Review appointments waiting
                            for confirmation.
                        </li>

                        <li>
                            Check patient and dentist details.
                        </li>

                        <li>
                            Check treatment, date and time.
                        </li>

                        <li>
                            Confirm or reject the appointment.
                        </li>

                        <li>
                            Add a note if required.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     6. CASHIER
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-file-invoice-dollar"></i>

                        </div>

                        <h2>
                            6. Cashier Billing &amp; Payment
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Log in using the authorised
                            cashier account.
                        </li>

                        <li>
                            Open the <strong>Billing</strong>
                            section.
                        </li>

                        <li>
                            Enter or search for the
                            appointment number.
                        </li>

                        <li>
                            Verify the patient information.
                        </li>

                        <li>
                            Verify the treatment information.
                        </li>

                        <li>
                            Enter a valid discount if applicable.
                        </li>

                        <li>
                            Review the calculated total.
                        </li>

                        <li>
                            Select the payment method.
                        </li>

                        <li>
                            Complete the payment.
                        </li>

                        <li>
                            Generate or print the receipt.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     7. NOTIFICATIONS
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-bell"></i>

                        </div>

                        <h2>
                            7. Notifications
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Log in to your authorised account.
                        </li>

                        <li>
                            Open the
                            <strong>Notifications</strong>
                            section.
                        </li>

                        <li>
                            Review appointment and system
                            notifications.
                        </li>

                        <li>
                            Check appointment status changes.
                        </li>

                        <li>
                            Follow the required action
                            shown in the notification.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     8. SEARCH APPOINTMENT
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-magnifying-glass"></i>

                        </div>

                        <h2>
                            8. Find Appointment Details
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Open the relevant appointment
                            management page.
                        </li>

                        <li>
                            Search using the appointment
                            number or available filters.
                        </li>

                        <li>
                            Check the patient details.
                        </li>

                        <li>
                            Check the dentist details.
                        </li>

                        <li>
                            Check treatment, date, time
                            and appointment status.
                        </li>

                        <li>
                            Use the verified information
                            before approving or billing.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     9. LOGOUT
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-right-from-bracket"></i>

                        </div>

                        <h2>
                            9. Logout
                        </h2>

                    </div>


                    <ol>

                        <li>
                            Finish your current work.
                        </li>

                        <li>
                            Save any required information.
                        </li>

                        <li>
                            Click the
                            <strong>Logout</strong>
                            button.
                        </li>

                        <li>
                            Confirm that you have returned
                            to the login page.
                        </li>

                        <li>
                            Do not leave an authenticated
                            session open on a shared computer.
                        </li>

                    </ol>

                </div>



                <!-- ====================================================
                     10. TROUBLESHOOTING
                     ==================================================== -->

                <div class="help-card">

                    <div class="card-heading">

                        <div class="card-icon">

                            <i class="fa-solid fa-triangle-exclamation"></i>

                        </div>

                        <h2>
                            10. Troubleshooting
                        </h2>

                    </div>


                    <ul>

                        <li>
                            <strong>Cannot login:</strong>
                            Check your username/email and
                            password.
                        </li>

                        <li>
                            <strong>Appointment unavailable:</strong>
                            Select another available date or
                            time.
                        </li>

                        <li>
                            <strong>Payment problem:</strong>
                            Do not repeat the payment immediately.
                            Check the bill/payment status first.
                        </li>

                        <li>
                            <strong>Unexpected system error:</strong>
                            Contact the system administrator.
                        </li>

                        <li>
                            <strong>Incorrect information:</strong>
                            Verify the information before
                            submitting or approving.
                        </li>

                    </ul>

                </div>

            </section>



            <!-- ========================================================
                 IMPORTANT INFORMATION
                 ======================================================== -->

            <section class="information-box">

                <h3>

                    <i class="fa-solid fa-circle-info"></i>

                    Important

                </h3>


                <p>

                    Always verify patient, appointment and
                    billing information before confirming an
                    appointment or completing a payment.
                    If an unexpected error occurs, do not
                    repeat a payment operation immediately.
                    Check the current status first and contact
                    the system administrator if necessary.

                </p>

            </section>



            <!-- ========================================================
                 QUICK LINKS
                 ======================================================== -->

            <section class="quick-links">

                <h2>
                    Quick Links
                </h2>


                <div class="quick-link-grid">


                    <a href="Index.jsp"
                       class="quick-link">

                        <i class="fa-solid fa-house"></i>

                        Home

                    </a>


                    <a href="Login.jsp"
                       class="quick-link">

                        <i class="fa-solid fa-right-to-bracket"></i>

                        Login

                    </a>


                    <a href="Signup.jsp"
                       class="quick-link">

                        <i class="fa-solid fa-user-plus"></i>

                        Sign Up

                    </a>


                    <a href="Help.jsp"
                       class="quick-link">

                        <i class="fa-solid fa-circle-question"></i>

                        Help

                    </a>


                </div>

            </section>


        </main>



        <!-- ============================================================
             FOOTER
             ============================================================ -->

        <footer>

            <strong>
                Sunrise Dental Clinic
            </strong>

            &nbsp; | &nbsp;

            Help &amp; User Guide

            &nbsp; | &nbsp;

            &copy; 2026 Sunrise Dental Clinic.
            All Rights Reserved.

        </footer>


    </body>

</html>