package com.rhxmanager.model;

import jakarta.persistence.*;
import java.util.Set;
import java.util.HashSet;
import com.rhxmanager.model.ProjectState;

@Entity
@Table(name = "Project")
public class Project {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id_project;

    @Column(nullable = false)
    private String projectName;

    @Enumerated(EnumType.STRING)
    private ProjectState state;

    // ------------------------------------------

    @OneToOne
    @JoinColumn(name = "masterChief_id", referencedColumnName = "id_employe")
    private Employe projectLead;

    @ManyToMany(mappedBy = "projects")
    private Set<Employe> employees = new HashSet<>();

    // ------------------------------------------


    public Project() {
    }
    public int getId_project() {
        return id_project;
    }
    public String getProjectName() {
        return projectName;
    }
    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }
    public ProjectState getState() {
        return state;
    }
    public void setState(ProjectState state) {
        this.state = state;
    }
    public Employe getProjectLead() {
        return projectLead;
    }
    public void setProjectLead(Employe projectLead) {
        this.projectLead = projectLead;
    }
    public Set<Employe> getEmployees() {
        return employees;
    }
    public void setEmployees(Set<Employe> employees) {
        this.employees = employees;
    }

    @Override
    public String toString() {
        return "Project{" +
                "id_project=" + id_project +
                ", projectName='" + projectName + '\'' +
                ", state=" + state +
                ", projectLead=" + projectLead +
                ", employees=" + employees +
                '}';
    }
}
