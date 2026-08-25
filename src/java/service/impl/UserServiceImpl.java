package service.impl;

import dao.UserDAO;
import dao.impl.UserDAOImpl;
import model.User;
import service.UserService;
import util.PasswordUtil;

public class UserServiceImpl
        implements UserService {

    private final UserDAO userDAO;

    public UserServiceImpl() {

        userDAO
                = new UserDAOImpl();
    }

    @Override
    public boolean registerUser(User user) {

        if (user == null) {
            return false;
        }

        if (isEmpty(user.getFirstName())
                || isEmpty(user.getLastName())
                || isEmpty(user.getEmail())
                || isEmpty(user.getPhone())
                || isEmpty(user.getPassword())
                || isEmpty(user.getRole())) {

            return false;
        }

        String role
                = user.getRole()
                        .trim()
                        .toLowerCase();

        if (!isValidRole(role)) {
            return false;
        }

        user.setRole(role);

        user.setFirstName(
                user.getFirstName().trim()
        );

        user.setLastName(
                user.getLastName().trim()
        );

        user.setEmail(
                user.getEmail()
                        .trim()
                        .toLowerCase()
        );

        user.setPhone(
                user.getPhone().trim()
        );

        if (user.getPassword().length() < 8) {
            return false;
        }

        /*
         * Do not allow the same email to
         * create another account.
         */
        if (userDAO.emailExists(
                user.getEmail()
        )) {

            return false;
        }

        /*
         * Hash password before storing.
         */
        user.setPassword(
                PasswordUtil.hashPassword(
                        user.getPassword()
                )
        );

        return userDAO.registerUser(user);
    }

    @Override
    public User loginUser(
            String email,
            String password,
            String role) {

        if (isEmpty(email)
                || isEmpty(password)
                || isEmpty(role)) {

            return null;
        }

        email
                = email.trim()
                        .toLowerCase();

        role
                = role.trim()
                        .toLowerCase();

        if (!isValidRole(role)) {
            return null;
        }

        /*
         * DAO handles password hashing and
         * role-specific table selection.
         */
        return userDAO.loginUser(
                email,
                password,
                role
        );
    }

    @Override
    public boolean emailExists(
            String email) {

        if (isEmpty(email)) {
            return false;
        }

        return userDAO.emailExists(
                email.trim().toLowerCase()
        );
    }

    private boolean isValidRole(
            String role) {

        return "patient".equals(role)
                || "doctor".equals(role)
                || "cashier".equals(role)
                || "admin".equals(role);
    }

    private boolean isEmpty(
            String value) {

        return value == null
                || value.trim().isEmpty();
    }
}
