package dao;

import model.User;

public interface UserDAO {

    boolean registerUser(User user);

    User loginUser(
            String email,
            String password,
            String role
    );

    boolean emailExists(String email);
}