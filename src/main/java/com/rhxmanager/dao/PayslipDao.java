package com.rhxmanager.dao;

import com.rhxmanager.model.Payslip;
import com.rhxmanager.util.JpaUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class PayslipDao extends GenericDao<Payslip, Integer> {

    public PayslipDao() {
        super(Payslip.class);
    }

    public List<Payslip> findAllWithEmployee() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Payslip p JOIN FETCH p.employe", Payslip.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<Payslip> findByIdWithEmployee(int id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<Payslip> query = em.createQuery(
                    "SELECT p FROM Payslip p JOIN FETCH p.employe e LEFT JOIN FETCH e.department WHERE p.id_payslip = :id", Payslip.class);
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (Exception e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public boolean exists(int employeeId, int month, int year) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "SELECT COUNT(p) FROM Payslip p WHERE p.employe.id_employe = :empId AND p.month = :month AND p.year = :year", Long.class)
                    .setParameter("empId", employeeId)
                    .setParameter("month", month)
                    .setParameter("year", year)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    public List<Payslip> findByCriteria(int employeeId, int month, int year) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // On commence la requête de base
            StringBuilder queryString = new StringBuilder("SELECT p FROM Payslip p JOIN FETCH p.employe e WHERE 1=1");

            if (employeeId > 0) {
                queryString.append(" AND e.id_employe = :empId");
            }
            if (month > 0) {
                queryString.append(" AND p.month = :month");
            }
            if (year > 0) {
                queryString.append(" AND p.year = :year");
            }

            queryString.append(" ORDER BY p.year DESC, p.month DESC");

            TypedQuery<Payslip> query = em.createQuery(queryString.toString(), Payslip.class);

            if (employeeId > 0) {
                query.setParameter("empId", employeeId);
            }
            if (month > 0) {
                query.setParameter("month", month);
            }
            if (year > 0) {
                query.setParameter("year", year);
            }

            return query.getResultList();
        } finally {
            em.close();
        }
    }
}