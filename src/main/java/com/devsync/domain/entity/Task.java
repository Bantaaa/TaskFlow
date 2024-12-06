package com.devsync.domain.entity;

import com.devsync.domain.enums.TaskStatus;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name= "tasks", schema ="public")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)

public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private int id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @Enumerated(EnumType.STRING)
    private TaskStatus status;


    private LocalDateTime dueDate;

    @ManyToOne 
    @JoinColumn(name = "assignee_id", nullable = true)
    private User assignee;

    @ManyToOne
    @JoinColumn(name = "creator_id", nullable = false)
    private User createdBy;

    @ManyToMany
    @JoinTable(
        name = "task_tags",
        joinColumns = @JoinColumn(name = "task_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<Tag> tags;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime creationDate;


    @Column(name = "isrefused", nullable = false)
    private boolean refused;

    @CreationTimestamp
    @Column(nullable = true)
    private LocalDateTime changeDate;

    @OneToMany(mappedBy = "oldtask",  cascade = CascadeType.ALL)
    private List<TaskRequest> oldtaskrequests;

    @OneToMany(mappedBy = "newtask",  cascade = CascadeType.ALL)
    private List<TaskRequest> newtaskrequests;


    @Override
    public String toString() {
        return "Task{" +
            "id=" + id +
            ", title='" + title + '\'' +
            ", description='" + description + '\'' +
            ", status=" + status +
            ", dueDate=" + dueDate +
            ", creationDate=" + creationDate +
            ", refused=" + refused +
            '}';
    }
}
