package com.devsync.repository.Implementations;

import com.devsync.domain.entity.Task;
import com.devsync.domain.entity.User;
import jakarta.persistence.*;
import jakarta.transaction.Transactional;

import java.sql.PreparedStatement;
import java.util.List;
import java.util.Optional;

public class TaskRepository {

    EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("devin");


    public boolean save(Task task) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        boolean isSaved = false;
        try {
            transaction.begin();

            entityManager.persist(task);

            transaction.commit();

            isSaved = true;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (entityManager.isOpen()) {
                entityManager.close();
            }
        }
        return isSaved;

    }



    public List<Task> findAll() {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        return entityManager.createQuery(
            "SELECT t FROM Task t " +
                "LEFT JOIN FETCH t.assignee " +
                "LEFT JOIN FETCH t.createdBy " +
                "LEFT JOIN FETCH t.tags",
            Task.class
        ).getResultList();

    }



    public Task findById(Long id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        return entityManager.find(Task.class, id);
    }

    public boolean delete(Long id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        boolean isDeleted = false;
        try {
            transaction.begin();
            Task task = entityManager.find(Task.class, id);
            if (task != null) {
                entityManager.remove(task);
                transaction.commit();
                isDeleted = true;
            } else {
                transaction.rollback();
            }
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (entityManager != null && entityManager.isOpen()) {
                entityManager.close();
            }
        }
        return isDeleted;
    }

    public boolean update(Task task) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        boolean isUpdated = false;
        try {
            transaction.begin();
            entityManager.merge(task);
            transaction.commit();
            isUpdated = true;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        return isUpdated;
    }

}
