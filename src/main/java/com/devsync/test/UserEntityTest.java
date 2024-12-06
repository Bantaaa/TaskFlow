package com.devsync.test;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import com.devsync.domain.entity.User;

public class UserEntityTest {
    /*public static void main(String[] args) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = Persistence.createEntityManagerFactory("testPU");
            em = emf.createEntityManager();

            User user = new User();
            user.setUsername("testUser");
            user.setEmail("test@example.com");

            em.getTransaction().begin();

            em.persist(user);

            em.getTransaction().commit();

            System.out.println("User inserted successfully. ID: " + user.getId());

            em.clear();
            User retrievedUser = em.find(User.class, user.getId());

            if (retrievedUser != null) {
                System.out.println("Retrieved user: " + retrievedUser.getUsername() + ", " + retrievedUser.getEmail());
            } else {
                System.out.println("Failed to retrieve user.");
            }

        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em != null) em.close();
            if (emf != null) emf.close();
        }
    }*/



}