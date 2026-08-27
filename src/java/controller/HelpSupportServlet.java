package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Controller for Help & Support Centre.
 *
 * Design patterns / architecture:
 *
 * MVC Controller Service Layer can be introduced later
 *
 * Current version: Handles and validates support requests.
 */
@WebServlet("/HelpSupportServlet")
public class HelpSupportServlet extends HttpServlet {

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        /*
         * =====================================================
         * SESSION SECURITY
         * =====================================================
         */
        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=session"
            );

            return;
        }


        /*
         * =====================================================
         * ROLE SECURITY
         * =====================================================
         */
        String role
                = String.valueOf(
                        session.getAttribute(
                                "userRole"
                        )
                );

        if (!"patient".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=access"
            );

            return;
        }


        /*
         * =====================================================
         * READ FORM DATA
         * =====================================================
         */
        String category
                = clean(
                        request.getParameter(
                                "category"
                        )
                );

        String subject
                = clean(
                        request.getParameter(
                                "subject"
                        )
                );

        String message
                = clean(
                        request.getParameter(
                                "message"
                        )
                );


        /*
         * =====================================================
         * VALIDATION
         * =====================================================
         */
        if (category == null
                || subject == null
                || message == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Help.jsp?error=empty"
            );

            return;
        }


        /*
         * Subject length validation.
         */
        if (subject.length() > 150) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Help.jsp?error=subject"
            );

            return;
        }


        /*
         * Message length validation.
         */
        if (message.length() > 1000) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Help.jsp?error=message"
            );

            return;
        }


        /*
         * =====================================================
         * SUPPORT REQUEST
         * =====================================================
         *
         * At this stage the request is validated.
         *
         * If you later want support tickets stored in the
         * database, we can add:
         *
         * support_requests
         *
         * table + DAO + Service.
         *
         * =====================================================
         */
 /*
         * For the current implementation, redirect back
         * with success message.
         */
        response.sendRedirect(
                request.getContextPath()
                + "/Help.jsp?submitted=true"
        );
    }


    /*
     * =========================================================
     * CLEAN INPUT
     * =========================================================
     */
    private String clean(String value) {

        if (value == null) {

            return null;

        }

        value
                = value.trim();

        if (value.isEmpty()) {

            return null;

        }

        return value;
    }
}
