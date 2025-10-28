package com.rhxmanager.dao;

import com.rhxmanager.model.Department;
import com.rhxmanager.model.Employe;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DepartmentDao extends GenericDao<Department, Integer> {

    public DepartmentDao() {
        super(Department.class);
    }

    public Optional<Department> findByName(String name) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Department> query = em.createQuery(
                    "SELECT d FROM Department d WHERE d.departmentName = :name", Department.class
            );
            query.setParameter("name", name);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Department> findAllWithEmployees() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT DISTINCT d FROM Department d LEFT JOIN FETCH d.employees LEFT JOIN FETCH d.manager", Department.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Department> findByIdWithEmployees(int id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Department> query = em.createQuery(
                    "SELECT d FROM Department d LEFT JOIN FETCH d.employees LEFT JOIN FETCH d.manager WHERE d.id_department = :departmentId",
                    Department.class
            );
            query.setParameter("departmentId", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Department> findDepartmentsManagedBy(Employe manager) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Department> query = em.createQuery(
                    "SELECT d FROM Department d WHERE d.manager = :manager", Department.class
            );
            query.setParameter("manager", manager);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}