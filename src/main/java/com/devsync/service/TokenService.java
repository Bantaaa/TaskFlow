package com.devsync.service;


import com.devsync.domain.entity.Tag;
import com.devsync.domain.entity.TaskRequest;
import com.devsync.domain.entity.Token;
import com.devsync.domain.entity.User;
import com.devsync.repository.Implementations.TagRepository;
import com.devsync.repository.Implementations.TaskRequestRepository;
import com.devsync.repository.Implementations.TokenRepository;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;


public class TokenService {


    private TokenRepository tokenRepository;
    private TaskRequestRepository taskRequestRepository = new TaskRequestRepository();

    public TokenService(TokenRepository tokenRepository) {
        this.tokenRepository = new TokenRepository();
    }


    public List<Token> getTokens() {
        return tokenRepository.findAll();
    }

    public Token getTokenByUser(User user) {
        return tokenRepository.findByUser(user);
    }

    public Token updateToken(Token token) {

        /*Token existingToken = tokenRepository.findById(token.getId());

        if (existingToken != null) {*/
            Token updtToken = tokenRepository.update(token);
            return updtToken;
       /* }

        return null;*/
    }


    public Long getModificationsSum() {
        List<TaskRequest> allRequsts= taskRequestRepository.findAll();

        return allRequsts.stream()
            .filter(r -> "modification".equals(r.getType()) && r.isApproved())
            .count();

    }








}
