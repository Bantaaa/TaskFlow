package com.devsync.repository.Implementations;

import com.devsync.domain.entity.TaskRequest;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;

import java.util.List;

public class TaskRequestRepository {

    EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("devin");


    public boolean save(TaskRequest taskRequest) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        boolean isSaved = false;
        try {
            transaction.begin();

            entityManager.persist(taskRequest);

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

    public List<TaskRequest> findAll() {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        return entityManager.createQuery(
            "SELECT t FROM TaskRequest t " +
                "LEFT JOIN FETCH t.requestedBy " +
                "LEFT JOIN FETCH t.oldtask " +
                "LEFT JOIN FETCH t.newtask " +
                "WHERE t.type = :modificationType",
            TaskRequest.class

        ).setParameter("modificationType", "modification")
         .getResultList();


    }

    public TaskRequest findById(Long id) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        return entityManager.find(TaskRequest.class, id);
    }

    public boolean update(TaskRequest taskrequest) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        boolean isUpdated = false;
        try {
            transaction.begin();
            entityManager.merge(taskrequest);
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
