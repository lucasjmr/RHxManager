package com.rhxmanager.dao;

import java.util.List;
import java.util.Optional;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.criteria.CriteriaQuery;

public class GenericDao<T, ID> {

    private final Class<T> entityClass;

    public GenericDao(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    public void save(T entity) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.persist(entity);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public Optional<T> findById(ID id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(entityClass, id));
        } finally {
            em.close();
        }
    }

    public void update(T entity) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.merge(entity);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public void delete(T entity) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.remove(em.contains(entity) ? entity : em.merge(entity));
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<T> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            CriteriaQuery<T> criteria = em.getCriteriaBuilder().createQuery(entityClass);
            criteria.select(criteria.from(entityClass));
            return em.createQuery(criteria).getResultList();
        } finally {
            em.close();
        }
    }
}
