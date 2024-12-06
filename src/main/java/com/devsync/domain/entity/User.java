package com.devsync.domain.entity;

import com.devsync.domain.enums.Role;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.util.List;

@Entity
@Table(name = "users", schema = "public")
@Data
@NoArgsConstructor
@AllArgsConstructor
@NamedQuery(name="User.byId", query = "SELECT u FROM User u WHERE u.id = ?1")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false,length = 120)
    private String firstName;

    @Column(nullable = false,length = 120)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String email;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.INDIVIDUAL;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDate registeredAt;

    @OneToMany(mappedBy = "assignee", cascade = CascadeType.ALL)
    private List<Task> tasks;

    @OneToMany(mappedBy = "createdBy", cascade = CascadeType.ALL)
    private List<Task> createdTasks;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Token token;

    @OneToMany(mappedBy = "requestedBy", cascade = CascadeType.ALL,  fetch = FetchType.LAZY)
    private List<TaskRequest> taskrequests;


    @Override
    public String toString() {
        return "User{" +
            "id=" + id +
            ", username='" + username + '\'' +
            ", password='" + password + '\'' +
            ", firstName='" + firstName + '\'' +
            ", lastName='" + lastName + '\'' +
            ", email='" + email + '\'' +
            ", role=" + role +
            ", registeredAt=" + registeredAt +
            ", token=" + token +
            '}';
    }
}