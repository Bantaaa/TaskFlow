package org.banta.service;

import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import org.banta.dao.UserDAO;
import org.banta.model.User;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.Arrays;

@Stateless
public class UserService {

    @Inject
    private UserDAO userDAO;

    public void createUser(User user) throws SQLException {
        user.setPassword(hashPassword(user.getPassword()));
        userDAO.create(user);
    }

    public Optional<User> getUserById(Long id) {
        return userDAO.findById(id);
    }

    public Optional<User> getUserByUsername(String username) {
        return userDAO.findByUsername(username);
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public void updateUser(User user) {
        userDAO.update(user);
    }

    public void deleteUser(Long id) {
        userDAO.findById(id).ifPresent(user -> userDAO.delete(user));
    }

    public Optional<User> authenticate(String username, String password) {
        System.out.println("Authenticating user: " + username); // Log the username
        Optional<User> userOptional = userDAO.findByUsername(username);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            System.out.println("User found in database"); // Log if user is found
            if (verifyPassword(password, user.getPassword())) {
                System.out.println("Password verified successfully"); // Log successful verification
                return Optional.of(user);
            } else {
                System.out.println("Password verification failed"); // Log failed verification
            }
        } else {
            System.out.println("User not found in database"); // Log if user is not found
        }
        return Optional.empty();
    }

    public boolean isValidRole(String role) {
        List<String> validRoles = Arrays.asList("ADMIN", "USER", "MANAGER");
        return validRoles.contains(role.toUpperCase());
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    private boolean verifyPassword(String inputPassword, String storedPassword) {
        String hashedInput = hashPassword(inputPassword);
        System.out.println("Hashed input password: " + hashedInput);
        System.out.println("Stored hashed password: " + storedPassword);
        return hashedInput.equals(storedPassword);
    }


    public boolean useModificationToken(User user) {
        if (user.useModificationToken()) {
            userDAO.update(user);
            return true;
        }
        return false;
    }

    public boolean useDeletionToken(User user) {
        if (user.useDeletionToken()) {
            userDAO.update(user);
            return true;
        }
        return false;
    }

    public void refreshUserTokens(User user) {
        user.refreshTokens();
        userDAO.update(user);
    }
}