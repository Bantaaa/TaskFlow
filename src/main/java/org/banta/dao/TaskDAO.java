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
        return entityManager.createQuery("SELECT u FROM Task u", Task.class).getResultList();
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

    public User findByTitle(String title) {
        return entityManager.createQuery("SELECT u FROM Task u WHERE u.title = :title", User.class)
                .setParameter("title", title)
                .getSingleResult();
    }
}