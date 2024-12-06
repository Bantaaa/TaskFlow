package com.devsync.service;


import com.devsync.domain.entity.Token;
import com.devsync.domain.entity.User;
import com.devsync.repository.Implementations.TokenRepository;
import com.devsync.repository.Implementations.UserRepository;
import com.devsync.util.DateUtils;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.Random;


public class UserService {


    private UserRepository userRepository;
    private TokenRepository tokenRepository;

    public UserService(UserRepository userRepository, TokenRepository tokenRepository) {
        this.userRepository = userRepository;
        this.tokenRepository = tokenRepository;
    }


    public void addUser(User user) {
        userRepository.save(user);
    }

    public boolean registerUser(String firstName, String lastName, String email, String password){
        Random random = new Random();
        int randomNumber = random.nextInt(9000);
        String username = firstName + randomNumber;

        User user = new User();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        user.setPassword(hashedPassword);
        user.setUsername(username);

        boolean isUserSaved = userRepository.save(user);

        if (isUserSaved) {
            Token token = new Token();
            token.setUser(user);
            token.setDailyModificationTokens(2);
            token.setMonthlyDeletionTokens(1);
            token.setLastDailyReset(LocalDate.now());
            token.setLastMonthlyReset(LocalDate.now());

            tokenRepository.save(token);

            return true;
        }

        return false;
    }

    public Optional<User> loginUser(String email, String password){
       Optional<User> user = userRepository.findByEmail(email);

        if (user.isPresent() && BCrypt.checkpw(password, user.get().getPassword())) {
            return user;
        }
       return Optional.empty();

    }

    public User getUserById(Long id) {
        return userRepository.findById(id);
    }


    public User updateUser(Long id, String firstName, String lastName, String email) {

        User user = userRepository.findById(id);

        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);


        try {
            return userRepository.update(user);

        } catch (Exception e) {
            return null;
        }
    }

    public List<User> getAllUsers() {
        return  userRepository.findAll();
    }





}
