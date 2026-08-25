package service;

import model.User;

public interface UserService {

    boolean registerUser(User user);

    User loginUser(
            String email,
            String password,
            String role
    );

    boolean emailExists(String email);
}