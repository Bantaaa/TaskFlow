package com.devsync.domain.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Entity
@Table(name = "Tokens")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor

public class Token {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private int dailyModificationTokens;

    @Column(nullable = false)
    private int monthlyDeletionTokens;

    @Column(nullable = false)
    private LocalDate lastDailyReset;

    @Column(nullable = false)
    private LocalDate lastMonthlyReset;


    @Override
    public String toString() {
        return "Token{" +
            "id=" + id +
            ", dailyModificationTokens=" + dailyModificationTokens +
            ", monthlyDeletionTokens=" + monthlyDeletionTokens +
            ", lastDailyReset=" + lastDailyReset +
            ", lastMonthlyReset=" + lastMonthlyReset +
            '}';
    }

    /*public void resetDailyTokens() {
        this.dailyModificationTokens = 2;
        this.lastDailyReset = LocalDate.now();
    }

    public void resetMonthlyTokens() {
        this.monthlyDeletionTokens = 1;
        this.lastMonthlyReset = LocalDate.now();
    }*/
}