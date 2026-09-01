<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Signup | Sunrise Dental Clinic</title>


        <!-- =====================================================
             GOOGLE FONTS
        ====================================================== -->

        <link rel="preconnect"
              href="https://fonts.googleapis.com">

        <link rel="preconnect"
              href="https://fonts.gstatic.com"
              crossorigin>

        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;500;600&display=swap"
              rel="stylesheet">


        <!-- =====================================================
             FONT AWESOME
        ====================================================== -->

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


        <style>

            /* =========================================================
               SUNRISE DENTAL CLINIC
               PREMIUM PROFESSIONAL SIGNUP UI
               LAYOUT PRESERVED
               ========================================================= */

            :root {
                --primary: #087fa8;
                --primary-dark: #056582;
                --teal: #16b8a6;

                --navy: #102f43;
                --text: #536b79;
                --muted: #82939e;

                --light: #f4fafc;
                --border: #dce9ee;

                --white: #ffffff;

                --success: #198754;
                --danger: #dc3545;

                --shadow:
                    0 25px 70px rgba(16,47,67,.18);

                --soft-shadow:
                    0 10px 30px rgba(16,47,67,.08);
            }


            /* =========================================================
               RESET
               ========================================================= */

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html,
            body {
                width: 100%;
                min-height: 100%;
            }

            body {
                font-family: "Open Sans", sans-serif;

                background: #edf5f8;

                color: var(--text);

                overflow: hidden;
            }

            a {
                text-decoration: none;
                color: inherit;
            }

            button,
            input,
            select {
                font-family: inherit;
            }


            /* =========================================================
               MAIN PAGE
               ========================================================= */

            .signup-page {

                width: 100%;
                height: 100vh;

                padding: 18px;

                display: flex;

                align-items: center;
                justify-content: center;

                overflow: hidden;

                background:

                    linear-gradient(
                    135deg,
                    rgba(7,49,68,.91),
                    rgba(8,127,168,.72)
                    ),

                    url("https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&w=1800&q=90");

                background-size: cover;

                background-position: center;
            }


            /* =========================================================
               MAIN CONTAINER
               ========================================================= */

            .signup-wrapper {

                width: 100%;

                max-width: 1500px;

                height: calc(100vh - 36px);

                display: grid;

                grid-template-columns: 38% 62%;

                background: #fff;

                border-radius: 24px;

                overflow: hidden;

                box-shadow: var(--shadow);

                border: 1px solid rgba(255,255,255,.35);
            }


            /* =========================================================
               LEFT PANEL
               ========================================================= */

            .signup-left {

                height: 100%;

                min-width: 0;

                padding: 42px 48px;

                position: relative;

                color: #fff;

                background:

                    linear-gradient(
                    145deg,
                    rgba(5,125,161,.91),
                    rgba(9,40,58,.97)
                    ),

                    url("https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=1200&q=90");

                background-size: cover;

                background-position: center;

                display: flex;

                flex-direction: column;

                justify-content: space-between;

                overflow: hidden;
            }


            /* Decorative circles */

            .signup-left::before {

                content: "";

                position: absolute;

                width: 380px;
                height: 380px;

                right: -210px;
                top: -150px;

                border-radius: 50%;

                border:
                    1px solid rgba(255,255,255,.12);
            }

            .signup-left::after {

                content: "";

                position: absolute;

                width: 260px;
                height: 260px;

                left: -150px;
                bottom: -130px;

                border-radius: 50%;

                border:
                    1px solid rgba(255,255,255,.10);
            }

            .signup-left > * {

                position: relative;

                z-index: 2;
            }


            /* =========================================================
               BRAND
               ========================================================= */

            .brand {

                display: flex;

                align-items: center;

                gap: 13px;

                color: #fff;
            }

            .brand-icon {

                width: 58px;
                height: 58px;

                border-radius: 16px;

                background: rgba(255,255,255,.96);

                color: var(--primary);

                display: flex;

                align-items: center;
                justify-content: center;

                font-size: 25px;

                box-shadow:
                    0 10px 25px rgba(0,0,0,.14);
            }

            .brand-text strong {

                display: block;

                font-family: "Jost", sans-serif;

                font-size: 27px;

                line-height: 1.1;

                letter-spacing: -.4px;
            }

            .brand-text span {

                display: block;

                margin-top: 5px;

                font-size: 10px;

                opacity: .82;

                text-transform: uppercase;

                letter-spacing: 1.7px;
            }


            /* =========================================================
               LEFT CONTENT
               ========================================================= */

            .left-content {

                margin-top: 40px;
            }

            .left-tag {

                display: inline-flex;

                align-items: center;

                gap: 8px;

                padding: 8px 14px;

                border-radius: 999px;

                background:
                    rgba(255,255,255,.12);

                border:
                    1px solid rgba(255,255,255,.15);

                font-size: 10px;

                font-weight: 800;

                letter-spacing: 1.1px;

                margin-bottom: 22px;

                backdrop-filter: blur(8px);
            }

            .left-tag i {

                color: #8cece0;
            }

            .left-content h1 {

                font-family: "Jost", sans-serif;

                font-size:
                    clamp(38px,3.3vw,57px);

                line-height: 1.04;

                margin-bottom: 21px;

                color: #fff;

                letter-spacing: -1.4px;
            }

            .left-content p {

                max-width: 470px;

                line-height: 1.75;

                font-size: 14px;

                color:
                    rgba(255,255,255,.82);
            }


            /* =========================================================
               BENEFITS
               ========================================================= */

            .benefits {

                margin-top: 30px;
            }

            .benefit {

                display: flex;

                align-items: center;

                gap: 12px;

                margin-bottom: 13px;
            }

            .benefit i {

                width: 39px;
                height: 39px;

                border-radius: 11px;

                background:
                    rgba(255,255,255,.10);

                border:
                    1px solid rgba(255,255,255,.10);

                display: flex;

                align-items: center;
                justify-content: center;

                color: #9ef1e5;

                flex-shrink: 0;

                font-size: 14px;
            }

            .benefit span {

                font-size: 13px;

                color:
                    rgba(255,255,255,.88);
            }

            .left-footer {

                font-size: 11px;

                opacity: .62;
            }


            /* =========================================================
               RIGHT PANEL
               ========================================================= */

            .signup-right {

                height: 100%;

                min-width: 0;

                padding: 42px 70px;

                background: #fff;

                overflow-x: hidden;

                overflow-y: auto;

                scrollbar-width: thin;

                scrollbar-color:
                    #bfd1d9 transparent;
            }

            .signup-right::-webkit-scrollbar {

                width: 6px;
            }

            .signup-right::-webkit-scrollbar-track {

                background: transparent;
            }

            .signup-right::-webkit-scrollbar-thumb {

                background: #bfd1d9;

                border-radius: 10px;
            }

            .signup-right::-webkit-scrollbar-thumb:hover {

                background: var(--primary);
            }


            /* =========================================================
               HEADER
               ========================================================= */

            .signup-header {

                margin-bottom: 24px;
            }

            .signup-header h2 {

                font-family: "Jost", sans-serif;

                color: var(--navy);

                font-size: 38px;

                line-height: 1.15;

                margin-bottom: 8px;

                letter-spacing: -.7px;
            }

            .signup-header p {

                font-size: 13px;

                color: var(--muted);

                line-height: 1.6;
            }


            /* =========================================================
               SIGNUP AS
               ========================================================= */

            .signup-as {

                margin-bottom: 23px;
            }

            .signup-as label {

                display: block;

                color: var(--navy);

                font-size: 12px;

                font-weight: 800;

                margin-bottom: 8px;

                text-transform: uppercase;

                letter-spacing: .7px;
            }

            .signup-role {

                width: 100%;

                height: 52px;

                padding: 0 15px;

                border:
                    1px solid var(--border);

                border-radius: 11px;

                background: #fbfdfe;

                color: var(--navy);

                font-size: 13px;

                font-weight: 600;

                outline: none;

                cursor: pointer;

                transition: .25s ease;
            }

            .signup-role:hover {

                border-color: #bdd3dc;
            }

            .signup-role:focus {

                border-color: var(--primary);

                background: #fff;

                box-shadow:
                    0 0 0 3px rgba(8,127,168,.09);
            }


            /* =========================================================
               FORM SECTION
               ========================================================= */

            .form-section {

                margin-bottom: 20px;
            }

            .section-title {

                display: flex;

                align-items: center;

                gap: 9px;

                color: var(--navy);

                font-family: "Jost", sans-serif;

                font-size: 17px;

                margin-bottom: 13px;

                padding-bottom: 9px;

                border-bottom:
                    1px solid #edf0f3;
            }

            .section-title i {

                width: 30px;
                height: 30px;

                display: flex;

                align-items: center;
                justify-content: center;

                border-radius: 8px;

                background: #edf9fb;

                color: var(--primary);

                font-size: 13px;
            }


            /* =========================================================
               FORM GRID
               ========================================================= */

            .form-grid {

                display: grid;

                grid-template-columns:
                    repeat(2,minmax(0,1fr));

                gap: 13px 20px;
            }

            .form-group {

                min-width: 0;
            }

            .form-group label {

                display: block;

                color: var(--navy);

                font-size: 11px;

                font-weight: 800;

                margin-bottom: 6px;
            }

            .required {

                color: var(--danger);
            }


            /* =========================================================
               INPUT
               ========================================================= */

            .input-wrapper {

                position: relative;
            }

            .input-wrapper > i {

                position: absolute;

                left: 14px;

                top: 50%;

                transform:
                    translateY(-50%);

                color: #9aabb4;

                font-size: 13px;

                pointer-events: none;

                transition: .2s ease;
            }

            .input-wrapper:focus-within > i {

                color: var(--primary);
            }

            .form-control {

                width: 100%;

                height: 48px;

                border:
                    1px solid var(--border);

                border-radius: 10px;

                padding:
                    10px 13px 10px 40px;

                background: #fbfdfe;

                color: var(--navy);

                font-size: 12px;

                outline: none;

                transition:
                    border-color .25s ease,
                    box-shadow .25s ease,
                    background .25s ease;
            }

            .form-control::placeholder {

                color: #a8b4bb;
            }

            .form-control:hover {

                border-color: #bfd3dc;
            }

            .form-control:focus {

                background: #fff;

                border-color: var(--primary);

                box-shadow:
                    0 0 0 3px rgba(8,127,168,.08);
            }

            select.form-control {

                cursor: pointer;
            }


            /* =========================================================
               ROLE AREA
               IMPORTANT:
               Does NOT use scrollIntoView.
               Prevents page jumping when role changes.
               ========================================================= */

            .role-area {

                position: relative;

                min-height: 165px;
            }

            .role-fields {

                display: none;
            }

            .role-fields.active {

                display: block;
            }


            /* =========================================================
               PASSWORD
               ========================================================= */

            .password-wrapper .form-control {

                padding-right: 43px;
            }

            .password-toggle {

                position: absolute;

                right: 11px;

                top: 50%;

                transform:
                    translateY(-50%);

                width: 34px;
                height: 34px;

                border: none;

                border-radius: 8px;

                background: transparent;

                color: #8999a3;

                cursor: pointer;

                display: flex;

                align-items: center;
                justify-content: center;

                transition: .2s ease;
            }

            .password-toggle:hover {

                color: var(--primary);

                background: #edf8fb;
            }


            /* =========================================================
               TERMS
               ========================================================= */

            .terms {

                display: flex;

                align-items: flex-start;

                gap: 9px;

                margin:
                    9px 0 16px;

                font-size: 11px;

                line-height: 1.6;

                color: #687983;
            }

            .terms input {

                width: 14px;
                height: 14px;

                margin-top: 3px;

                flex-shrink: 0;

                accent-color:
                    var(--primary);
            }

            .terms a {

                color: var(--primary);

                font-weight: 700;
            }

            .terms a:hover {

                text-decoration: underline;
            }


            /* =========================================================
               CREATE ACCOUNT BUTTON
               ========================================================= */

            .signup-btn {

                width: 100%;

                min-height: 52px;

                border: none;

                border-radius: 11px;

                background:
                    linear-gradient(
                    135deg,
                    var(--primary),
                    var(--teal)
                    );

                color: #fff;

                padding: 13px;

                font-family: "Jost", sans-serif;

                font-size: 15px;

                font-weight: 700;

                cursor: pointer;

                display: flex;

                align-items: center;

                justify-content: center;

                gap: 9px;

                box-shadow:
                    0 10px 24px
                    rgba(8,127,168,.18);

                transition:
                    transform .25s ease,
                    box-shadow .25s ease,
                    filter .25s ease;
            }

            .signup-btn:hover {

                transform:
                    translateY(-2px);

                box-shadow:
                    0 14px 30px
                    rgba(8,127,168,.25);

                filter: brightness(1.03);
            }

            .signup-btn:active {

                transform:
                    translateY(0);
            }


            /* =========================================================
               LOGIN
               ========================================================= */

            .login-text {

                text-align: center;

                margin-top: 18px;

                font-size: 12px;

                color: #7b8991;
            }

            .login-text a {

                color: var(--primary);

                font-weight: 800;
            }

            .login-text a:hover {

                text-decoration: underline;
            }


            /* =========================================================
               BACK HOME
               ========================================================= */

            .back-home {

                text-align: center;

                margin-top: 9px;
            }

            .back-home a {

                display: inline-flex;

                align-items: center;

                gap: 6px;

                color: #8b99a1;

                font-size: 11px;

                transition: .2s ease;
            }

            .back-home a:hover {

                color: var(--primary);
            }


            /* =========================================================
               SUCCESS MESSAGE
               ========================================================= */

            .success-message {

                display: none;

                background: #e9f8ef;

                border:
                    1px solid #b7e4c7;

                color: var(--success);

                border-radius: 10px;

                padding: 11px 13px;

                margin-bottom: 17px;

                font-size: 12px;
            }


            /* =========================================================
               DESKTOP SHORT HEIGHT
               ========================================================= */

            @media
            (min-width:851px)
            and (max-height:800px) {

                .signup-left {

                    padding-top: 30px;
                    padding-bottom: 25px;
                }

                .signup-right {

                    padding-top: 25px;
                    padding-bottom: 20px;
                }

                .left-content {

                    margin-top: 25px;
                }

                .left-content h1 {

                    font-size: 42px;
                }

                .benefits {

                    margin-top: 20px;
                }

                .benefit {

                    margin-bottom: 8px;
                }

                .signup-header {

                    margin-bottom: 17px;
                }

                .signup-header h2 {

                    font-size: 32px;
                }

                .signup-as {

                    margin-bottom: 15px;
                }

                .role-area {

                    min-height: 150px;
                }

                .form-section {

                    margin-bottom: 13px;
                }

                .form-control {

                    height: 44px;
                }

                .signup-btn {

                    min-height: 46px;
                }
            }


            /* =========================================================
               TABLET
               ========================================================= */

            @media (max-width:850px) {

                body {

                    height: auto;

                    min-height: 100vh;

                    overflow-x: hidden;

                    overflow-y: auto;
                }

                .signup-page {

                    height: auto;

                    min-height: 100vh;

                    padding: 10px;

                    overflow: visible;
                }

                .signup-wrapper {

                    height: auto;

                    min-height: auto;

                    grid-template-columns: 1fr;

                    max-width: 700px;
                }

                .signup-left {

                    min-height: 410px;

                    height: auto;

                    padding: 32px 28px;
                }

                .signup-right {

                    height: auto;

                    overflow: visible;

                    padding: 35px;
                }

                .role-area {

                    min-height: 165px;
                }
            }


            /* =========================================================
               MOBILE
               ========================================================= */

            @media (max-width:600px) {

                .signup-page {

                    padding: 0;
                }

                .signup-wrapper {

                    border-radius: 0;
                }

                .signup-left {

                    min-height: 375px;

                    padding: 30px 22px;
                }

                .brand-icon {

                    width: 50px;
                    height: 50px;

                    font-size: 22px;
                }

                .brand-text strong {

                    font-size: 23px;
                }

                .brand-text span {

                    font-size: 9px;
                }

                .left-content {

                    margin-top: 30px;
                }

                .left-content h1 {

                    font-size: 34px;
                }

                .left-content p {

                    font-size: 13px;
                }

                .benefits {

                    margin-top: 22px;
                }

                .benefit {

                    margin-bottom: 9px;
                }

                .benefit i {

                    width: 35px;
                    height: 35px;
                }

                .benefit span {

                    font-size: 12px;
                }

                .signup-right {

                    padding: 30px 20px 40px;
                }

                .signup-header h2 {

                    font-size: 30px;
                }

                .form-grid {

                    grid-template-columns: 1fr;
                }

                .role-area {

                    min-height: 285px;
                }
            }


            /* =========================================================
               ACCESSIBILITY
               ========================================================= */

            @media (prefers-reduced-motion: reduce) {

                *,
                *::before,
                *::after {

                    transition-duration:
                        .01ms !important;

                    animation-duration:
                        .01ms !important;
                }
            }

        </style>
    </head>



    <body>


        <!-- =========================================================
             MAIN PAGE
        ========================================================= -->

        <div class="signup-page">


            <div class="signup-wrapper">


                <!-- =================================================
                     LEFT PANEL
                ================================================== -->

                <aside class="signup-left">


                    <div>


                        <!-- BRAND -->

                        <a href="Index.jsp"
                           class="brand">


                            <div class="brand-icon">

                                <i class="fa-solid fa-tooth"></i>

                            </div>


                            <div class="brand-text">

                                <strong>
                                    Sunrise
                                </strong>

                                <span>
                                    Dental Clinic
                                </span>

                            </div>


                        </a>



                        <!-- LEFT CONTENT -->

                        <div class="left-content">


                            <span class="left-tag">

                                <i class="fa-solid fa-shield-heart"></i>

                                SECURE REGISTRATION

                            </span>


                            <h1>

                                Create Your

                                <br>

                                Professional Account

                            </h1>


                            <p>

                                Join the Sunrise Dental Clinic
                                management portal. Select your
                                account type and complete your
                                registration.

                            </p>


                            <!-- BENEFITS -->

                            <div class="benefits">


                                <div class="benefit">

                                    <i class="fa-solid fa-lock"></i>

                                    <span>
                                        Secure account registration
                                    </span>

                                </div>


                                <div class="benefit">

                                    <i class="fa-solid fa-user-shield"></i>

                                    <span>
                                        Role-based access
                                    </span>

                                </div>


                                <div class="benefit">

                                    <i class="fa-solid fa-calendar-check"></i>

                                    <span>
                                        Easy appointment management
                                    </span>

                                </div>


                                <div class="benefit">

                                    <i class="fa-solid fa-cash-register"></i>

                                    <span>
                                        Secure cashier and billing management
                                    </span>

                                </div>


                            </div>


                        </div>


                    </div>


                    <div class="left-footer">

                        © 2026 Sunrise Dental Clinic.
                        All rights reserved.

                    </div>


                </aside>



                <!-- =================================================
                     RIGHT PANEL
                ================================================== -->

                <main class="signup-right">


                    <!-- SUCCESS MESSAGE -->

                    <div id="successMessage"
                         class="success-message">

                        <i class="fa-solid fa-circle-check"></i>

                        Registration completed successfully.

                    </div>



                    <!-- HEADER -->

                    <div class="signup-header">

                        <h2>
                            Create Your Account
                        </h2>


                        <p>
                            Enter your details to create your account.
                        </p>

                    </div>



                    <!-- =================================================
                         SIGNUP AS
                    ================================================== -->

                    <div class="signup-as">

                        <label for="role">
                            Signup As
                        </label>

                        <select id="role"
                                name="role"
                                class="signup-role"
                                form="signupForm"
                                onchange="changeRole()">

                            <option value="patient" selected>
                                Patient
                            </option>

                            <option value="doctor">
                                Doctor
                            </option>

                            <option value="cashier">
                                Cashier
                            </option>

                            <option value="admin">
                                Admin
                            </option>

                        </select>

                    </div>



                    <!-- =================================================
                         FORM
                    ================================================== -->

                    <form id="signupForm"
                          action="${pageContext.request.contextPath}/SignupServlet"
                          method="post">

                        <!-- =================================================
                             PERSONAL INFORMATION
                        ================================================== -->

                        <section class="form-section">


                            <div class="section-title">

                                <i class="fa-solid fa-user"></i>

                                Personal Information

                            </div>


                            <div class="form-grid">


                                <!-- FIRST NAME -->

                                <div class="form-group">

                                    <label for="firstName">

                                        First Name
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper">

                                        <i class="fa-solid fa-user"></i>


                                        <input
                                            type="text"
                                            id="firstName"
                                            name="firstName"
                                            class="form-control"
                                            placeholder="Enter first name"
                                            required
                                            >

                                    </div>

                                </div>



                                <!-- LAST NAME -->

                                <div class="form-group">

                                    <label for="lastName">

                                        Last Name
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper">

                                        <i class="fa-solid fa-user"></i>


                                        <input
                                            type="text"
                                            id="lastName"
                                            name="lastName"
                                            class="form-control"
                                            placeholder="Enter last name"
                                            required
                                            >

                                    </div>

                                </div>



                                <!-- EMAIL -->

                                <div class="form-group">

                                    <label for="email">

                                        Email Address
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper">

                                        <i class="fa-solid fa-envelope"></i>


                                        <input
                                            type="email"
                                            id="email"
                                            name="email"
                                            class="form-control"
                                            placeholder="example@email.com"
                                            required
                                            >

                                    </div>

                                </div>



                                <!-- PHONE -->

                                <div class="form-group">

                                    <label for="phone">

                                        Phone Number
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper">

                                        <i class="fa-solid fa-phone"></i>


                                        <input
                                            type="tel"
                                            id="phone"
                                            name="phone"
                                            class="form-control"
                                            placeholder="+94 7X XXX XXXX"
                                            required
                                            >

                                    </div>

                                </div>


                            </div>

                        </section>



                        <!-- =================================================
                             FIXED ROLE AREA
                        ================================================== -->

                        <div class="role-area">


                            <!-- =================================================
                                 PATIENT
                            ================================================== -->

                            <section id="patientFields"
                                     class="form-section role-fields active">


                                <div class="section-title">

                                    <i class="fa-solid fa-user"></i>

                                    Patient Information

                                </div>


                                <div class="form-grid">


                                    <!-- DATE OF BIRTH -->

                                    <div class="form-group">

                                        <label for="patientDob">

                                            Date of Birth
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-calendar"></i>


                                            <input
                                                type="date"
                                                id="patientDob"
                                                name="dateOfBirth"
                                                class="form-control"
                                                >

                                        </div>

                                    </div>



                                    <!-- GENDER -->

                                    <div class="form-group">

                                        <label for="patientGender">

                                            Gender
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-venus-mars"></i>


                                            <select
                                                id="patientGender"
                                                name="gender"
                                                class="form-control"
                                                >

                                                <option value="">

                                                    Select Gender

                                                </option>


                                                <option value="male">

                                                    Male

                                                </option>


                                                <option value="female">

                                                    Female

                                                </option>


                                                <option value="other">

                                                    Other

                                                </option>


                                            </select>

                                        </div>

                                    </div>


                                </div>

                            </section>



                            <!-- =================================================
                                 DOCTOR
                            ================================================== -->

                            <section id="doctorFields"
                                     class="form-section role-fields">


                                <div class="section-title">

                                    <i class="fa-solid fa-user-doctor"></i>

                                    Doctor Information

                                </div>


                                <div class="form-grid">


                                    <!-- REGISTRATION -->

                                    <div class="form-group">

                                        <label for="doctorLicense">

                                            Medical Registration No.
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-id-card"></i>


                                            <input
                                                type="text"
                                                id="doctorLicense"
                                                name="medicalRegistrationNo"
                                                class="form-control"
                                                placeholder="SLMC / Registration No."
                                                >

                                        </div>

                                    </div>



                                    <!-- SPECIALIZATION -->

                                    <div class="form-group">

                                        <label for="specialization">

                                            Specialization
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-stethoscope"></i>


                                            <select
                                                id="specialization"
                                                name="specialization"
                                                class="form-control"
                                                >

                                                <option value="">

                                                    Select Specialization

                                                </option>


                                                <option value="general">

                                                    General Dentistry

                                                </option>


                                                <option value="orthodontics">

                                                    Orthodontics

                                                </option>


                                                <option value="oral-surgery">

                                                    Oral Surgery

                                                </option>


                                                <option value="periodontics">

                                                    Periodontics

                                                </option>


                                                <option value="prosthodontics">

                                                    Prosthodontics

                                                </option>


                                                <option value="endodontics">

                                                    Endodontics

                                                </option>


                                                <option value="pediatric">

                                                    Pediatric Dentistry

                                                </option>


                                                <option value="cosmetic">

                                                    Cosmetic Dentistry

                                                </option>


                                            </select>

                                        </div>

                                    </div>



                                </div>

                            </section>



                            <!-- =================================================
                                 CASHIER
                            ================================================== -->

                            <section id="cashierFields"
                                     class="form-section role-fields">


                                <div class="section-title">

                                    <i class="fa-solid fa-cash-register"></i>

                                    Cashier Information

                                </div>


                                <div class="form-grid">


                                    <!-- EMPLOYEE ID -->

                                    <div class="form-group">

                                        <label for="cashierEmployeeId">

                                            Employee ID
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-id-badge"></i>


                                            <input
                                                type="text"
                                                id="cashierEmployeeId"
                                                name="employeeId"
                                                class="form-control"
                                                placeholder="Enter employee ID"
                                                >

                                        </div>

                                    </div>



                                    <!-- DEPARTMENT -->

                                    <div class="form-group">

                                        <label for="cashierDepartment">

                                            Department
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-building"></i>


                                            <select
                                                id="cashierDepartment"
                                                name="department"
                                                class="form-control"
                                                >

                                                <option value="">

                                                    Select Department

                                                </option>


                                                <option value="billing">

                                                    Billing

                                                </option>


                                                <option value="finance">

                                                    Finance

                                                </option>


                                                <option value="accounts">

                                                    Accounts

                                                </option>



                                            </select>

                                        </div>

                                    </div>



                                    <!-- SHIFT -->

                                    <div class="form-group">

                                        <label for="cashierShift">

                                            Cashier Shift
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-clock"></i>


                                            <select
                                                id="cashierShift"
                                                name="cashierShift"
                                                class="form-control"
                                                >

                                                <option value="">

                                                    Select Shift

                                                </option>


                                                <option value="morning">

                                                    Morning Shift

                                                </option>


                                                <option value="afternoon">

                                                    Afternoon Shift

                                                </option>


                                                <option value="evening">

                                                    Evening Shift

                                                </option>


                                                <option value="full-day">

                                                    Full Day

                                                </option>


                                            </select>

                                        </div>

                                    </div>



                                    <!-- POS -->

                                    <div class="form-group">

                                        <label for="posId">

                                            Counter / POS ID
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-desktop"></i>


                                            <input
                                                type="text"
                                                id="posId"
                                                name="posId"
                                                class="form-control"
                                                placeholder="CASH-01"
                                                >

                                        </div>

                                    </div>


                                </div>

                            </section>



                            <!-- =================================================
                                 ADMIN
                            ================================================== -->

                            <section id="adminFields"
                                     class="form-section role-fields">


                                <div class="section-title">

                                    <i class="fa-solid fa-user-shield"></i>

                                    Administrator Information

                                </div>


                                <div class="form-grid">


                                    <!-- EMPLOYEE -->

                                    <div class="form-group">

                                        <label for="adminEmployeeId">

                                            Employee ID
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-id-badge"></i>


                                            <input
                                                type="text"
                                                id="adminEmployeeId"
                                                name="adminEmployeeId"
                                                class="form-control"
                                                placeholder="Enter employee ID"
                                                >

                                        </div>

                                    </div>



                                    <!-- DEPARTMENT -->

                                    <div class="form-group">

                                        <label for="adminDepartment">

                                            Department
                                            <span class="required">*</span>

                                        </label>


                                        <div class="input-wrapper">

                                            <i class="fa-solid fa-building"></i>


                                            <select
                                                id="adminDepartment"
                                                name="adminDepartment"
                                                class="form-control"
                                                >

                                                <option value="">

                                                    Select Department

                                                </option>


                                                <option value="administration">

                                                    Administration

                                                </option>


                                                <option value="management">

                                                    Management

                                                </option>


                                                <option value="it">

                                                    IT

                                                </option>


                                                <option value="finance">

                                                    Finance

                                                </option>



                                            </select>

                                        </div>

                                    </div>


                                </div>

                            </section>


                        </div>



                        <!-- =================================================
                             SECURITY
                        ================================================== -->

                        <section class="form-section">


                            <div class="section-title">

                                <i class="fa-solid fa-lock"></i>

                                Account Security

                            </div>


                            <div class="form-grid">


                                <!-- PASSWORD -->

                                <div class="form-group">

                                    <label for="password">

                                        Password
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper password-wrapper">

                                        <i class="fa-solid fa-lock"></i>


                                        <input
                                            type="password"
                                            id="password"
                                            name="password"
                                            class="form-control"
                                            placeholder="Create password"
                                            minlength="8"
                                            required
                                            >


                                        <button
                                            type="button"
                                            class="password-toggle"
                                            onclick="togglePassword(
                                                            'password',
                                                            this
                                                            )">

                                            <i class="fa-solid fa-eye"></i>

                                        </button>

                                    </div>

                                </div>



                                <!-- CONFIRM -->

                                <div class="form-group">

                                    <label for="confirmPassword">

                                        Confirm Password
                                        <span class="required">*</span>

                                    </label>


                                    <div class="input-wrapper password-wrapper">

                                        <i class="fa-solid fa-lock"></i>


                                        <input
                                            type="password"
                                            id="confirmPassword"
                                            name="confirmPassword"
                                            class="form-control"
                                            placeholder="Confirm password"
                                            minlength="8"
                                            required
                                            >


                                        <button
                                            type="button"
                                            class="password-toggle"
                                            onclick="togglePassword(
                                                            'confirmPassword',
                                                            this
                                                            )">

                                            <i class="fa-solid fa-eye"></i>

                                        </button>

                                    </div>

                                </div>


                            </div>

                        </section>



                        <!-- =================================================
                             TERMS
                        ================================================== -->

                        <div class="terms">


                            <input
                                type="checkbox"
                                id="terms"
                                name="terms"
                                value="accepted"
                                required
                                >


                            <label for="terms">

                                I agree to the

                                <a href="#">
                                    Terms & Conditions
                                </a>

                                and

                                <a href="#">
                                    Privacy Policy
                                </a>

                                of Sunrise Dental Clinic.

                            </label>


                        </div>



                        <!-- =================================================
                             CREATE ACCOUNT
                        ================================================== -->

                        <button
                            type="submit"
                            class="signup-btn"
                            id="signupButton">

                            <i class="fa-solid fa-user-plus"></i>

                            Create Patient Account

                        </button>



                        <!-- LOGIN -->

                        <div class="login-text">

                            Already have an account?

                            <a href="Login.jsp">

                                Login here

                            </a>

                        </div>



                        <!-- BACK HOME -->

                        <div class="back-home">

                            <a href="Index.jsp">

                                <i class="fa-solid fa-arrow-left"></i>

                                Back to Home

                            </a>

                        </div>


                    </form>


                </main>


            </div>

        </div>



        <!-- =========================================================
             JAVASCRIPT
        ========================================================= -->

        <script>


            /* =========================================================
             CHANGE ROLE
             ========================================================= */

            function changeRole() {


                const role =
                        document.getElementById("role").value;


                const patient =
                        document.getElementById(
                                "patientFields"
                                );


                const doctor =
                        document.getElementById(
                                "doctorFields"
                                );


                const cashier =
                        document.getElementById(
                                "cashierFields"
                                );


                const admin =
                        document.getElementById(
                                "adminFields"
                                );


                const button =
                        document.getElementById(
                                "signupButton"
                                );


                /* -----------------------------------------
                 Hide all sections
                 ----------------------------------------- */

                patient.classList.remove("active");

                doctor.classList.remove("active");

                cashier.classList.remove("active");

                admin.classList.remove("active");


                /* -----------------------------------------
                 Remove required fields
                 ----------------------------------------- */

                removeRoleRequiredFields();


                /* -----------------------------------------
                 Selected role
                 ----------------------------------------- */

                if (role === "patient") {


                    patient.classList.add("active");


                    setRequired([
                        "patientDob",
                        "patientGender"
                    ]);


                    button.innerHTML =
                            '<i class="fa-solid fa-user-plus"></i> ' +
                            'Create Patient Account';

                } else if (role === "doctor") {


                    doctor.classList.add("active");


                    setRequired([
                        "doctorLicense",
                        "specialization"
                    ]);


                    button.innerHTML =
                            '<i class="fa-solid fa-user-doctor"></i> ' +
                            'Create Doctor Account';

                } else if (role === "cashier") {


                    cashier.classList.add("active");


                    setRequired([
                        "cashierEmployeeId",
                        "cashierDepartment",
                        "cashierShift",
                        "posId"
                    ]);


                    button.innerHTML =
                            '<i class="fa-solid fa-cash-register"></i> ' +
                            'Create Cashier Account';

                } else if (role === "admin") {


                    admin.classList.add("active");


                    setRequired([
                        "adminEmployeeId",
                        "adminDepartment"
                    ]);


                    button.innerHTML =
                            '<i class="fa-solid fa-user-shield"></i> ' +
                            'Create Admin Account';

                }


                /*
                 * IMPORTANT:
                 * Do NOT use scrollIntoView() here.
                 *
                 * This prevents the page from jumping
                 * when the user changes Signup As.
                 */

            }



            /* =========================================================
             SET REQUIRED
             ========================================================= */

            function setRequired(ids) {


                ids.forEach(function (id) {


                    const field =
                            document.getElementById(id);


                    if (field) {

                        field.required = true;

                    }

                });

            }



            /* =========================================================
             REMOVE REQUIRED
             ========================================================= */

            function removeRoleRequiredFields() {


                const ids = [

                    "patientDob",

                    "patientGender",

                    "doctorLicense",

                    "specialization",

                    "cashierEmployeeId",

                    "cashierDepartment",

                    "cashierShift",

                    "posId",

                    "adminEmployeeId",

                    "adminDepartment"

                ];


                ids.forEach(function (id) {


                    const field =
                            document.getElementById(id);


                    if (field) {

                        field.required = false;

                    }

                });

            }



            /* =========================================================
             PASSWORD SHOW / HIDE
             ========================================================= */

            function togglePassword(
                    inputId,
                    button
                    ) {


                const input =
                        document.getElementById(
                                inputId
                                );


                const icon =
                        button.querySelector("i");


                if (
                        input.type === "password"
                        ) {


                    input.type = "text";


                    icon.classList.remove(
                            "fa-eye"
                            );


                    icon.classList.add(
                            "fa-eye-slash"
                            );


                } else {


                    input.type = "password";


                    icon.classList.remove(
                            "fa-eye-slash"
                            );


                    icon.classList.add(
                            "fa-eye"
                            );

                }

            }



            /* =========================================================
             FORM VALIDATION
             ========================================================= */

            document
                    .getElementById("signupForm")
                    .addEventListener(
                            "submit",
                            function (event) {


                                const password =
                                        document.getElementById(
                                                "password"
                                                ).value;


                                const confirmPassword =
                                        document.getElementById(
                                                "confirmPassword"
                                                ).value;


                                /* -----------------------------------------
                                 Password length
                                 ----------------------------------------- */

                                if (
                                        password.length < 8
                                        ) {


                                    event.preventDefault();


                                    alert(
                                            "Password must contain at least 8 characters."
                                            );


                                    document
                                            .getElementById("password")
                                            .focus();


                                    return;

                                }


                                /* -----------------------------------------
                                 Password match
                                 ----------------------------------------- */

                                if (
                                        password !==
                                        confirmPassword
                                        ) {


                                    event.preventDefault();


                                    alert(
                                            "Passwords do not match."
                                            );


                                    document
                                            .getElementById(
                                                    "confirmPassword"
                                                    )
                                            .focus();


                                    return;

                                }


                                /*
                                 * If everything is correct,
                                 * form will submit to:
                                 *
                                 * SignupServlet
                                 */

                            }
                    );



            /* =========================================================
             INITIAL ROLE
             ========================================================= */

            document.addEventListener(
                    "DOMContentLoaded",
                    function () {

                        changeRole();

                    }
            );


        </script>

        <jsp:include page="toast.jsp" />

    </body>

</html>
