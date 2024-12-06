package com.devsync.repository.Implementations;

import com.devsync.domain.entity.Tag;
import com.devsync.domain.entity.Task;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;

import java.util.List;

public class TagRepository {

    EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("devin");
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    EntityTransaction transaction = entityManager.getTransaction();


    public boolean save(Tag tag) {
        boolean isSaved = false;
        try {
            transaction.begin();

            entityManager.persist(tag);

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



    public List<Tag> findAll() {
        return entityManager.createQuery("SELECT tg FROM Tag tg ", Tag.class).getResultList();
    }

    public Tag findById(Long id) {
        return entityManager.find(Tag.class, id);
    }


}
