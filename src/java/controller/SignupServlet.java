package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.User;
import service.UserService;
import service.impl.UserServiceImpl;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "SignupServlet", urlPatterns = {"/SignupServlet"})
public class SignupServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = trim(request.getParameter("firstName"));
        String lastName = trim(request.getParameter("lastName"));
        String email = trim(request.getParameter("email")).toLowerCase();
        String phone = trim(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = trim(request.getParameter("role")).toLowerCase();

        // HTML checkbox values can be "on", "accepted", "true", etc.
        // The important part is that the browser sent the parameter.
        String terms = request.getParameter("terms");

        if (isEmpty(firstName) || isEmpty(lastName) || isEmpty(email)
                || isEmpty(phone) || isEmpty(password)
                || isEmpty(confirmPassword) || isEmpty(role)
                || isEmpty(terms)) {
            redirect(request, response, "empty");
            return;
        }

        if (password.length() < 8) {
            redirect(request, response, "shortpassword");
            return;
        }

        if (!password.equals(confirmPassword)) {
            redirect(request, response, "password");
            return;
        }

        if (!role.equals("patient") && !role.equals("doctor")
                && !role.equals("cashier") && !role.equals("admin")) {
            redirect(request, response, "role");
            return;
        }

        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password);
        user.setRole(role);

        try {
            if ("patient".equals(role)) {
                String dob = trim(request.getParameter("dateOfBirth"));
                String gender = trim(request.getParameter("gender"));

                if (!isEmpty(dob)) {
                    user.setDateOfBirth(Date.valueOf(dob));
                }
                user.setGender(gender);

            } else if ("doctor".equals(role)) {
                user.setMedicalRegistrationNo(trim(request.getParameter("medicalRegistrationNo")));
                user.setSpecialization(trim(request.getParameter("specialization")));

            } else if ("cashier".equals(role)) {
                user.setEmployeeId(trim(request.getParameter("employeeId")));
                user.setDepartment(trim(request.getParameter("department")));
                user.setCashierShift(trim(request.getParameter("cashierShift")));
                user.setPosId(trim(request.getParameter("posId")));

            } else { // admin
                user.setEmployeeId(trim(request.getParameter("adminEmployeeId")));
                user.setDepartment(trim(request.getParameter("adminDepartment")));
            }

            boolean success = userService.registerUser(user);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/Login.jsp?success=registered");
            } else {
                redirect(request, response, "registration");
            }

        } catch (IllegalArgumentException e) {
            redirect(request, response, "invaliddata");
        } catch (Exception e) {
            getServletContext().log("Unexpected signup error", e);
            redirect(request, response, "server");
        }
    }

    private void redirect(HttpServletRequest request, HttpServletResponse response, String error)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/Signup.jsp?error=" + error);
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
