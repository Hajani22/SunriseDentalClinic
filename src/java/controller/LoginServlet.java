package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import service.UserService;
import service.impl.UserServiceImpl;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (email != null) {
            email = email.trim();
        }

        if (role != null) {
            role = role.trim().toLowerCase();
        }

        if (isEmpty(email)
                || isEmpty(password)
                || isEmpty(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=empty"
            );
            return;
        }

        if (!isValidRole(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=role"
            );
            return;
        }

        User user = userService.loginUser(
                email,
                password,
                role
        );

        if (user == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Login.jsp?error=invalid"
            );
            return;
        }

        HttpSession session = request.getSession(true);

        session.setAttribute("user", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute(
                "userName",
                user.getFirstName()
                + " "
                + user.getLastName()
        );
        session.setAttribute(
                "userRole",
                user.getRole()
        );

        /*
         * Redirect with success=login.
         * toast.jsp reads this parameter and
         * displays "Login successful."
         */
        switch (user.getRole()) {

            case "patient":

                response.sendRedirect(
                        request.getContextPath()
                        + "/patient-dashboard.jsp?success=login"
                );
                break;

            case "doctor":

                response.sendRedirect(
                        request.getContextPath()
                        + "/doctor-dashboard.jsp?success=login"
                );
                break;

            case "cashier":

                response.sendRedirect(
                        request.getContextPath()
                        + "/cashier-dashboard.jsp?success=login"
                );
                break;

            case "admin":

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-dashboard.jsp?success=login"
                );
                break;

            default:

                session.invalidate();

                response.sendRedirect(
                        request.getContextPath()
                        + "/Login.jsp?error=role"
                );
        }
    }

    private boolean isValidRole(String role) {

        return "patient".equals(role)
                || "doctor".equals(role)
                || "cashier".equals(role)
                || "admin".equals(role);
    }

    private boolean isEmpty(String value) {

        return value == null
                || value.trim().isEmpty();
    }
}
