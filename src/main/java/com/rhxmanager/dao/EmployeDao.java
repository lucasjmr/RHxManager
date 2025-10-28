package com.rhxmanager.dao;

import  com.rhxmanager.model.Employe;
import com.rhxmanager.model.Role;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;
import java.util.ArrayList;
import java.util.List;

import java.util.Optional;

public class EmployeDao extends GenericDao<Employe, Integer> {

    public EmployeDao() {
        super(Employe.class);
    }

    public List<Employe> findEmployeesWithoutDepartment() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery(
                    "SELECT e FROM Employe e WHERE e.department IS NULL", Employe.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
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
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Employe> search(String keyword) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Employe> cq = cb.createQuery(Employe.class);
            Root<Employe> employe = cq.from(Employe.class);

            List<Predicate> predicates = new ArrayList<>();
            String likePattern = "%" + keyword.toLowerCase() + "%";

            predicates.add(cb.like(cb.lower(employe.get("firstName")), likePattern));
            predicates.add(cb.like(cb.lower(employe.get("lastName")), likePattern));
            predicates.add(cb.like(cb.lower(employe.get("username")), likePattern));
            predicates.add(cb.like(cb.lower(employe.get("grade")), likePattern));
            predicates.add(cb.like(cb.lower(employe.get("jobName")), likePattern));

            if (keyword.matches("\\d+")) {
                predicates.add(cb.equal(employe.get("id_employe"), Integer.parseInt(keyword)));
            }

            Join<Employe, Role> roleJoin = employe.join("roles", JoinType.LEFT);
            predicates.add(cb.like(cb.lower(roleJoin.get("roleName")), likePattern));

            cq.where(cb.or(predicates.toArray(new Predicate[0])));

            return em.createQuery(cq).getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Employe> findByIdWithProjects(int id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Employe> query = em.createQuery(
                    "SELECT e FROM Employe e LEFT JOIN FETCH e.projects WHERE e.id_employe = :employeeId",
                    Employe.class
            );
            query.setParameter("employeeId", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public Optional<Employe> findForEdit(int id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // On utilise LEFT JOIN FETCH pour s'assurer de récupérer l'employé
            // même s'il n'a ni rôle ni projet.
            TypedQuery<Employe> query = em.createQuery(
                    "SELECT e FROM Employe e " +
                            "LEFT JOIN FETCH e.roles " +
                            "LEFT JOIN FETCH e.projects " +
                            "WHERE e.id_employe = :employeeId",
                    Employe.class
            );
            query.setParameter("employeeId", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Employe> findAllWithRoles() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT e FROM Employe e LEFT JOIN FETCH e.roles", Employe.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Employe> findAllWithDepartment() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // On utilise LEFT JOIN FETCH pour s'assurer de récupérer les employés
            // même s'ils n'ont pas encore de département.
            return em.createQuery("SELECT e FROM Employe e LEFT JOIN FETCH e.department", Employe.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
