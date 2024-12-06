package com.devsync.repository.Implementations;

import com.devsync.domain.entity.Task;
import com.devsync.domain.entity.Token;
import com.devsync.domain.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;

import java.util.List;

public class TokenRepository {

    EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("devin");
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    EntityTransaction transaction = entityManager.getTransaction();


    public boolean save(Token token) {
        boolean isSaved = false;
        try {
            transaction.begin();

            entityManager.persist(token);

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
            if (entityManagerFactory.isOpen()) {
                entityManagerFactory.close();
            }
        }
        return isSaved;

    }


    public Token update(Token token) {
        EntityManager entityManager = entityManagerFactory.createEntityManager();
        EntityTransaction transaction = entityManager.getTransaction();
        try {
            transaction.begin();
            Token updttoken = entityManager.merge(token);
            transaction.commit();
            return updttoken;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
        }

        return null;
    }


    public List<Token> findAll() {
        return entityManager.createQuery("SELECT tk FROM Token tk ", Token.class).getResultList();
    }

    public Token findById(Long id) {
        return entityManager.find(Token.class, id);
    }

    public Token findByUser(User user) {
        return entityManager.createQuery(
                    "SELECT tk FROM Token tk WHERE tk.user = :user", Token.class)
                .setParameter("user", user)
                .getSingleResult();
    }


}
