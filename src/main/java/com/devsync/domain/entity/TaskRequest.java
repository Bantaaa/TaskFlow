package com.devsync.domain.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "task_requests")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String type;

    @ManyToOne
    @JoinColumn(name = "oldtask_id", nullable = false)
    private Task oldtask;

    @ManyToOne
    @JoinColumn(name = "newtask_id", nullable = false)
    private Task newtask;

    @ManyToOne
    @JoinColumn(name = "requested_by", nullable = false)
    private User requestedBy;

    @Column(nullable = false)
    private boolean approved;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "responded_at" , nullable = true)
    private LocalDateTime respondedAt;

    @Column(nullable = false)
    private boolean expired;

    @Column(nullable = true)
    private Long hoursDiff;

    @Override
    public String toString() {
        return "TaskRequest{" +
            "id=" + id +
            ", type='" + type + '\'' +
            ", approved=" + approved +
            ", createdAt=" + createdAt +
            ", respondedAt=" + respondedAt +
            ", expired=" + expired +
            '}';
    }


    /*public boolean isPending() {
        return respondedAt == null && !expired;
    }

    public boolean isExpired() {
        LocalDateTime expirationTime = createdAt.plusHours(12);
        return LocalDateTime.now().isAfter(expirationTime) && !approved;
    }*/
}
