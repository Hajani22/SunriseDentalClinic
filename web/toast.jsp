<%-- =========================================================
     SUNRISE DENTAL CLINIC
     COMMON TOAST NOTIFICATION
     One shared toast for the whole application
     ========================================================= --%>

<style>
    #sunriseToast {
        position: fixed;
        right: 25px;
        bottom: 25px;
        min-width: 320px;
        max-width: 430px;
        padding: 15px 18px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        gap: 12px;
        color: #ffffff;
        font-family: "Open Sans", Arial, sans-serif;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.4;
        box-shadow: 0 10px 30px rgba(0,0,0,.20);
        opacity: 0;
        transform: translateY(25px);
        pointer-events: none;
        transition: opacity .30s ease, transform .30s ease;
        z-index: 999999;
    }

    #sunriseToast.show {
        opacity: 1;
        transform: translateY(0);
        pointer-events: auto;
    }

    #sunriseToast.success {
        background: #198754;
    }
    #sunriseToast.error   {
        background: #dc3545;
    }
    #sunriseToast.warning {
        background: #d97706;
    }
    #sunriseToast.info    {
        background: #087fa8;
    }

    .sunrise-toast-icon {
        width: 28px;
        height: 28px;
        min-width: 28px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: rgba(255,255,255,.18);
        font-size: 16px;
        font-weight: 800;
    }

    .sunrise-toast-message {
        flex: 1;
    }

    .sunrise-toast-close {
        border: none;
        background: transparent;
        color: #ffffff;
        font-size: 20px;
        line-height: 1;
        cursor: pointer;
        padding: 0 2px;
        opacity: .85;
    }

    .sunrise-toast-close:hover {
        opacity: 1;
    }

    @media (max-width: 600px) {
        #sunriseToast {
            left: 15px;
            right: 15px;
            bottom: 15px;
            min-width: auto;
            max-width: none;
        }
    }
</style>

<div id="sunriseToast" role="alert" aria-live="polite">
    <div id="sunriseToastIcon" class="sunrise-toast-icon"></div>
    <div id="sunriseToastMessage" class="sunrise-toast-message"></div>
    <button type="button"
            class="sunrise-toast-close"
            onclick="closeSunriseToast()"
            aria-label="Close notification">&times;</button>
</div>

<script>
    (function () {

        function showSunriseToast(message, type, duration) {

            const toast = document.getElementById("sunriseToast");
            const icon = document.getElementById("sunriseToastIcon");
            const messageBox = document.getElementById("sunriseToastMessage");

            if (!toast || !icon || !messageBox || !message) {
                return;
            }

            type = type || "info";
            duration = duration || 4500;

            toast.classList.remove("success", "error", "warning", "info", "show");
            toast.classList.add(type);

            if (type === "success") {
                icon.textContent = "?";
            } else if (type === "error") {
                icon.textContent = "?";
            } else if (type === "warning") {
                icon.textContent = "!";
            } else {
                icon.textContent = "i";
            }

            messageBox.textContent = message;

            window.clearTimeout(window.sunriseToastTimer);

            requestAnimationFrame(function () {
                toast.classList.add("show");
            });

            window.sunriseToastTimer = window.setTimeout(function () {
                closeSunriseToast();
            }, duration);
        }

        function closeSunriseToast() {
            const toast = document.getElementById("sunriseToast");
            if (toast) {
                toast.classList.remove("show");
            }
            window.clearTimeout(window.sunriseToastTimer);
        }

        window.showSunriseToast = showSunriseToast;
        window.closeSunriseToast = closeSunriseToast;

        document.addEventListener("DOMContentLoaded", function () {

            const params = new URLSearchParams(window.location.search);

            const success = params.get("success");
            const error = params.get("error");
            const errorMessage = params.get("errorMessage");
            const message = params.get("message");

            let toastMessage = null;
            let toastType = "info";

            /* =========================
             SUCCESS
             ========================= */

            if (success === "login") {
                toastMessage = "Login successful.";
                toastType = "success";

            } else if (success === "booked") {
                toastMessage = "Appointment request sent successfully.";
                toastType = "success";

            } else if (success === "appointment") {
                toastMessage = "Appointment booked successfully.";
                toastType = "success";

            } else if (success === "accepted") {
                toastMessage = "Appointment accepted successfully.";
                toastType = "success";

            } else if (success === "approved") {
                toastMessage = "Appointment approved successfully.";
                toastType = "success";

            } else if (success === "confirmed") {
                toastMessage = "Appointment confirmed successfully.";
                toastType = "success";

            } else if (success === "rejected") {
                toastMessage = "Appointment rejected successfully.";
                toastType = "success";

            } else if (success === "cancelled") {
                toastMessage = "Appointment cancelled successfully.";
                toastType = "success";

            } else if (success === "rescheduled") {
                toastMessage = "Appointment rescheduled successfully.";
                toastType = "success";

            } else if (success === "submitted") {
                toastMessage = "Request submitted successfully.";
                toastType = "success";

            } else if (success === "feedback") {
                toastMessage = "Feedback submitted successfully.";
                toastType = "success";

            } else if (success === "registered") {
                toastMessage = "Account created successfully. Please sign in.";
                toastType = "success";

            } else if (success === "logout") {
                toastMessage = "You have signed out successfully.";
                toastType = "success";

            } else if (success === "payment") {
                toastMessage = "Payment completed successfully.";
                toastType = "success";

            } else if (success === "saved") {
                toastMessage = "Changes saved successfully.";
                toastType = "success";

            } else if (success === "updated") {
                toastMessage = "Updated successfully.";
                toastType = "success";

            } else if (success === "added") {
                toastMessage = "Added successfully.";
                toastType = "success";

            } else if (success === "activated") {
                toastMessage = "Activated successfully.";
                toastType = "success";

            } else if (success === "deactivated") {
                toastMessage = "Deactivated successfully.";
                toastType = "success";

            } else if (success === "requested") {
                toastMessage = "Leave request submitted successfully.";
                toastType = "success";

            }


            /* =========================
             ERROR
             ========================= */

            else if (error === "empty") {
                toastMessage = "Please complete all required fields.";
                toastType = "error";

            } else if (error === "login" || error === "invalid") {
                toastMessage = "Invalid email, password, or account type.";
                toastType = "error";

            } else if (error === "role") {
                toastMessage = "Please select the correct account type.";
                toastType = "error";

            } else if (error === "access") {
                toastMessage = "You do not have permission to perform this action.";
                toastType = "error";

            } else if (error === "session") {
                toastMessage = "Your session has expired. Please log in again.";
                toastType = "error";

            } else if (error === "booking" || error === "appointment") {
                toastMessage = "Unable to process the appointment request.";
                toastType = "error";

            } else if (error === "cancel") {
                toastMessage = "Unable to cancel the appointment.";
                toastType = "error";

            } else if (error === "decision") {
                toastMessage = "Unable to process the appointment decision.";
                toastType = "error";

            } else if (error === "slot") {
                toastMessage = "The selected time slot is unavailable.";
                toastType = "error";

            } else if (error === "database") {
                toastMessage = "A database error occurred. Please try again.";
                toastType = "error";

            } else if (error === "server") {
                toastMessage = "A server error occurred. Please try again.";
                toastType = "error";

            } else if (error === "validation") {
                toastMessage = errorMessage || "Please check the information you entered.";
                toastType = "warning";

            } else if (error === "payment") {
                toastMessage = "Payment failed. Please try again.";
                toastType = "error";

            } else if (error === "method") {
                toastMessage = "Please select a valid payment method.";
                toastType = "warning";

            } else if (error === "receipt") {
                toastMessage = "Unable to generate the receipt.";
                toastType = "error";

            } else if (error === "reports") {
                toastMessage = "Unable to load the reports.";
                toastType = "error";

            } else if (error === "notfound") {
                toastMessage = "The requested record was not found.";
                toastType = "error";

            } else if (error === "action") {
                toastMessage = "Invalid action.";
                toastType = "error";

            } else if (error === "approve") {
                toastMessage = "Unable to approve the request.";
                toastType = "error";

            } else if (error === "reject") {
                toastMessage = "Unable to reject the request.";
                toastType = "error";
            }


            /* =========================
             CUSTOM MESSAGE
             ========================= */

            if (errorMessage && error === "validation") {
                toastMessage = errorMessage;
                toastType = "warning";
            }

            if (message) {
                toastMessage = message;
                toastType = error ? "error" : "success";
            }


            /* =========================
             SHOW
             ========================= */

            if (toastMessage) {
                showSunriseToast(toastMessage, toastType, 4500);

                const cleanUrl = window.location.pathname;
                window.history.replaceState({}, document.title, cleanUrl);
            }

        });

    })();
</script>
