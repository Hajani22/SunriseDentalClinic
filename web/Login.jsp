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

                --danger: #dc3545;

                --success: #198754;

            }


            /* =====================================================
               RESET
            ===================================================== */

            * {

                margin: 0;

                padding: 0;

                box-sizing: border-box;

            }


            html,
            body {

                width: 100%;

                height: 100%;

            }


            body {

                font-family: "Open Sans", sans-serif;

                background: #f4f8fb;

                color: var(--text);

                overflow: hidden;

            }


            a {

                text-decoration: none;

            }


            /* =====================================================
               MAIN PAGE
            ===================================================== */

            .login-page {

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

            .login-wrapper {

                width: 100%;

                max-width: 1700px;

                height: calc(100vh - 32px);

                display: grid;

                grid-template-columns: 35% 65%;

                background: var(--white);

                border-radius: 18px;

                overflow: hidden;

                box-shadow:
                    0 20px 55px rgba(0,0,0,0.25);

            }


            /* =====================================================
               LEFT PANEL
            ===================================================== */

            .login-left {

                min-width: 0;

                height: 100%;

                padding: 40px 45px;

                background:

                    linear-gradient(
                    rgba(6, 163, 218, 0.90),
                    rgba(9, 30, 62, 0.94)
                    ),

                    url("https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=1000&q=85");

                background-size: cover;

                background-position: center;

                color: white;

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

                width: 60px;

                height: 60px;

                border-radius: 14px;

                background: white;

                color: var(--primary);

                display: flex;

                align-items: center;

                justify-content: center;

                font-size: 28px;

                flex-shrink: 0;

            }


            .brand-text strong {

                display: block;

                font-family: "Jost", sans-serif;

                font-size: 28px;

                line-height: 1.1;

            }


            .brand-text span {

                display: block;

                font-size: 13px;

                margin-top: 5px;

                opacity: 0.9;

            }


            /* =====================================================
               LEFT CONTENT
            ===================================================== */

            .left-content {

                margin-top: 55px;

            }


            .left-content .tag {

                display: inline-flex;

                align-items: center;

                gap: 7px;

                background: rgba(255,255,255,0.15);

                padding: 9px 17px;

                border-radius: 30px;

                font-size: 13px;

                font-weight: 700;

                letter-spacing: 0.5px;

                margin-bottom: 27px;

            }


            .left-content h1 {

                font-family: "Jost", sans-serif;

                font-size: clamp(38px, 3.2vw, 58px);

                line-height: 1.08;

                margin-bottom: 27px;

                color: white;

            }


            .left-content p {

                max-width: 480px;

                line-height: 1.75;

                font-size: 16px;

                opacity: 0.92;

            }


            /* =====================================================
               BENEFITS
            ===================================================== */

            .benefits {

                margin-top: 40px;

            }


            .benefit {

                display: flex;

                align-items: center;

                gap: 14px;

                margin-bottom: 17px;

            }


            .benefit i {

                width: 43px;

                height: 43px;

                border-radius: 50%;

                background: rgba(255,255,255,0.16);

                display: flex;

                align-items: center;

                justify-content: center;

                color: white;

                flex-shrink: 0;

            }


            .benefit span {

                font-size: 15px;

            }


            .left-footer {

                font-size: 12px;

                opacity: 0.75;

            }


            /* =====================================================
               RIGHT PANEL
            ===================================================== */

            .login-right {

                min-width: 0;

                height: 100%;

                padding: 40px 70px;

                background: white;

                overflow-y: auto;

                overflow-x: hidden;

                scrollbar-width: thin;

            }


            .login-right::-webkit-scrollbar {

                width: 7px;

            }


            .login-right::-webkit-scrollbar-track {

                background: #f5f5f5;

            }


            .login-right::-webkit-scrollbar-thumb {

                background: #b7c3cc;

                border-radius: 10px;

            }


            .login-right::-webkit-scrollbar-thumb:hover {

                background: var(--primary);

            }


            /* =====================================================
               CONTENT
            ===================================================== */

            .login-content {

                width: 100%;

                max-width: 650px;

                margin: 0 auto;

            }


            /* =====================================================
               HEADER
            ===================================================== */

            .login-header {

                margin-bottom: 25px;

            }


            .login-header h2 {

                font-family: "Jost", sans-serif;

                color: var(--dark);

                font-size: 40px;

                line-height: 1.15;

                margin-bottom: 8px;

            }


            .login-header p {

                color: #777;

                font-size: 14px;

                line-height: 1.6;

            }


            /* =====================================================
               ACCOUNT TYPE
            ===================================================== */

            .role-title {

                color: var(--dark);

                font-size: 14px;

                font-weight: 700;

                margin-bottom: 10px;

            }


            .role-selector {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 10px;

                margin-bottom: 25px;

            }


            .role-option {

                position: relative;

            }


            .role-option input {

                display: none;

            }


            .role-option label {

                min-height: 82px;

                border: 1.5px solid var(--border);

                border-radius: 11px;

                display: flex;

                flex-direction: column;

                align-items: center;

                justify-content: center;

                color: #777;

                font-size: 12px;

                font-weight: 600;

                cursor: pointer;

                transition: 0.25s;

                user-select: none;

            }


            .role-option label i {

                font-size: 21px;

                margin-bottom: 6px;

            }


            .role-option input:checked + label {

                border-color: var(--primary);

                background: var(--light);

                color: var(--primary);

                box-shadow:
                    0 6px 17px rgba(6,163,218,0.12);

            }


            .role-option label:hover {

                border-color: var(--primary);

            }


            /* =====================================================
               FORM
            ===================================================== */

            .form-group {

                margin-bottom: 18px;

            }


            .form-group label {

                display: block;

                color: var(--dark);

                font-size: 13px;

                font-weight: 700;

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

                color: #9aa7b3;

                font-size: 15px;

                pointer-events: none;

            }


            .form-control {

                width: 100%;

                min-height: 53px;

                border: 1px solid var(--border);

                border-radius: 10px;

                padding: 13px 50px;

                outline: none;

                background: white;

                color: #333;

                font-family: "Open Sans", sans-serif;

                font-size: 14px;

                transition: 0.25s;

            }


            .form-control:focus {

                border-color: var(--primary);

                box-shadow:
                    0 0 0 3px rgba(6,163,218,0.10);

            }


            /* =====================================================
               PASSWORD
            ===================================================== */

            .password-toggle {

                position: absolute;

                right: 15px;

                top: 50%;

                transform: translateY(-50%);

                border: none;

                background: transparent;

                color: #8995a0;

                cursor: pointer;

                font-size: 15px;

            }


            /* =====================================================
               OPTIONS
            ===================================================== */

            .login-options {

                display: flex;

                align-items: center;

                justify-content: space-between;

                margin: 4px 0 20px;

                font-size: 12px;

            }


            .remember {

                display: flex;

                align-items: center;

                gap: 8px;

                color: #666;

            }


            .remember input {

                width: 15px;

                height: 15px;

                accent-color: var(--primary);

            }


            .forgot-password {

                color: var(--primary);

                font-weight: 600;

            }


            .forgot-password:hover {

                text-decoration: underline;

            }


            /* =====================================================
               LOGIN BUTTON
            ===================================================== */

            .login-btn {

                width: 100%;

                min-height: 53px;

                border: none;

                border-radius: 9px;

                background: var(--primary);

                color: white;

                padding: 13px;

                font-family: "Jost", sans-serif;

                font-size: 17px;

                font-weight: 700;

                cursor: pointer;

                transition: 0.25s;

            }


            .login-btn:hover {

                background: var(--primary-dark);

                transform: translateY(-1px);

                box-shadow:
                    0 8px 20px rgba(6,163,218,0.25);

            }


            /* =====================================================
               SIGNUP LINK
            ===================================================== */

            .signup-text {

                text-align: center;

                margin-top: 18px;

                color: #777;

                font-size: 13px;

            }


            .signup-text a {

                color: var(--primary);

                font-weight: 700;

            }


            .signup-text a:hover {

                text-decoration: underline;

            }


            /* =====================================================
               BACK HOME
            ===================================================== */

            .back-home {

                text-align: center;

                margin-top: 10px;

            }


            .back-home a {

                color: #777;

                font-size: 12px;

            }


            .back-home a:hover {

                color: var(--primary);

            }


            /* =====================================================
               MESSAGE
            ===================================================== */

            .login-message {

                display: none;

                border-radius: 8px;

                padding: 11px 13px;

                margin-bottom: 18px;

                font-size: 13px;

            }


            .login-message.error {

                display: block;

                background: #fff1f2;

                border: 1px solid #fecdd3;

                color: var(--danger);

            }


            /* =====================================================
               DESKTOP HEIGHT
            ===================================================== */

            @media
            (min-width: 851px)
            and (max-height: 800px) {

                .login-right {

                    padding-top: 25px;

                    padding-bottom: 20px;

                }


                .login-header {

                    margin-bottom: 18px;

                }


                .login-header h2 {

                    font-size: 35px;

                }


                .role-selector {

                    margin-bottom: 17px;

                }


                .role-option label {

                    min-height: 70px;

                }


                .form-group {

                    margin-bottom: 13px;

                }


                .form-control {

                    min-height: 47px;

                }


                .login-options {

                    margin-bottom: 15px;

                }


                .login-btn {

                    min-height: 47px;

                }

            }


            /* =====================================================
               TABLET
            ===================================================== */

            @media (max-width: 1100px) {

                .login-wrapper {

                    grid-template-columns: 38% 62%;

                }


                .login-left {

                    padding: 35px 30px;

                }


                .login-right {

                    padding: 35px 40px;

                }


                .login-header h2 {

                    font-size: 35px;

                }


                .role-selector {

                    grid-template-columns:
                        repeat(2, 1fr);

                }

            }


            /* =====================================================
               MOBILE
            ===================================================== */

            @media (max-width: 850px) {

                body {

                    overflow-x: hidden;

                    overflow-y: auto;

                }


                .login-page {

                    height: auto;

                    min-height: 100vh;

                    overflow: visible;

                    padding: 10px;

                }


                .login-wrapper {

                    height: auto;

                    grid-template-columns: 1fr;

                    max-width: 700px;

                }


                .login-left {

                    min-height: 400px;

                    height: auto;

                }


                .login-right {

                    height: auto;

                    overflow: visible;

                    padding: 35px 30px;

                }

            }


            /* =====================================================
               SMALL MOBILE
            ===================================================== */

            @media (max-width: 600px) {

                .login-page {

                    padding: 0;

                }


                .login-wrapper {

                    border-radius: 0;

                }


                .login-left {

                    min-height: 350px;

                    padding: 30px 24px;

                }


                .brand-icon {

                    width: 55px;

                    height: 55px;

                    font-size: 25px;

                }


                .brand-text strong {

                    font-size: 25px;

                }


                .left-content {

                    margin-top: 35px;

                }


                .left-content h1 {

                    font-size: 34px;

                }


                .left-content p {

                    font-size: 14px;

                }


                .benefits {

                    margin-top: 25px;

                }


                .benefit span {

                    font-size: 13px;

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

        </style>

    
<style id="toastStyles">
.toast-box{position:fixed;top:24px;right:24px;z-index:99999;min-width:300px;max-width:430px;padding:16px 20px;border-radius:12px;color:#fff;font:600 14px/1.45 "Open Sans",sans-serif;box-shadow:0 12px 35px rgba(0,0,0,.25);opacity:0;transform:translateY(-12px);transition:.3s ease}.toast-box.show{opacity:1;transform:translateY(0)}.toast-success{background:#198754}.toast-error{background:#dc3545}.toast-info{background:#06a3da}
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


    
<div id="appToast" class="toast-box"></div>
<script>
(function(){
 const p=new URLSearchParams(window.location.search), toast=document.getElementById('appToast');
 const success=p.get('success'), error=p.get('error'); let msg='', type='error';
 if(success==='registered'){msg='Account created successfully. Please sign in.';type='success';}
 else if(success==='logout'){msg='You have signed out successfully.';type='success';}
 else if(error==='empty') msg='Please complete all required fields.';
 else if(error==='invalid') msg='Invalid email, password, or account type.';
 else if(error==='role') msg='Please select the correct account type.';
 if(msg){toast.textContent=msg;toast.classList.add('toast-'+type);requestAnimationFrame(()=>toast.classList.add('show'));setTimeout(()=>toast.classList.remove('show'),4500);history.replaceState({},document.title,location.pathname);}
})();
</script>
</body>

</html>