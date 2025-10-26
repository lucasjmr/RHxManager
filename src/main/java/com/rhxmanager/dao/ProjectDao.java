package com.rhxmanager.dao;

import com.rhxmanager.model.Project;
import com.rhxmanager.model.ProjectState;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class ProjectDao extends GenericDao<Project, Integer> {

    public ProjectDao() {
        super(Project.class);
    }

    public long countByState(ProjectState state) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(p) FROM Project p WHERE p.state = :stateValue", Long.class
            );
            query.setParameter("stateValue", state);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    public List<Project> findAllWithEmployees() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT DISTINCT p FROM Project p LEFT JOIN FETCH p.employees", Project.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Project> findByIdWithEmployees(int id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Project> query = em.createQuery(
                    "SELECT p FROM Project p LEFT JOIN FETCH p.employees WHERE p.id_project = :projectId",
                    Project.class
            );
            query.setParameter("projectId", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }
}