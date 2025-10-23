package com.rhxmanager.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaUtil {

    private static final String PERSISTENCE_UNIT_NAME = "rhxmanagerPU";
    private static EntityManagerFactory factory;

    static {
        try {
            factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }

    public static void shutdown() {
        if (factory != null) {
            factory.close();
        }
    }
}
