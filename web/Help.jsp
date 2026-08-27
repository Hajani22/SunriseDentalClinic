<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            Help & Support Centre | Sunrise Dental Clinic
        </title>


        <!-- =====================================================
             GOOGLE FONT
             ===================================================== -->

        <link rel="preconnect"
              href="https://fonts.googleapis.com">

        <link rel="preconnect"
              href="https://fonts.gstatic.com"
              crossorigin>

        <link
            href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
            rel="stylesheet">


        <!-- =====================================================
             FONT AWESOME
             ===================================================== -->

        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /* =====================================================
               RESET
               ===================================================== */

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }


            body {

                font-family:
                    "Open Sans",
                    sans-serif;

                background:
                    #f5f8fb;

                color:
                    #555;

                line-height:
                    1.6;
            }


            /* =====================================================
               HEADER
               ===================================================== */

            .header {

                background:
                    #ffffff;

                height:
                    76px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;

                padding:
                    0 7%;

                border-bottom:
                    1px solid #e7edf2;

                box-shadow:
                    0 2px 10px rgba(0,0,0,0.04);

                position:
                    sticky;

                top:
                    0;

                z-index:
                    1000;
            }


            /* LOGO */

            .logo {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    12px;

                text-decoration:
                    none;

                color:
                    #102a43;
            }


            .logo-icon {

                width:
                    44px;

                height:
                    44px;

                border-radius:
                    10px;

                background:
                    #149ddd;

                color:
                    white;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    21px;
            }


            .logo-text {

                display:
                    flex;

                flex-direction:
                    column;
            }


            .logo-text strong {

                font-family:
                    "Jost",
                    sans-serif;

                font-size:
                    20px;

                line-height:
                    1.1;

                color:
                    #102a43;
            }


            .logo-text small {

                font-size:
                    11px;

                color:
                    #718096;

                letter-spacing:
                    0.5px;
            }


            /* HOME BUTTON */

            .home-button {

                display:
                    inline-flex;

                align-items:
                    center;

                gap:
                    8px;

                text-decoration:
                    none;

                background:
                    #149ddd;

                color:
                    white;

                padding:
                    10px 18px;

                border-radius:
                    7px;

                font-size:
                    13px;

                font-weight:
                    600;

                transition:
                    0.2s;
            }


            .home-button:hover {

                background:
                    #0c83bb;

                transform:
                    translateY(-1px);
            }


            /* =====================================================
               CONTAINER
               ===================================================== */

            .container {

                width:
                    88%;

                max-width:
                    1200px;

                margin:
                    auto;
            }


            /* =====================================================
               HERO
               ===================================================== */

            .hero {

                margin-top:
                    35px;

                padding:
                    55px 30px;

                border-radius:
                    18px;

                text-align:
                    center;

                color:
                    white;

                background:
                    linear-gradient(
                    135deg,
                    #0b1f44 0%,
                    #149ddd 100%
                    );

                box-shadow:
                    0 12px 35px rgba(11,31,68,0.15);
            }


            .hero-icon {

                width:
                    65px;

                height:
                    65px;

                margin:
                    0 auto 18px;

                border-radius:
                    50%;

                background:
                    rgba(255,255,255,0.15);

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    28px;
            }


            .hero h1 {

                font-family:
                    "Jost",
                    sans-serif;

                font-size:
                    34px;

                margin-bottom:
                    10px;
            }


            .hero p {

                max-width:
                    700px;

                margin:
                    auto;

                font-size:
                    14px;

                opacity:
                    0.92;
            }


            /* =====================================================
               SEARCH
               ===================================================== */

            .search-box {

                max-width:
                    650px;

                margin:
                    25px auto 0;

                position:
                    relative;
            }


            .search-box i {

                position:
                    absolute;

                left:
                    18px;

                top:
                    50%;

                transform:
                    translateY(-50%);

                color:
                    #7b8794;
            }


            .search-box input {

                width:
                    100%;

                height:
                    50px;

                border:
                    none;

                outline:
                    none;

                border-radius:
                    8px;

                padding:
                    0 20px 0 48px;

                font-size:
                    13px;

                font-family:
                    inherit;
            }


            .search-box input:focus {

                box-shadow:
                    0 0 0 3px
                    rgba(255,255,255,0.25);
            }


            /* =====================================================
               SECTION
               ===================================================== */

            .section {

                margin-top:
                    38px;
            }


            .section-heading {

                margin-bottom:
                    18px;
            }


            .section-heading h2 {

                font-family:
                    "Jost",
                    sans-serif;

                color:
                    #102a43;

                font-size:
                    25px;

                margin-bottom:
                    5px;
            }


            .section-heading p {

                color:
                    #7b8794;

                font-size:
                    13px;
            }


            /* =====================================================
               QUICK HELP
               ===================================================== */

            .quick-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap:
                    18px;
            }


            .quick-card {

                background:
                    white;

                border:
                    1px solid #e6edf2;

                border-radius:
                    12px;

                padding:
                    25px 18px;

                text-align:
                    center;

                cursor:
                    pointer;

                transition:
                    0.25s;

                box-shadow:
                    0 4px 15px rgba(16,42,67,0.03);
            }


            .quick-card:hover {

                transform:
                    translateY(-5px);

                border-color:
                    #149ddd;

                box-shadow:
                    0 10px 25px rgba(16,42,67,0.08);
            }


            .quick-icon {

                width:
                    52px;

                height:
                    52px;

                margin:
                    auto;

                border-radius:
                    12px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                background:
                    #eaf7fc;

                color:
                    #149ddd;

                font-size:
                    20px;
            }


            .quick-card h3 {

                font-family:
                    "Jost",
                    sans-serif;

                color:
                    #102a43;

                font-size:
                    16px;

                margin:
                    13px 0 6px;
            }


            .quick-card p {

                font-size:
                    12px;

                color:
                    #7b8794;
            }


            /* =====================================================
               FAQ
               ===================================================== */

            .faq-container {

                background:
                    white;

                border:
                    1px solid #e6edf2;

                border-radius:
                    12px;

                overflow:
                    hidden;

                box-shadow:
                    0 4px 15px rgba(16,42,67,0.03);
            }


            .faq-item {

                border-bottom:
                    1px solid #edf1f4;
            }


            .faq-item:last-child {

                border-bottom:
                    none;
            }


            .faq-question {

                width:
                    100%;

                border:
                    none;

                background:
                    white;

                padding:
                    19px 22px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    space-between;

                text-align:
                    left;

                cursor:
                    pointer;

                color:
                    #102a43;

                font-size:
                    14px;

                font-weight:
                    600;

                transition:
                    0.2s;
            }


            .faq-question:hover {

                background:
                    #f8fbfd;
            }


            .faq-question .arrow {

                width:
                    28px;

                height:
                    28px;

                border-radius:
                    50%;

                background:
                    #eaf7fc;

                color:
                    #149ddd;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    12px;

                flex-shrink:
                    0;
            }


            .faq-answer {

                display:
                    none;

                padding:
                    0 22px 20px;

                color:
                    #6b7785;

                font-size:
                    13px;

                line-height:
                    1.8;
            }


            .faq-item.active
            .faq-answer {

                display:
                    block;
            }


            .faq-item.active
            .faq-question {

                color:
                    #149ddd;
            }


            /* =====================================================
               NO RESULTS
               ===================================================== */

            .no-results {

                display:
                    none;

                background:
                    white;

                padding:
                    30px;

                border-radius:
                    10px;

                text-align:
                    center;

                color:
                    #7b8794;

                border:
                    1px solid #e6edf2;
            }


            /* =====================================================
               CONTACT AREA
               ===================================================== */

            .contact-grid {

                display:
                    grid;

                grid-template-columns:
                    1fr 1fr;

                gap:
                    20px;
            }


            .contact-card {

                background:
                    white;

                border:
                    1px solid #e6edf2;

                border-radius:
                    12px;

                padding:
                    28px;

                box-shadow:
                    0 4px 15px rgba(16,42,67,0.03);
            }


            .contact-card h3 {

                font-family:
                    "Jost",
                    sans-serif;

                font-size:
                    19px;

                color:
                    #102a43;

                margin-bottom:
                    20px;
            }


            .contact-item {

                display:
                    flex;

                gap:
                    13px;

                align-items:
                    flex-start;

                margin-bottom:
                    18px;
            }


            .contact-icon {

                width:
                    40px;

                height:
                    40px;

                flex-shrink:
                    0;

                border-radius:
                    8px;

                display:
                    flex;

                align-items:
                    center;

                justify-content:
                    center;

                background:
                    #eaf7fc;

                color:
                    #149ddd;
            }


            .contact-item strong {

                display:
                    block;

                color:
                    #102a43;

                font-size:
                    13px;

                margin-bottom:
                    2px;
            }


            .contact-item span {

                color:
                    #7b8794;

                font-size:
                    12px;
            }


            /* =====================================================
               SUPPORT FORM
               ===================================================== */

            .form-group {

                margin-bottom:
                    15px;
            }


            .form-group label {

                display:
                    block;

                color:
                    #102a43;

                font-size:
                    13px;

                font-weight:
                    600;

                margin-bottom:
                    6px;
            }


            .form-group input,
            .form-group select,
            .form-group textarea {

                width:
                    100%;

                border:
                    1px solid #d9e2ea;

                border-radius:
                    7px;

                padding:
                    11px 13px;

                outline:
                    none;

                font-family:
                    inherit;

                font-size:
                    13px;

                transition:
                    0.2s;
            }


            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {

                border-color:
                    #149ddd;

                box-shadow:
                    0 0 0 3px
                    rgba(20,157,221,0.08);
            }


            .form-group textarea {

                height:
                    110px;

                resize:
                    vertical;
            }


            .submit-button {

                border:
                    none;

                background:
                    #149ddd;

                color:
                    white;

                padding:
                    12px 22px;

                border-radius:
                    7px;

                font-family:
                    inherit;

                font-size:
                    13px;

                font-weight:
                    600;

                cursor:
                    pointer;

                transition:
                    0.2s;
            }


            .submit-button:hover {

                background:
                    #0c83bb;
            }


            /* =====================================================
               SUCCESS MESSAGE
               ===================================================== */

            .success-message {

                display:
                    none;

                background:
                    #e7f7ec;

                color:
                    #18743a;

                border:
                    1px solid #c5e8d0;

                border-radius:
                    7px;

                padding:
                    12px 14px;

                margin-bottom:
                    15px;

                font-size:
                    12px;
            }


            /* =====================================================
               FOOTER
               ===================================================== */

            .footer {

                margin-top:
                    50px;

                background:
                    #0b1f44;

                color:
                    #c8d2df;

                padding:
                    25px;

                text-align:
                    center;

                font-size:
                    12px;
            }


            .footer strong {

                color:
                    white;
            }


            /* =====================================================
               RESPONSIVE
               ===================================================== */

            @media(max-width: 1000px) {

                .quick-grid {

                    grid-template-columns:
                        repeat(2, 1fr);
                }

            }


            @media(max-width: 750px) {

                .header {

                    padding:
                        0 4%;
                }


                .container {

                    width:
                        94%;
                }


                .contact-grid {

                    grid-template-columns:
                        1fr;
                }


                .hero {

                    padding:
                        40px 20px;
                }


                .hero h1 {

                    font-size:
                        28px;
                }

            }


            @media(max-width: 500px) {

                .quick-grid {

                    grid-template-columns:
                        1fr;
                }


                .logo-text {

                    display:
                        none;
                }


                .home-button span {

                    display:
                        none;
                }

            }

        </style>

    </head>


    <body>


        <!-- =========================================================
             HEADER
             ========================================================= -->

        <header class="header">


            <a
                href="<%= request.getContextPath()%>/Index.jsp"
                class="logo">


                <span class="logo-icon">

                    <i class="fa-solid fa-tooth"></i>

                </span>


                <span class="logo-text">

                    <strong>
                        Sunrise
                    </strong>

                    <small>
                        Dental Clinic
                    </small>

                </span>


            </a>


            <a
                href="<%= request.getContextPath()%>/Index.jsp"
                class="home-button">

                <i class="fa-solid fa-house"></i>

                <span>
                    Back to Home
                </span>

            </a>


        </header>



        <!-- =========================================================
             MAIN
             ========================================================= -->

        <main class="container">


            <!-- =====================================================
                 HERO
                 ===================================================== -->

            <section class="hero">


                <div class="hero-icon">

                    <i class="fa-solid fa-circle-question"></i>

                </div>


                <h1>
                    Help & Support Centre
                </h1>


                <p>

                    Find quick answers to common questions about
                    appointments, doctor schedules, payments,
                    accounts and dental services.

                </p>


                <div class="search-box">

                    <i class="fa-solid fa-magnifying-glass"></i>


                    <input
                        type="text"
                        id="searchInput"
                        placeholder="Search for help...">

                </div>


            </section>



            <!-- =====================================================
                 QUICK HELP
                 ===================================================== -->

            <section class="section">


                <div class="section-heading">

                    <h2>
                        Quick Help
                    </h2>

                    <p>
                        Select a category to find the information you need.
                    </p>

                </div>


                <div class="quick-grid">


                    <!-- APPOINTMENTS -->

                    <div
                        class="quick-card"
                        onclick="filterCategory('appointment')">


                        <div class="quick-icon">

                            <i class="fa-solid fa-calendar-check"></i>

                        </div>


                        <h3>
                            Appointments
                        </h3>


                        <p>

                            Booking, confirmation,
                            rescheduling and cancellation.

                        </p>


                    </div>



                    <!-- DOCTOR SCHEDULE -->

                    <div
                        class="quick-card"
                        onclick="filterCategory('doctor')">


                        <div class="quick-icon">

                            <i class="fa-solid fa-user-doctor"></i>

                        </div>


                        <h3>
                            Doctor Schedule
                        </h3>


                        <p>

                            Dentist working days and
                            available appointment times.

                        </p>


                    </div>



                    <!-- PAYMENT -->

                    <div
                        class="quick-card"
                        onclick="filterCategory('payment')">


                        <div class="quick-icon">

                            <i class="fa-solid fa-credit-card"></i>

                        </div>


                        <h3>
                            Payments
                        </h3>


                        <p>

                            Billing, payments and
                            treatment charges.

                        </p>


                    </div>



                    <!-- ACCOUNT -->

                    <div
                        class="quick-card"
                        onclick="filterCategory('account')">


                        <div class="quick-icon">

                            <i class="fa-solid fa-user"></i>

                        </div>


                        <h3>
                            Account Help
                        </h3>


                        <p>

                            Login, registration and
                            patient account assistance.

                        </p>


                    </div>


                </div>


            </section>



            <!-- =====================================================
                 FAQ
                 ===================================================== -->

            <section
                class="section"
                id="faqSection">


                <div class="section-heading">

                    <h2>
                        Frequently Asked Questions
                    </h2>

                    <p>
                        Find answers to the most common questions.
                    </p>

                </div>


                <div
                    class="faq-container"
                    id="faqContainer">


                    <!-- =================================================
                         APPOINTMENT FAQ
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="appointment"
                        data-search="book appointment booking dentist patient">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                How can I book a dental appointment?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            To book an appointment, create a patient
                            account or log in to your existing account.
                            Select <strong>Book Appointment</strong>,
                            choose a dentist, treatment, date and
                            available time, then submit your appointment
                            request.

                        </div>


                    </div>



                    <!-- =================================================
                         CONFIRMATION
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="appointment"
                        data-search="appointment confirmation status accepted">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                How do I know if my appointment is confirmed?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            You can check the appointment status from
                            your patient appointment section. Important
                            appointment status changes can also be shown
                            through system notifications.

                        </div>


                    </div>



                    <!-- =================================================
                         RESCHEDULE
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="appointment"
                        data-search="reschedule change date appointment time">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                Can I reschedule my appointment?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            If rescheduling is available for your
                            appointment, select the appointment from
                            your appointment management section and
                            choose another available date and time.

                        </div>


                    </div>



                    <!-- =================================================
                         CANCEL
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="appointment"
                        data-search="cancel cancellation appointment">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                How can I cancel an appointment?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            Open your appointment list and select the
                            appointment that you want to cancel. Follow
                            the cancellation process provided by the
                            system.

                        </div>


                    </div>



                    <!-- =================================================
                         DOCTOR SCHEDULE
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="doctor"
                        data-search="doctor dentist schedule monday tuesday wednesday thursday friday saturday">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                When are dentists available?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            Dentist availability depends on the schedule
                            configured by the clinic. The Sunrise Dental
                            Clinic appointment system supports dentist
                            schedules from <strong>Monday to Saturday</strong>.
                            Available times are shown during appointment
                            booking.

                        </div>


                    </div>



                    <!-- =================================================
                         SUNDAY
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="doctor"
                        data-search="sunday dentist closed unavailable">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                Can I book an appointment on Sunday?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            The current clinic schedule is configured
                            for Monday to Saturday. Sunday is therefore
                            unavailable unless the clinic administrator
                            adds a Sunday schedule.

                        </div>


                    </div>



                    <!-- =================================================
                         PAYMENT
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="payment"
                        data-search="payment billing bill treatment price">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                Where can I get information about my bill?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            Billing information is managed through the
                            clinic billing process. If you have a question
                            about a treatment charge or payment, contact
                            the clinic support team.

                        </div>


                    </div>



                    <!-- =================================================
                         ACCOUNT
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="account"
                        data-search="login password account registration signup">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                What should I do if I cannot log in?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            First check that your registered email address
                            and password are correct. If you still cannot
                            access your account, contact the clinic support
                            team.

                        </div>


                    </div>



                    <!-- =================================================
                         REGISTRATION
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="account"
                        data-search="register signup create account patient">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                How can I create a patient account?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            Select <strong>Sign Up</strong> from the
                            Sunrise Dental Clinic home page and complete
                            the patient registration form. After successful
                            registration, you can log in and access the
                            patient appointment services.

                        </div>


                    </div>



                    <!-- =================================================
                         EMERGENCY
                         ================================================= -->


                    <div
                        class="faq-item"
                        data-category="other"
                        data-search="emergency urgent dental pain">


                        <button
                            type="button"
                            class="faq-question"
                            onclick="toggleFAQ(this)">


                            <span>
                                What should I do during a dental emergency?
                            </span>


                            <span class="arrow">
                                <i class="fa-solid fa-plus"></i>
                            </span>


                        </button>


                        <div class="faq-answer">

                            For an urgent or serious dental emergency,
                            contact the clinic directly. If the situation
                            is life-threatening, seek emergency medical
                            assistance immediately.

                        </div>


                    </div>


                </div>


                <!-- NO RESULTS -->

                <div
                    class="no-results"
                    id="noResults">

                    <i class="fa-solid fa-magnifying-glass"
                       style="font-size:25px;margin-bottom:10px;">
                    </i>

                    <p>
                        No matching help topics were found.
                    </p>

                    <small>
                        Try another search term.
                    </small>

                </div>


            </section>



            <!-- =====================================================
                 CONTACT & SUPPORT
                 ===================================================== -->

            <section class="section">


                <div class="section-heading">

                    <h2>
                        Contact & Support
                    </h2>

                    <p>
                        Need additional assistance? Contact Sunrise
                        Dental Clinic directly.
                    </p>

                </div>


                <div class="contact-grid">


                    <!-- =================================================
                         CONTACT INFORMATION
                         ================================================= -->


                    <div class="contact-card">


                        <h3>
                            Contact Sunrise Dental Clinic
                        </h3>


                        <!-- PHONE -->

                        <div class="contact-item">


                            <div class="contact-icon">

                                <i class="fa-solid fa-phone"></i>

                            </div>


                            <div>

                                <strong>
                                    Phone
                                </strong>

                                <span>
                                    +94 11 234 5678
                                </span>

                            </div>


                        </div>



                        <!-- EMAIL -->

                        <div class="contact-item">


                            <div class="contact-icon">

                                <i class="fa-solid fa-envelope"></i>

                            </div>


                            <div>

                                <strong>
                                    Email
                                </strong>

                                <span>
                                    info@sunrisedentalclinic.com
                                </span>

                            </div>


                        </div>



                        <!-- ADDRESS -->

                        <div class="contact-item">


                            <div class="contact-icon">

                                <i class="fa-solid fa-location-dot"></i>

                            </div>


                            <div>

                                <strong>
                                    Address
                                </strong>

                                <span>
                                    Colombo, Sri Lanka
                                </span>

                            </div>


                        </div>



                        <!-- OPENING HOURS -->

                        <div class="contact-item">


                            <div class="contact-icon">

                                <i class="fa-solid fa-clock"></i>

                            </div>


                            <div>

                                <strong>
                                    Opening Hours
                                </strong>

                                <span>
                                    Monday - Saturday
                                </span>

                            </div>


                        </div>


                    </div>



                    <!-- =================================================
                         SEND ENQUIRY
                         ================================================= -->


                    <div class="contact-card">


                        <h3>
                            Send an Enquiry
                        </h3>


                        <div
                            class="success-message"
                            id="successMessage">

                            <i class="fa-solid fa-circle-check"></i>

                            Thank you. Your enquiry has been submitted
                            successfully.

                        </div>


                        <form
                            id="supportForm"
                            onsubmit="submitEnquiry(event)">


                            <!-- NAME -->

                            <div class="form-group">

                                <label for="name">
                                    Name
                                </label>

                                <input
                                    type="text"
                                    id="name"
                                    name="name"
                                    maxlength="100"
                                    placeholder="Enter your name"
                                    required>

                            </div>



                            <!-- EMAIL -->

                            <div class="form-group">

                                <label for="email">
                                    Email
                                </label>

                                <input
                                    type="email"
                                    id="email"
                                    name="email"
                                    maxlength="150"
                                    placeholder="Enter your email"
                                    required>

                            </div>



                            <!-- CATEGORY -->

                            <div class="form-group">

                                <label for="category">
                                    Support Category
                                </label>

                                <select
                                    id="category"
                                    name="category">

                                    <option value="General">
                                        General Enquiry
                                    </option>

                                    <option value="Appointment">
                                        Appointment
                                    </option>

                                    <option value="Doctor Schedule">
                                        Doctor Schedule
                                    </option>

                                    <option value="Payment">
                                        Payment & Billing
                                    </option>

                                    <option value="Account">
                                        Account / Login
                                    </option>

                                    <option value="Emergency">
                                        Emergency

                                    </option>

                                </select>

                            </div>



                            <!-- MESSAGE -->

                            <div class="form-group">

                                <label for="message">
                                    Message
                                </label>

                                <textarea
                                    id="message"
                                    name="message"
                                    maxlength="1000"
                                    placeholder="Describe your question or issue..."
                                    required></textarea>

                            </div>



                            <button
                                type="submit"
                                class="submit-button">

                                <i class="fa-solid fa-paper-plane"></i>

                                Submit Enquiry

                            </button>


                        </form>


                    </div>


                </div>


            </section>


        </main>



        <!-- =========================================================
             FOOTER
             ========================================================= -->

        <footer class="footer">

            <strong>
                Sunrise Dental Clinic
            </strong>

            <br>

            Help & Support Centre

            <br><br>

            © 2026 Sunrise Dental Clinic.
            All Rights Reserved.

        </footer>



        <!-- =========================================================
             JAVASCRIPT
             ========================================================= -->

        <script>


            /* ========================================================
             FAQ OPEN / CLOSE
             ======================================================== */

            function toggleFAQ(button) {


                const item =
                        button.closest(".faq-item");


                const isActive =
                        item.classList.contains("active");


                /*
                 * Close all other FAQ items.
                 */

                document
                        .querySelectorAll(".faq-item")
                        .forEach(function (faq) {

                            faq.classList.remove("active");

                            const icon =
                                    faq.querySelector(".arrow i");

                            if (icon) {

                                icon.className =
                                        "fa-solid fa-plus";

                            }

                        });


                /*
                 * Open selected item.
                 */

                if (!isActive) {

                    item.classList.add("active");


                    const icon =
                            button.querySelector(".arrow i");


                    if (icon) {

                        icon.className =
                                "fa-solid fa-minus";

                    }

                }

            }



            /* ========================================================
             SEARCH FAQ
             ======================================================== */

            document
                    .getElementById("searchInput")
                    .addEventListener(
                            "input",
                            function () {


                                const search =
                                        this.value
                                        .toLowerCase()
                                        .trim();


                                const items =
                                        document.querySelectorAll(
                                                ".faq-item"
                                                );


                                let found =
                                        0;


                                items.forEach(function (item) {


                                    const text =
                                            (
                                                    item.innerText
                                                    + " "
                                                    + (
                                                            item.getAttribute(
                                                                    "data-search"
                                                                    ) || ""
                                                            )
                                                    )
                                            .toLowerCase();


                                    if (
                                            text.includes(search)
                                            ) {

                                        item.style.display =
                                                "";

                                        found++;

                                    } else {

                                        item.style.display =
                                                "none";

                                    }

                                });


                                const noResults =
                                        document.getElementById(
                                                "noResults"
                                                );


                                if (found === 0) {

                                    noResults.style.display =
                                            "block";

                                } else {

                                    noResults.style.display =
                                            "none";

                                }

                            }
                    );



            /* ========================================================
             QUICK CATEGORY FILTER
             ======================================================== */

            function filterCategory(category) {


                const items =
                        document.querySelectorAll(
                                ".faq-item"
                                );


                let found =
                        0;


                items.forEach(function (item) {


                    const itemCategory =
                            item.getAttribute(
                                    "data-category"
                                    );


                    if (
                            itemCategory === category
                            ) {

                        item.style.display =
                                "";

                        found++;

                    } else {

                        item.style.display =
                                "none";

                    }

                });


                document
                        .getElementById("faqSection")
                        .scrollIntoView({
                            behavior: "smooth",
                            block: "start"
                        });


                document
                        .getElementById("noResults")
                        .style.display =
                        found === 0
                        ? "block"
                        : "none";


                /*
                 * Clear search field.
                 */

                document
                        .getElementById("searchInput")
                        .value = "";

            }



            /* ========================================================
             SUPPORT ENQUIRY
             ======================================================== */

            function submitEnquiry(event) {


                event.preventDefault();


                const name =
                        document
                        .getElementById("name")
                        .value
                        .trim();


                const email =
                        document
                        .getElementById("email")
                        .value
                        .trim();


                const message =
                        document
                        .getElementById("message")
                        .value
                        .trim();


                /*
                 * Basic validation.
                 */

                if (
                        name === ""
                        ||
                        email === ""
                        ||
                        message === ""
                        ) {

                    alert(
                            "Please complete all required fields."
                            );

                    return;

                }


                /*
                 * Display success message.
                 *
                 * This is intentionally front-end only.
                 * No login is required.
                 */

                document
                        .getElementById("successMessage")
                        .style.display =
                        "block";


                /*
                 * Clear form.
                 */

                document
                        .getElementById("supportForm")
                        .reset();


                /*
                 * Scroll to success message.
                 */

                document
                        .getElementById("successMessage")
                        .scrollIntoView({
                            behavior: "smooth",
                            block: "center"
                        });

            }


        </script>


    </body>

</html>