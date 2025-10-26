package com.rhxmanager.dao;

import com.rhxmanager.model.Role;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.Optional;

public class RoleDao extends GenericDao<Role, Integer> {

    public RoleDao() {
        super(Role.class);
    }

    public Optional<Role> findByName(String roleName) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Role> query = em.createQuery(
                    "SELECT r FROM Role r WHERE r.roleName = :name", Role.class
            );
            query.setParameter("name", roleName);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }
}