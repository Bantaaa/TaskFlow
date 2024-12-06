package com.devsync.util;

import com.devsync.domain.entity.Task;
import com.devsync.domain.entity.Token;
import com.devsync.repository.Implementations.TokenRepository;
import com.devsync.service.TokenService;

import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

public class TokenUtils {

    private TokenService tokenService;

    public TokenUtils() {
        TokenRepository tokenRepository = new TokenRepository();
         this.tokenService = new TokenService(tokenRepository);
    }

    public void resetDailyTokens(Token token) {
        token.setDailyModificationTokens(2);
        token.setLastDailyReset(LocalDate.now());
        tokenService.updateToken(token);
    }

    public  void resetMonthlyTokens(Token token) {
        token.setMonthlyDeletionTokens(1);
        token.setLastMonthlyReset(LocalDate.now());
        tokenService.updateToken(token);
    }

}
