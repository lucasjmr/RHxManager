package com.rhxmanager.dao;

import com.rhxmanager.model.Department;

public class DepartmentDao extends GenericDao<Department, Integer> {

    public DepartmentDao() {
        super(Department.class);
    }
}