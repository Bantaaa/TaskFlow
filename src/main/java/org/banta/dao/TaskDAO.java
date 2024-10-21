package org.banta.dao;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.banta.model.Task;
import org.banta.model.User;

import java.util.List;

@Stateless
public class TaskDAO {

    @PersistenceContext(unitName = "myPU")
    private EntityManager entityManager;

    public void create(Task task) {
        entityManager.persist(task);
    }

    public Task findById(Long id) {
        return entityManager.find(Task.class, id);
    }

    public List<Task> findAll() {
        return entityManager.createQuery(
                        "SELECT DISTINCT t FROM Task t LEFT JOIN FETCH t.tags LEFT JOIN FETCH t.assignedUser", Task.class)
                .getResultList();
    }

    public void update(Task task) {
        entityManager.merge(task);
    }

    public void delete(Task task) {
        if (!entityManager.contains(task)) {
            task = entityManager.merge(task);
        }
        entityManager.remove(task);
    }

    public List<Task> findByUser(User user) {
        return entityManager.createQuery(
                        "SELECT DISTINCT t FROM Task t LEFT JOIN FETCH t.tags WHERE t.assignedUser = :user", Task.class)
                .setParameter("user", user)
                .getResultList();
    }

    public List<Task> findOverdueTasks() {
        return entityManager.createQuery(
                        "SELECT DISTINCT t FROM Task t LEFT JOIN FETCH t.tags WHERE t.dueDate < CURRENT_DATE AND t.status != :doneStatus", Task.class)
                .setParameter("doneStatus", Task.Status.DONE)
                .getResultList();
    }

    public List<Task> findByStatus(Task.Status status) {
        return entityManager.createQuery(
                        "SELECT DISTINCT t FROM Task t LEFT JOIN FETCH t.tags WHERE t.status = :status", Task.class)
                .setParameter("status", status)
                .getResultList();
    }
}