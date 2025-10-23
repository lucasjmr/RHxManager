package com.rhxmanager.dao;

import com.rhxmanager.model.Project;
import com.rhxmanager.model.ProjectState;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

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
}