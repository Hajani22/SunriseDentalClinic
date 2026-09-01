<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">
        <title>Login | Sunrise Dental Clinic</title>


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
               PROFESSIONAL LOGIN UI
               Layout preserved - visual upgrade only
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
                --danger: #dc3545;
                --success: #198754;

                --shadow: 0 25px 70px rgba(16, 47, 67, .18);
                --soft-shadow: 0 10px 30px rgba(16, 47, 67, .08);
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
            input {
                font-family: inherit;
            }

            /* =========================================================
               MAIN PAGE
               ========================================================= */

            .login-page {
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
                    rgba(7, 49, 68, .91),
                    rgba(8, 127, 168, .72)
                    ),
                    url("https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&w=1800&q=90");

                background-size: cover;
                background-position: center;
            }

            /* =========================================================
               MAIN CONTAINER
               ========================================================= */

            .login-wrapper {
                width: 100%;
                max-width: 1500px;
                height: calc(100vh - 36px);

                display: grid;
                grid-template-columns: 38% 62%;

                background: var(--white);
                border-radius: 24px;
                overflow: hidden;

                box-shadow: var(--shadow);

                border: 1px solid rgba(255,255,255,.35);
            }

            /* =========================================================
               LEFT PANEL
               ========================================================= */

            .login-left {
                min-width: 0;
                height: 100%;

                padding: 42px 48px;

                position: relative;

                background:
                    linear-gradient(
                    145deg,
                    rgba(5, 125, 161, .91),
                    rgba(9, 40, 58, .97)
                    ),
                    url("https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=1200&q=90");

                background-size: cover;
                background-position: center;

                color: white;

                display: flex;
                flex-direction: column;
                justify-content: space-between;

                overflow: hidden;
            }

            /* Decorative circles */

            .login-left::before {
                content: "";
                position: absolute;

                width: 380px;
                height: 380px;

                right: -210px;
                top: -150px;

                border-radius: 50%;

                border: 1px solid rgba(255,255,255,.12);
            }

            .login-left::after {
                content: "";
                position: absolute;

                width: 260px;
                height: 260px;

                left: -150px;
                bottom: -130px;

                border-radius: 50%;

                border: 1px solid rgba(255,255,255,.10);
            }

            .login-left > * {
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

                color: white;
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

                font-size: 11px;
                margin-top: 5px;

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

            .left-content .tag {
                display: inline-flex;
                align-items: center;
                gap: 8px;

                padding: 8px 14px;

                border-radius: 999px;

                background: rgba(255,255,255,.12);
                border: 1px solid rgba(255,255,255,.15);

                font-size: 10px;
                font-weight: 800;

                letter-spacing: 1.2px;

                margin-bottom: 22px;

                backdrop-filter: blur(8px);
            }

            .left-content .tag i {
                color: #86eee1;
            }

            .left-content h1 {
                font-family: "Jost", sans-serif;

                font-size: clamp(38px, 3.3vw, 57px);

                line-height: 1.04;

                margin-bottom: 21px;

                color: white;

                letter-spacing: -1.4px;
            }

            .left-content p {
                max-width: 470px;

                line-height: 1.75;

                font-size: 14px;

                color: rgba(255,255,255,.82);
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

                background: rgba(255,255,255,.10);

                border: 1px solid rgba(255,255,255,.10);

                display: flex;
                align-items: center;
                justify-content: center;

                color: #9ef1e5;

                flex-shrink: 0;

                font-size: 14px;
            }

            .benefit span {
                font-size: 13px;
                color: rgba(255,255,255,.88);
            }

            .left-footer {
                font-size: 11px;
                opacity: .62;
            }

            /* =========================================================
               RIGHT PANEL
               ========================================================= */

            .login-right {
                min-width: 0;
                height: 100%;

                padding: 42px 70px;

                background: #ffffff;

                overflow-y: auto;
                overflow-x: hidden;

                scrollbar-width: thin;
                scrollbar-color: #bfd1d9 transparent;
            }

            .login-right::-webkit-scrollbar {
                width: 6px;
            }

            .login-right::-webkit-scrollbar-track {
                background: transparent;
            }

            .login-right::-webkit-scrollbar-thumb {
                background: #bfd1d9;
                border-radius: 10px;
            }

            .login-right::-webkit-scrollbar-thumb:hover {
                background: var(--primary);
            }

            /* =========================================================
               CONTENT
               ========================================================= */

            .login-content {
                width: 100%;
                max-width: 590px;

                margin: 0 auto;
            }

            /* =========================================================
               HEADER
               ========================================================= */

            .login-header {
                margin-bottom: 24px;
            }

            .login-header h2 {
                font-family: "Jost", sans-serif;

                color: var(--navy);

                font-size: 38px;

                line-height: 1.15;

                margin-bottom: 8px;

                letter-spacing: -.7px;
            }

            .login-header p {
                color: var(--muted);

                font-size: 13px;

                line-height: 1.6;
            }

            /* =========================================================
               ACCOUNT TYPE
               ========================================================= */

            .role-title {
                color: var(--navy);

                font-size: 12px;

                font-weight: 800;

                margin-bottom: 9px;

                text-transform: uppercase;
                letter-spacing: .7px;
            }

            .role-selector {
                display: grid;

                grid-template-columns: repeat(4, 1fr);

                gap: 9px;

                margin-bottom: 23px;
            }

            .role-option {
                position: relative;
            }

            .role-option input {
                display: none;
            }

            .role-option label {
                min-height: 76px;

                border: 1px solid var(--border);

                border-radius: 13px;

                display: flex;
                flex-direction: column;

                align-items: center;
                justify-content: center;

                color: #758792;

                background: #fbfdfe;

                font-size: 11px;

                font-weight: 700;

                cursor: pointer;

                transition:
                    border-color .25s ease,
                    background .25s ease,
                    color .25s ease,
                    transform .25s ease,
                    box-shadow .25s ease;
            }

            .role-option label i {
                font-size: 18px;

                margin-bottom: 6px;

                transition: transform .25s ease;
            }

            .role-option label:hover {
                border-color: #8fcbdc;

                color: var(--primary);

                background: #f5fbfd;

                transform: translateY(-1px);
            }

            .role-option input:checked + label {
                border-color: var(--primary);

                background:
                    linear-gradient(
                    145deg,
                    #effbfe,
                    #e8f8fa
                    );

                color: var(--primary);

                box-shadow:
                    0 8px 20px rgba(8,127,168,.11);
            }

            .role-option input:checked + label i {
                transform: scale(1.08);
            }

            /* =========================================================
               FORM
               ========================================================= */

            .form-group {
                margin-bottom: 17px;
            }

            .form-group label {
                display: block;

                color: var(--navy);

                font-size: 12px;

                font-weight: 800;

                margin-bottom: 7px;
            }

            .required {
                color: var(--danger);
            }

            .input-wrapper {
                position: relative;
            }

            .input-wrapper > i {
                position: absolute;

                left: 16px;
                top: 50%;

                transform: translateY(-50%);

                color: #9aabb4;

                font-size: 14px;

                pointer-events: none;

                transition: color .2s ease;
            }

            .input-wrapper:focus-within > i {
                color: var(--primary);
            }

            .form-control {
                width: 100%;

                min-height: 52px;

                border: 1px solid var(--border);

                border-radius: 11px;

                padding: 12px 48px;

                outline: none;

                background: #fbfdfe;

                color: var(--navy);

                font-family: "Open Sans", sans-serif;

                font-size: 13px;

                transition:
                    border-color .25s ease,
                    background .25s ease,
                    box-shadow .25s ease;
            }

            .form-control::placeholder {
                color: #a8b4bb;
            }

            .form-control:hover {
                border-color: #bdd3dc;
            }

            .form-control:focus {
                background: #fff;

                border-color: var(--primary);

                box-shadow:
                    0 0 0 3px rgba(8,127,168,.09);
            }

            /* =========================================================
               PASSWORD
               ========================================================= */

            .password-toggle {
                position: absolute;

                right: 14px;
                top: 50%;

                transform: translateY(-50%);

                width: 34px;
                height: 34px;

                border: none;

                border-radius: 8px;

                background: transparent;

                color: #8799a4;

                cursor: pointer;

                font-size: 14px;

                display: flex;
                align-items: center;
                justify-content: center;

                transition:
                    color .2s ease,
                    background .2s ease;
            }

            .password-toggle:hover {
                color: var(--primary);

                background: #edf8fb;
            }

            /* =========================================================
               OPTIONS
               ========================================================= */

            .login-options {
                display: flex;

                align-items: center;
                justify-content: space-between;

                margin: 3px 0 19px;

                font-size: 11px;
            }

            .remember {
                display: flex;

                align-items: center;

                gap: 7px;

                color: #6e7e88;

                cursor: pointer;
            }

            .remember input {
                width: 14px;
                height: 14px;

                accent-color: var(--primary);

                cursor: pointer;
            }

            .forgot-password {
                color: var(--primary);

                font-weight: 700;

                transition: color .2s ease;
            }

            .forgot-password:hover {
                color: var(--primary-dark);

                text-decoration: underline;
            }

            /* =========================================================
               LOGIN BUTTON
               ========================================================= */

            .login-btn {
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

                color: white;

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
                    0 10px 24px rgba(8,127,168,.18);

                transition:
                    transform .25s ease,
                    box-shadow .25s ease,
                    filter .25s ease;
            }

            .login-btn:hover {
                transform: translateY(-2px);

                box-shadow:
                    0 14px 30px rgba(8,127,168,.25);

                filter: brightness(1.03);
            }

            .login-btn:active {
                transform: translateY(0);
            }

            /* =========================================================
               SIGNUP
               ========================================================= */

            .signup-text {
                text-align: center;

                margin-top: 18px;

                color: #7b8991;

                font-size: 12px;
            }

            .signup-text a {
                color: var(--primary);

                font-weight: 800;
            }

            .signup-text a:hover {
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

                transition: color .2s ease;
            }

            .back-home a:hover {
                color: var(--primary);
            }

            /* =========================================================
               MESSAGE
               ========================================================= */

            .login-message {
                display: none;

                border-radius: 10px;

                padding: 11px 13px;

                margin-bottom: 17px;

                font-size: 12px;

                line-height: 1.5;
            }

            .login-message.error {
                display: block;

                background: #fff4f5;

                border: 1px solid #ffd3d8;

                color: var(--danger);
            }


            /* =========================================================
               DESKTOP - SHORT HEIGHT
               ========================================================= */

            @media
            (min-width: 851px)
            and (max-height: 800px) {

                .login-left {
                    padding-top: 30px;
                    padding-bottom: 25px;
                }

                .login-right {
                    padding-top: 28px;
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

                .login-header {
                    margin-bottom: 17px;
                }

                .login-header h2 {
                    font-size: 32px;
                }

                .role-selector {
                    margin-bottom: 15px;
                }

                .role-option label {
                    min-height: 62px;
                }

                .form-group {
                    margin-bottom: 11px;
                }

                .form-control {
                    min-height: 45px;
                }

                .login-btn {
                    min-height: 46px;
                }
            }

            /* =========================================================
               TABLET
               ========================================================= */

            @media (max-width: 1100px) {

                .login-wrapper {
                    grid-template-columns: 40% 60%;
                }

                .login-left {
                    padding: 35px 30px;
                }

                .login-right {
                    padding: 35px 40px;
                }

                .login-header h2 {
                    font-size: 34px;
                }

                .role-selector {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            /* =========================================================
               MOBILE
               ========================================================= */

            @media (max-width: 850px) {

                body {
                    overflow-x: hidden;
                    overflow-y: auto;
                }

                .login-page {
                    height: auto;
                    min-height: 100vh;

                    padding: 10px;

                    overflow: visible;
                }

                .login-wrapper {
                    height: auto;

                    grid-template-columns: 1fr;

                    max-width: 700px;

                    border-radius: 20px;
                }

                .login-left {
                    min-height: 390px;

                    height: auto;

                    padding: 32px 28px;
                }

                .login-right {
                    height: auto;

                    overflow: visible;

                    padding: 35px 30px;
                }
            }

            /* =========================================================
               SMALL MOBILE
               ========================================================= */

            @media (max-width: 600px) {

                .login-page {
                    padding: 0;
                }

                .login-wrapper {
                    border-radius: 0;
                }

                .login-left {
                    min-height: 355px;

                    padding: 28px 22px;
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
                    margin-top: 28px;
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

                .login-right {
                    padding: 30px 20px;
                }

                .login-header h2 {
                    font-size: 30px;
                }

                .role-selector {
                    grid-template-columns: 1fr 1fr;
                }

                .role-option label {
                    min-height: 70px;
                }
            }

            /* =========================================================
               ACCESSIBILITY
               ========================================================= */

            @media (prefers-reduced-motion: reduce) {

                *,
                *::before,
                *::after {
                    scroll-behavior: auto !important;
                    transition-duration: .01ms !important;
                    animation-duration: .01ms !important;
                }
            }
        </style>
    </head>



    <body>


        <div class="login-page">


            <div class="login-wrapper">


                <!-- =================================================
                     LEFT PANEL
                ================================================== -->

                <aside class="login-left">


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


                            <span class="tag">

                                <i class="fa-solid fa-shield-heart"></i>

                                SECURE LOGIN

                            </span>


                            <h1>

                                Welcome

                                <br>

                                Back to Your

                                <br>

                                Account

                            </h1>


                            <p>

                                Access the Sunrise Dental Clinic
                                management portal securely.
                                Select your account type and
                                enter your login details.

                            </p>


                            <div class="benefits">


                                <div class="benefit">

                                    <i class="fa-solid fa-lock"></i>

                                    <span>
                                        Secure account access
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
                                        Secure billing and cashier management
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

                <main class="login-right">


                    <div class="login-content">


                        <!-- HEADER -->

                        <div class="login-header">

                            <h2>
                                Welcome Back
                            </h2>


                            <p>
                                Sign in to access your
                                Sunrise Dental Clinic account.
                            </p>

                        </div>



                        <!-- MESSAGE -->

                        <div id="loginMessage"
                             class="login-message">
                        </div>



                        <!-- =================================================
                             ACCOUNT TYPE
                        ================================================== -->

                        <div class="role-title">

                            Select Account Type

                        </div>


                        <div class="role-selector">


                            <!-- PATIENT -->

                            <div class="role-option">


                                <input
                                    type="radio"
                                    id="patientRole"
                                    name="role"
                                    form="loginForm"
                                    value="patient"
                                    checked
                                    >


                                <label for="patientRole">

                                    <i class="fa-solid fa-user"></i>

                                    Patient

                                </label>


                            </div>



                            <!-- DOCTOR -->

                            <div class="role-option">


                                <input
                                    type="radio"
                                    id="doctorRole"
                                    name="role"
                                    form="loginForm"
                                    value="doctor"
                                    >


                                <label for="doctorRole">

                                    <i class="fa-solid fa-user-doctor"></i>

                                    Doctor

                                </label>


                            </div>



                            <!-- CASHIER -->

                            <div class="role-option">


                                <input
                                    type="radio"
                                    id="cashierRole"
                                    name="role"
                                    form="loginForm"
                                    value="cashier"
                                    >


                                <label for="cashierRole">

                                    <i class="fa-solid fa-cash-register"></i>

                                    Cashier

                                </label>


                            </div>



                            <!-- ADMIN -->

                            <div class="role-option">


                                <input
                                    type="radio"
                                    id="adminRole"
                                    name="role"
                                    form="loginForm"
                                    value="admin"
                                    >


                                <label for="adminRole">

                                    <i class="fa-solid fa-user-shield"></i>

                                    Admin

                                </label>


                            </div>


                        </div>



                        <!-- =================================================
                             LOGIN FORM
                        ================================================== -->

                        <form
                            id="loginForm"
                            action="${pageContext.request.contextPath}/LoginServlet"
                            method="post"
                            >



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
                                        autocomplete="email"
                                        required
                                        >


                                </div>


                            </div>



                            <!-- PASSWORD -->

                            <div class="form-group">


                                <label for="password">

                                    Password
                                    <span class="required">*</span>

                                </label>


                                <div class="input-wrapper">


                                    <i class="fa-solid fa-lock"></i>


                                    <input
                                        type="password"
                                        id="password"
                                        name="password"
                                        class="form-control"
                                        placeholder="Enter your password"
                                        autocomplete="current-password"
                                        required
                                        >


                                    <button
                                        type="button"
                                        class="password-toggle"
                                        onclick="togglePassword()"
                                        aria-label="Show password"
                                        >

                                        <i class="fa-solid fa-eye"></i>

                                    </button>


                                </div>


                            </div>



                            <!-- OPTIONS -->

                            <div class="login-options">


                                <label class="remember">


                                    <input
                                        type="checkbox"
                                        id="remember"
                                        name="remember"
                                        >


                                    <span>
                                        Remember me
                                    </span>


                                </label>



                                <a
                                    href="#"
                                    class="forgot-password"
                                    onclick="forgotPassword(event)"
                                    >

                                    Forgot Password?

                                </a>


                            </div>



                            <!-- LOGIN BUTTON -->

                            <button
                                type="submit"
                                class="login-btn"
                                >

                                <i class="fa-solid fa-right-to-bracket"></i>

                                Login

                            </button>



                            <!-- =================================================
                                 SIGNUP LINK
                            ================================================== -->

                            <div class="signup-text">

                                Don't have an account?

                                <a href="Signup.jsp">

                                    Create an account

                                </a>

                            </div>



                            <!-- HOME -->

                            <div class="back-home">


                                <a href="Index.jsp">

                                    <i class="fa-solid fa-arrow-left"></i>

                                    Back to Home

                                </a>


                            </div>


                        </form>


                    </div>


                </main>


            </div>

        </div>



        <script>


            /* =========================================================
             PASSWORD VISIBILITY
             ========================================================= */

            function togglePassword() {


                const password =
                        document.getElementById(
                                "password"
                                );


                const button =
                        document.querySelector(
                                ".password-toggle"
                                );


                const icon =
                        button.querySelector("i");


                if (
                        password.type === "password"
                        ) {


                    password.type = "text";


                    icon.classList.remove(
                            "fa-eye"
                            );


                    icon.classList.add(
                            "fa-eye-slash"
                            );


                    button.setAttribute(
                            "aria-label",
                            "Hide password"
                            );


                } else {


                    password.type = "password";


                    icon.classList.remove(
                            "fa-eye-slash"
                            );


                    icon.classList.add(
                            "fa-eye"
                            );


                    button.setAttribute(
                            "aria-label",
                            "Show password"
                            );

                }

            }



            /* =========================================================
             LOGIN VALIDATION
             ========================================================= */

            document
                    .getElementById("loginForm")
                    .addEventListener(
                            "submit",
                            function (event) {

                                const email =
                                        document
                                        .getElementById("email")
                                        .value
                                        .trim();

                                const password =
                                        document
                                        .getElementById("password")
                                        .value;

                                const role =
                                        document.querySelector(
                                                'input[name="role"]:checked'
                                                );

                                const message =
                                        document.getElementById(
                                                "loginMessage"
                                                );

                                message.style.display = "none";
                                message.className = "login-message";

                                if (!email || !password) {

                                    event.preventDefault();

                                    message.classList.add("error");
                                    message.textContent =
                                            "Please enter your email address and password.";
                                    message.style.display = "block";
                                    return;
                                }

                                if (!role) {

                                    event.preventDefault();

                                    message.classList.add("error");
                                    message.textContent =
                                            "Please select your account type.";
                                    message.style.display = "block";
                                    return;
                                }
                            }
                    );


            /* =========================================================
             FORGOT PASSWORD
             ========================================================= */

            function forgotPassword(event) {


                event.preventDefault();


                alert(
                        "Please contact the Sunrise Dental Clinic administrator to reset your password."
                        );

            }


        </script>

        <jsp:include page="toast.jsp" />

    </body>

</html>