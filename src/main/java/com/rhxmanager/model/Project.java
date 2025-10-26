package com.rhxmanager.model;

import jakarta.persistence.*;

import java.util.Objects;
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

    @ManyToMany(mappedBy = "projects", cascade = { CascadeType.PERSIST, CascadeType.MERGE })
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
    public void addEmployee(Employe employee) {
        this.employees.add(employee);       // Ajoute l'employé à la liste du projet
        employee.getProjects().add(this);    // ET ajoute ce projet à la liste de l'employé
    }
    public void removeEmployee(Employe employee) {
        this.employees.remove(employee);     // Retire l'employé de la liste du projet
        employee.getProjects().remove(this);  // ET retire ce projet de la liste de l'employé
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Project project = (Project) o;
        return id_project != 0 && id_project == project.id_project;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id_project);
    }
}
