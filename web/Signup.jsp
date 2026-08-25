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

            /* =====================================================
               ROOT
            ===================================================== */

            :root {

                --primary: #06a3da;

                --primary-dark: #058fbe;

                --light: #eef9ff;

                --dark: #091e3e;

                --text: #555;

                --border: #dce4ea;

                --white: #ffffff;

                --success: #198754;

                --danger: #dc3545;

            }


            /* =====================================================
               RESET
            ===================================================== */

            * {

                margin: 0;

                padding: 0;

                box-sizing: border-box;

            }


            html {

                width: 100%;

                height: 100%;

            }


            body {

                width: 100%;

                height: 100%;

                margin: 0;

                font-family: "Open Sans", sans-serif;

                background: #f4f8fb;

                color: var(--text);

                overflow: hidden;

            }


            a {

                text-decoration: none;

            }


            button,
            input,
            select {

                font-family: inherit;

            }


            /* =====================================================
               MAIN PAGE
            ===================================================== */

            .signup-page {

                width: 100%;

                height: 100vh;

                padding: 16px;

                display: flex;

                align-items: center;

                justify-content: center;

                overflow: hidden;

                background:

                    linear-gradient(
                    rgba(9, 30, 62, 0.82),
                    rgba(9, 30, 62, 0.82)
                    ),

                    url("https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&w=1800&q=85");

                background-size: cover;

                background-position: center;

            }


            /* =====================================================
               MAIN CONTAINER
            ===================================================== */

            .signup-wrapper {

                width: 100%;

                max-width: 1700px;

                height: calc(100vh - 32px);

                display: grid;

                grid-template-columns: 35% 65%;

                background: white;

                border-radius: 18px;

                overflow: hidden;

                box-shadow:
                    0 20px 55px rgba(0,0,0,0.25);

            }


            /* =====================================================
               LEFT PANEL
               FIXED
            ===================================================== */

            .signup-left {

                height: 100%;

                min-width: 0;

                padding: 45px;

                color: white;

                background:

                    linear-gradient(
                    rgba(6,163,218,0.90),
                    rgba(9,30,62,0.94)
                    ),

                    url("https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=1000&q=85");

                background-size: cover;

                background-position: center;

                display: flex;

                flex-direction: column;

                justify-content: space-between;

                overflow: hidden;

            }


            /* =====================================================
               BRAND
            ===================================================== */

            .brand {

                display: flex;

                align-items: center;

                gap: 13px;

                color: white;

            }


            .brand-icon {

                width: 50px;

                height: 50px;

                border-radius: 12px;

                background: white;

                color: var(--primary);

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 24px;

            }


            .brand-text strong {

                display: block;

                font-family: "Jost", sans-serif;

                font-size: 23px;

            }


            .brand-text span {

                font-size: 12px;

                opacity: 0.85;

            }


            /* =====================================================
               LEFT CONTENT
            ===================================================== */

            .left-content {

                margin-top: 65px;

            }


            .left-tag {

                display: inline-block;

                padding: 7px 14px;

                border-radius: 30px;

                background: rgba(255,255,255,0.15);

                font-size: 12px;

                font-weight: 700;

                letter-spacing: 0.7px;

                margin-bottom: 20px;

            }


            .left-content h1 {

                font-family: "Jost", sans-serif;

                font-size: 43px;

                line-height: 1.15;

                margin-bottom: 18px;

            }


            .left-content p {

                font-size: 15px;

                line-height: 1.7;

                opacity: 0.9;

            }


            /* =====================================================
               BENEFITS
            ===================================================== */

            .benefits {

                margin-top: 35px;

            }


            .benefit {

                display: flex;

                align-items: center;

                gap: 13px;

                margin-bottom: 17px;

            }


            .benefit i {

                width: 35px;

                height: 35px;

                border-radius: 50%;

                background: rgba(255,255,255,0.15);

                display: flex;

                align-items: center;

                justify-content: center;

                flex-shrink: 0;

            }


            .benefit span {

                font-size: 14px;

            }


            .left-footer {

                font-size: 12px;

                opacity: 0.75;

            }


            /* =====================================================
               RIGHT PANEL
               ONLY THIS PANEL SCROLLS
            ===================================================== */

            .signup-right {

                height: 100%;

                min-width: 0;

                padding: 35px 65px;

                background: white;

                overflow-x: hidden;

                overflow-y: auto;

                scrollbar-width: thin;

            }


            /* Chrome scrollbar */

            .signup-right::-webkit-scrollbar {

                width: 7px;

            }


            .signup-right::-webkit-scrollbar-track {

                background: #f5f5f5;

            }


            .signup-right::-webkit-scrollbar-thumb {

                background: #b7c3cc;

                border-radius: 10px;

            }


            .signup-right::-webkit-scrollbar-thumb:hover {

                background: var(--primary);

            }


            /* =====================================================
               HEADER
            ===================================================== */

            .signup-header {

                margin-bottom: 22px;

            }


            .signup-header h2 {

                font-family: "Jost", sans-serif;

                color: var(--dark);

                font-size: 36px;

                line-height: 1.15;

                margin-bottom: 7px;

            }


            .signup-header p {

                font-size: 14px;

                color: #777;

            }


            /* =====================================================
               SIGNUP AS
            ===================================================== */

            .signup-as {

                margin-bottom: 22px;

            }


            .signup-as label {

                display: block;

                color: var(--dark);

                font-size: 15px;

                font-weight: 700;

                margin-bottom: 8px;

            }


            .signup-role {

                width: 100%;

                height: 52px;

                padding: 0 15px;

                border: 1px solid #8fdcff;

                border-radius: 5px;

                background: white;

                color: #555;

                font-size: 17px;

                outline: none;

                cursor: pointer;

            }


            .signup-role:focus {

                border-color: var(--primary);

                box-shadow:
                    0 0 0 3px rgba(6,163,218,0.12);

            }


            /* =====================================================
               FORM
            ===================================================== */

            .form-section {

                margin-bottom: 19px;

            }


            .section-title {

                display: flex;

                align-items: center;

                gap: 9px;

                color: var(--dark);

                font-family: "Jost", sans-serif;

                font-size: 18px;

                margin-bottom: 13px;

                padding-bottom: 8px;

                border-bottom: 1px solid #edf0f3;

            }


            .section-title i {

                color: var(--primary);

            }


            /* =====================================================
               FORM GRID
            ===================================================== */

            .form-grid {

                display: grid;

                grid-template-columns:
                    repeat(2, minmax(0,1fr));

                gap: 13px 22px;

            }


            .form-group {

                min-width: 0;

            }


            .form-group label {

                display: block;

                color: var(--dark);

                font-size: 12px;

                font-weight: 700;

                margin-bottom: 5px;

            }


            .required {

                color: var(--danger);

            }


            /* =====================================================
               INPUT
            ===================================================== */

            .input-wrapper {

                position: relative;

            }


            .input-wrapper > i {

                position: absolute;

                left: 14px;

                top: 50%;

                transform: translateY(-50%);

                color: #9aa7b3;

                font-size: 14px;

                pointer-events: none;

            }


            .form-control {

                width: 100%;

                height: 48px;

                border: 1px solid var(--border);

                border-radius: 8px;

                padding: 10px 13px 10px 40px;

                background: white;

                color: #333;

                font-size: 13px;

                outline: none;

                transition: 0.2s;

            }


            .form-control:focus {

                border-color: var(--primary);

                box-shadow:
                    0 0 0 3px rgba(6,163,218,0.10);

            }


            select.form-control {

                cursor: pointer;

            }


            /* =====================================================
               ROLE AREA
               
               IMPORTANT:
               Fixed minimum height prevents the page from
               jumping when changing Patient/Doctor/Cashier/Admin.
            ===================================================== */

            .role-area {

                min-height: 165px;

                position: relative;

            }


            .role-fields {

                display: none;

            }


            .role-fields.active {

                display: block;

            }


            /* =====================================================
               PASSWORD
            ===================================================== */

            .password-wrapper .form-control {

                padding-right: 43px;

            }


            .password-toggle {

                position: absolute;

                right: 12px;

                top: 50%;

                transform: translateY(-50%);

                border: none;

                background: transparent;

                color: #8995a0;

                cursor: pointer;

            }


            /* =====================================================
               TERMS
            ===================================================== */

            .terms {

                display: flex;

                align-items: flex-start;

                gap: 9px;

                margin: 8px 0 14px;

                font-size: 12px;

                line-height: 1.5;

            }


            .terms input {

                margin-top: 3px;

                accent-color: var(--primary);

            }


            .terms a {

                color: var(--primary);

                font-weight: 600;

            }


            /* =====================================================
               BUTTON
            ===================================================== */

            .signup-btn {

                width: 100%;

                min-height: 50px;

                border: none;

                border-radius: 8px;

                background: var(--primary);

                color: white;

                font-family: "Jost", sans-serif;

                font-size: 16px;

                font-weight: 700;

                cursor: pointer;

                transition: 0.2s;

            }


            .signup-btn:hover {

                background: var(--primary-dark);

                box-shadow:
                    0 8px 20px rgba(6,163,218,0.25);

            }


            /* =====================================================
               LOGIN
            ===================================================== */

            .login-text {

                text-align: center;

                margin-top: 12px;

                font-size: 13px;

                color: #777;

            }


            .login-text a {

                color: var(--primary);

                font-weight: 700;

            }


            /* =====================================================
               BACK HOME
            ===================================================== */

            .back-home {

                text-align: center;

                margin-top: 7px;

            }


            .back-home a {

                color: #777;

                font-size: 12px;

            }


            .back-home a:hover {

                color: var(--primary);

            }


            /* =====================================================
               SUCCESS
            ===================================================== */

            .success-message {

                display: none;

                background: #e9f8ef;

                border: 1px solid #b7e4c7;

                color: var(--success);

                border-radius: 8px;

                padding: 11px;

                margin-bottom: 15px;

                font-size: 13px;

            }


            /* =====================================================
               DESKTOP
            ===================================================== */

            @media (min-width: 851px) {

                body {

                    overflow: hidden;

                }


                .signup-wrapper {

                    grid-template-columns: 35% 65%;

                }


                .signup-left {

                    position: relative;

                }


                .signup-right {

                    overflow-y: auto;

                    overscroll-behavior: contain;

                }

            }


            /* =====================================================
               SMALL DESKTOP
            ===================================================== */

            @media (min-width: 851px)
            and (max-height: 800px) {

                .signup-right {

                    padding-top: 25px;

                    padding-bottom: 20px;

                }


                .signup-header {

                    margin-bottom: 17px;

                }


                .signup-header h2 {

                    font-size: 32px;

                }


                .signup-as {

                    margin-bottom: 17px;

                }


                .role-area {

                    min-height: 155px;

                }


                .form-section {

                    margin-bottom: 15px;

                }


                .form-control {

                    height: 45px;

                }


                .signup-btn {

                    min-height: 47px;

                }

            }


            /* =====================================================
               TABLET
            ===================================================== */

            @media (max-width: 850px) {

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

                }


                .signup-left {

                    min-height: 420px;

                    height: auto;

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


            /* =====================================================
               MOBILE
            ===================================================== */

            @media (max-width: 600px) {

                .signup-page {

                    padding: 0;

                }


                .signup-wrapper {

                    border-radius: 0;

                }


                .signup-left {

                    min-height: 380px;

                    padding: 30px 24px;

                }


                .left-content {

                    margin-top: 40px;

                }


                .left-content h1 {

                    font-size: 34px;

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

        </style>

    
<style id="toastStyles">
.toast-box{position:fixed;top:24px;right:24px;z-index:99999;min-width:300px;max-width:430px;padding:16px 20px;border-radius:12px;color:#fff;font:600 14px/1.45 "Open Sans",sans-serif;box-shadow:0 12px 35px rgba(0,0,0,.25);opacity:0;transform:translateY(-12px);transition:.3s ease}.toast-box.show{opacity:1;transform:translateY(0)}.toast-success{background:#198754}.toast-error{background:#dc3545}.toast-info{background:#06a3da}
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


    
<div id="appToast" class="toast-box"></div>
<script>
(function(){
 const p=new URLSearchParams(window.location.search), toast=document.getElementById('appToast'), e=p.get('error');
 const messages={empty:'Please complete all required fields and accept the terms.',shortpassword:'Password must contain at least 8 characters.',password:'Passwords do not match.',role:'Please select a valid account type.',experience:'Please enter valid years of experience.',invaliddata:'Please check the information you entered.',registration:'Unable to create this account. The email may already be registered.',server:'Unable to create the account right now. Please try again.'};
 if(e&&messages[e]){toast.textContent=messages[e];toast.classList.add('toast-error');requestAnimationFrame(()=>toast.classList.add('show'));setTimeout(()=>toast.classList.remove('show'),4500);history.replaceState({},document.title,location.pathname);}
})();
</script>
</body>

</html>