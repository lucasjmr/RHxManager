package com.rhxmanager.dao;

import  com.rhxmanager.model.Employe;
import com.rhxmanager.dao.GenericDAO;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.Optional;

public class EmployeDAO extends GenericDAO<Employe, Integer> {

    public EmployeDAO() {
        super(Employe.class);
    }

    public Optional<Employe> findByUsername(String username) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery(
                    "SELECT e FROM Employe e WHERE e.username = :username", Employe.class
            );
            query.setParameter("username", username);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty(); // Utilisateur non trouvé
        } finally {
            em.close();
        }
    }
}
