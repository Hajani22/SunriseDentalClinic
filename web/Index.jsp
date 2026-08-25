<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Sunrise Dental Clinic</title>

        <!--Google Fonts-->
        <link rel="preconnect"
              href="https://fonts.googleapis.com">

        <link rel="preconnect"
              href="https://fonts.gstatic.com"
              crossorigin>

        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@500;600;700&family=Open+Sans:wght@400;600&display=swap"
              rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

        <!-- CSS -->
        <link rel="stylesheet"
              href="CSS/Style.css">

    </head>
    <body>
        
             <!--NAVBAR-->
       
        <header class="navbar">
            <a href="Index.jsp"
               class="logo">
                <span class="logo-icon">
                    <i class="fa-solid fa-tooth"></i>
                </span>
                <div class="logo-text">
                    <strong>Sunrise</strong>
                    <small>Dental Clinic</small>
                </div>
            </a>

            <!-- Mobile menu -->
            <button class="menu-btn"
                    type="button"
                    onclick="toggleMenu()">
                <i class="fa-solid fa-bars"></i>
            </button>

            <!-- Navigation -->
            <nav id="mainNav">
                <a href="Index.jsp">
                    Home
                </a>

                <a href="#about">
                    About
                </a>

                <a href="#services">
                    Services
                </a>

                <a href="#dentists">
                    Dentists
                </a>

                <a href="#contact">
                    Contact
                </a>

                <!-- LOGIN -->
                <a href="Login.jsp"
                   class="nav-login">
                    <i class="fa-solid fa-right-to-bracket"></i>
                    Login
                </a>


                <!-- SIGNUP -->
                <a href="Signup.jsp"
                   class="nav-signup">
                    <i class="fa-solid fa-user-plus"></i>
                    Sign Up
                </a>
            </nav>
        </header>

             <!--HERO-->
        <section id="home"           
                 class="hero">
            <div class="hero-slide active">
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <span class="hero-label">
                        WELCOME TO SUNRISE DENTAL CLINIC
                    </span>
                    <h1>
                        Your Smile,
                        <br>
                        Our Priority
                    </h1>
                    <p>
                        Professional and compassionate dental
                        care for you and your entire family.
                    </p>
                    <div class="hero-buttons">

                        <!-- LOGIN -->
                        <a href="Login.jsp"
                           class="btn primary">
                            <i class="fa-solid fa-calendar-check"></i>
                            Login to Book Appointment
                        </a>


                        <!-- SIGNUP -->
                        <a href="Signup.jsp"
                           class="btn secondary">
                            <i class="fa-solid fa-user-plus"></i>
                            Create Account
                        </a>


                        <!-- CONTACT -->
                        <a href="#contact"
                           class="btn outline">
                            <i class="fa-solid fa-phone"></i>
                            Contact Us
                        </a>
                    </div>
                </div>
            </div>
        </section>



        <!-- =========================================================
             FEATURES
        ========================================================= -->

        <section class="features">


            <div class="feature">

                <div class="feature-icon">

                    <i class="fa-solid fa-user-doctor"></i>

                </div>

                <div>

                    <h3>
                        Expert Dentists
                    </h3>

                    <p>
                        Qualified dental professionals
                    </p>

                </div>

            </div>



            <div class="feature">

                <div class="feature-icon">

                    <i class="fa-solid fa-clock"></i>

                </div>

                <div>

                    <h3>
                        Flexible Hours
                    </h3>

                    <p>
                        Monday - Saturday
                    </p>

                </div>

            </div>



            <div class="feature">

                <div class="feature-icon">

                    <i class="fa-solid fa-shield-heart"></i>

                </div>

                <div>

                    <h3>
                        Safe Treatment
                    </h3>

                    <p>
                        Modern dental technology
                    </p>

                </div>

            </div>



            <div class="feature">

                <div class="feature-icon">

                    <i class="fa-solid fa-phone"></i>

                </div>

                <div>

                    <h3>
                        24/7 Support
                    </h3>

                    <p>
                        We're here when you need us
                    </p>

                </div>

            </div>

        </section>



        <!-- =========================================================
             ABOUT
        ========================================================= -->

        <section id="about"
                 class="section">


            <div class="section-image">

                <img
                    src="https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=1000&q=85"
                    alt="Dental treatment">

            </div>



            <div class="section-content">

                <span class="eyebrow">
                    ABOUT OUR CLINIC
                </span>


                <h2>

                    Modern Dentistry
                    With a Personal Touch

                </h2>


                <p>

                    Sunrise Dental Clinic provides
                    high-quality dental care in a
                    comfortable and friendly environment.

                </p>


                <p>

                    Our team uses modern technology
                    and patient-focused treatment
                    methods to help you maintain a
                    healthy, confident smile.

                </p>


                <div class="check-list">


                    <p>

                        <i class="fa-solid fa-circle-check"></i>

                        Experienced dental professionals

                    </p>


                    <p>

                        <i class="fa-solid fa-circle-check"></i>

                        Modern treatment technology

                    </p>


                    <p>

                        <i class="fa-solid fa-circle-check"></i>

                        Comfortable patient environment

                    </p>


                    <p>

                        <i class="fa-solid fa-circle-check"></i>

                        Personalized treatment plans

                    </p>


                </div>


                <a href="Signup.jsp"
                   class="btn primary">

                    <i class="fa-solid fa-calendar-check"></i>

                    Book Appointment

                </a>

            </div>

        </section>



        <!-- =========================================================
             SERVICES
        ========================================================= -->

        <section id="services"
                 class="section light">


            <div class="section-heading">

                <span class="eyebrow">
                    OUR SERVICES
                </span>


                <h2>
                    Complete Dental Care
                </h2>


                <p>

                    Professional treatments designed
                    to protect, restore and improve
                    your smile.

                </p>

            </div>



            <div class="services-grid">


                <!-- SERVICE 1 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=900&q=85"
                        alt="General Dentistry">


                    <div class="service-content">

                        <i class="fa-solid fa-tooth"></i>

                        <h3>
                            General Dentistry
                        </h3>

                        <p>

                            Regular checkups, cleaning
                            and preventive dental treatment.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>



                <!-- SERVICE 2 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=900&q=85"
                        alt="Cosmetic Dentistry">


                    <div class="service-content">

                        <i class="fa-solid fa-wand-magic-sparkles"></i>

                        <h3>
                            Cosmetic Dentistry
                        </h3>

                        <p>

                            Improve the appearance and
                            confidence of your smile.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>



                <!-- SERVICE 3 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1588776814546-daab30f310ce?auto=format&fit=crop&w=900&q=85"
                        alt="Teeth Whitening">


                    <div class="service-content">

                        <i class="fa-solid fa-sparkles"></i>

                        <h3>
                            Teeth Whitening
                        </h3>

                        <p>

                            Professional whitening treatments
                            for a brighter smile.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>



                <!-- SERVICE 4 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&w=900&q=85"
                        alt="Dental Implants">


                    <div class="service-content">

                        <i class="fa-solid fa-teeth"></i>

                        <h3>
                            Dental Implants
                        </h3>

                        <p>

                            Reliable solutions for missing
                            or damaged teeth.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>



                <!-- SERVICE 5 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1609840114035-3c981b782dfe?auto=format&fit=crop&w=900&q=85"
                        alt="Orthodontics">


                    <div class="service-content">

                        <i class="fa-solid fa-teeth-open"></i>

                        <h3>
                            Orthodontics
                        </h3>

                        <p>

                            Braces and alignment treatments
                            for healthier smiles.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>



                <!-- SERVICE 6 -->

                <div class="service-card">

                    <img
                        src="https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=900&q=85"
                        alt="Emergency Dentistry">


                    <div class="service-content">

                        <i class="fa-solid fa-kit-medical"></i>

                        <h3>
                            Emergency Dentistry
                        </h3>

                        <p>

                            Fast dental assistance for
                            urgent dental problems.

                        </p>

                        <a href="Login.jsp">
                            Book Now ?
                        </a>

                    </div>

                </div>


            </div>

        </section>



        <!-- =========================================================
             WHY CHOOSE US
        ========================================================= -->

        <section class="why-us">

            <div class="why-container">

                <span class="eyebrow">
                    WHY CHOOSE US
                </span>


                <h2>
                    Care You Can Trust
                </h2>


                <p class="why-description">

                    We combine experienced dentists,
                    modern technology and
                    patient-focused care.

                </p>


                <div class="why-grid">


                    <div class="why-card">

                        <i class="fa-solid fa-user-doctor"></i>

                        <h3>
                            Qualified Doctors
                        </h3>

                        <p>
                            Experienced professionals.
                        </p>

                    </div>


                    <div class="why-card">

                        <i class="fa-solid fa-microscope"></i>

                        <h3>
                            Modern Technology
                        </h3>

                        <p>
                            Advanced dental equipment.
                        </p>

                    </div>


                    <div class="why-card">

                        <i class="fa-solid fa-heart"></i>

                        <h3>
                            Patient First
                        </h3>

                        <p>
                            Your comfort matters.
                        </p>

                    </div>


                    <div class="why-card">

                        <i class="fa-solid fa-calendar-check"></i>

                        <h3>
                            Easy Booking
                        </h3>

                        <p>
                            Book online through the portal.
                        </p>

                    </div>


                </div>

            </div>

        </section>



        <!-- =========================================================
             DENTISTS
        ========================================================= -->

        <section id="dentists"
                 class="dentists-section">


            <div class="dentists-heading">

                <span class="eyebrow">
                    OUR DENTISTS
                </span>


                <h2>
                    Meet Our Dental Team
                </h2>


                <p>

                    Our experienced dental professionals
                    are committed to providing safe,
                    comfortable and personalized care.

                </p>

            </div>



            <div class="doctor-grid">


                <!-- DOCTOR 1 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1559839734-2b71ea197ec2?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Sarah Perera">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Sarah Perera
                        </h3>

                        <span>
                            General Dentist
                        </span>

                        <p>

                            Specialist in general,
                            preventive and family dentistry.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-tooth"></i>

                            General Dentistry

                        </div>

                    </div>

                </div>



                <!-- DOCTOR 2 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Kavindu Fernando">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Kavindu Fernando
                        </h3>

                        <span>
                            Cosmetic Dentist
                        </span>

                        <p>

                            Focused on smile design,
                            veneers and cosmetic treatments.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-wand-magic-sparkles"></i>

                            Cosmetic Dentistry

                        </div>

                    </div>

                </div>



                <!-- DOCTOR 3 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1594824476967-48c8b964273f?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Nethmi Silva">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Nethmi Silva
                        </h3>

                        <span>
                            Orthodontist
                        </span>

                        <p>

                            Specialist in braces,
                            aligners and dental alignment.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-teeth-open"></i>

                            Orthodontics

                        </div>

                    </div>

                </div>



                <!-- DOCTOR 4 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Daniel Perera">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Daniel Perera
                        </h3>

                        <span>
                            Oral Surgeon
                        </span>

                        <p>

                            Experienced in oral surgery
                            and complex dental procedures.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-user-doctor"></i>

                            Oral Surgery

                        </div>

                    </div>

                </div>



                <!-- DOCTOR 5 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1651008376811-b90baee60c1f?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Ayesha Fernando">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Ayesha Fernando
                        </h3>

                        <span>
                            Paediatric Dentist
                        </span>

                        <p>

                            Gentle and friendly dental
                            care for children.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-child"></i>

                            Paediatric Dentistry

                        </div>

                    </div>

                </div>



                <!-- DOCTOR 6 -->

                <div class="doctor-card">

                    <div class="doctor-image">

                        <img
                            src="https://images.unsplash.com/photo-1614608682850-e0d6ed316d47?auto=format&fit=crop&w=800&q=85"
                            alt="Dr. Michael Silva">

                    </div>


                    <div class="doctor-info">

                        <h3>
                            Dr. Michael Silva
                        </h3>

                        <span>
                            Periodontist
                        </span>

                        <p>

                            Specialist in gum disease
                            prevention and treatment.

                        </p>


                        <div class="doctor-specialty">

                            <i class="fa-solid fa-heart-pulse"></i>

                            Periodontics

                        </div>

                    </div>

                </div>


            </div>

        </section>



        <!-- =========================================================
             CTA
        ========================================================= -->

        <section class="cta">

            <div class="cta-content">

                <span>
                    READY FOR A HEALTHIER SMILE?
                </span>


                <h2>
                    Book Your Dental Appointment Today
                </h2>


                <p>

                    Create your patient account and
                    book your appointment online.

                </p>


                <a href="Signup.jsp"
                   class="btn white">

                    <i class="fa-solid fa-user-plus"></i>

                    Create Patient Account

                </a>

            </div>

        </section>



        <!-- =========================================================
             CONTACT
        ========================================================= -->

        <section id="contact"
                 class="contact">


            <div class="contact-info">

                <span class="eyebrow">
                    CONTACT US
                </span>


                <h2>
                    We're Here For You
                </h2>


                <p>

                    Contact Sunrise Dental Clinic
                    for appointments, questions or
                    emergency dental support.

                </p>


                <div class="contact-item">

                    <div class="contact-icon">

                        <i class="fa-solid fa-location-dot"></i>

                    </div>


                    <div>

                        <strong>
                            Address
                        </strong>

                        <p>
                            Colombo, Sri Lanka
                        </p>

                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-icon">

                        <i class="fa-solid fa-phone"></i>

                    </div>


                    <div>

                        <strong>
                            Phone
                        </strong>

                        <p>
                            +94 11 234 5678
                        </p>

                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-icon">

                        <i class="fa-solid fa-envelope"></i>

                    </div>


                    <div>

                        <strong>
                            Email
                        </strong>

                        <p>
                            info@sunrisedentalclinic.com
                        </p>

                    </div>

                </div>


                <div class="contact-item">

                    <div class="contact-icon">

                        <i class="fa-solid fa-clock"></i>

                    </div>


                    <div>

                        <strong>
                            Opening Hours
                        </strong>

                        <p>
                            Mon - Sat: 8:00 AM - 8:00 PM
                        </p>

                    </div>

                </div>

            </div>



            <div class="contact-map">

                <iframe
                    src="https://www.google.com/maps?q=Colombo,Sri%20Lanka&output=embed"
                    loading="lazy"
                    title="Sunrise Dental Clinic Location">
                </iframe>

            </div>

        </section>



        <!-- =========================================================
             FOOTER
        ========================================================= -->

        <footer>


            <div class="footer-grid">


                <!-- ABOUT -->

                <div class="footer-about">

                    <a href="Index.jsp"
                       class="footer-logo">

                        <i class="fa-solid fa-tooth"></i>

                        Sunrise Dental Clinic

                    </a>


                    <p>

                        Quality dental care with modern
                        technology and compassionate service.

                    </p>


                    <div class="social-links">

                        <a href="#">
                            <i class="fa-brands fa-facebook-f"></i>
                        </a>

                        <a href="#">
                            <i class="fa-brands fa-instagram"></i>
                        </a>

                        <a href="#">
                            <i class="fa-brands fa-whatsapp"></i>
                        </a>

                    </div>

                </div>



                <!-- QUICK LINKS -->

                <div>

                    <h3>
                        Quick Links
                    </h3>


                    <a href="Index.jsp">
                        Home
                    </a>

                    <a href="#about">
                        About
                    </a>

                    <a href="#services">
                        Services
                    </a>

                    <a href="#dentists">
                        Dentists
                    </a>

                    <a href="#contact">
                        Contact
                    </a>

                </div>



                <!-- PATIENT PORTAL -->

                <div>

                    <h3>
                        Patient Portal
                    </h3>


                    <a href="Login.jsp">
                        Login
                    </a>


                    <a href="Signup.jsp">
                        Create Account
                    </a>


                    <a href="patient-dashboard.jsp">
                        Patient Dashboard
                    </a>

                </div>



                <!-- STAFF PORTAL -->

                <div>

                    <h3>
                        Staff Portal
                    </h3>


                    <a href="doctor-dashboard.jsp">
                        Doctor Dashboard
                    </a>


                    <a href="cashier-dashboard.jsp">
                        Cashier Dashboard
                    </a>


                    <a href="admin-dashboard.jsp">
                        Admin Dashboard
                    </a>

                </div>


            </div>


            <div class="copyright">

                © 2026 Sunrise Dental Clinic.
                All Rights Reserved.

            </div>


        </footer>



        <!-- JAVASCRIPT -->

        <script src="js/script.js"></script>


    </body>

</html>