package org.banta.service;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.banta.model.Task;

import java.util.List;

@Stateless
public class TaskService {

    @PersistenceContext(unitName = "myPU")
    private EntityManager entityManager;

    public void createTask(Task task) {
        entityManager.persist(task);
    }

    public Task getTaskById(Long id) {
        return entityManager.find(Task.class, id);
    }

    public List<Task> getAllTasks() {
        return entityManager.createQuery("SELECT t FROM Task t", Task.class).getResultList();
    }

    public void updateTask(Task task) {
        entityManager.merge(task);
    }

    public void deleteTask(Long id) {
        Task task = getTaskById(id);
        if (task != null) {
            entityManager.remove(task);
        }
    }
}