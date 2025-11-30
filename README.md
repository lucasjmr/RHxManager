# RHxManager

**RHxManager** est une application web de gestion des ressources humaines (GRH) développée en Java (Jakarta EE). Elle permet aux administrateurs de gérer les employés, les départements, les projets et les fiches de paie au sein d'une organisation.

## 👥 Auteurs

* Lucas J.
* Pierre G.
* Maxime D.
* Armand P.
* Gabriel B.

## 🚀 Fonctionnalités

* **Authentification sécurisée** : Connexion par session avec hachage des mots de passe (PBKDF2).
* **Gestion des Employés** : Ajout, modification, suppression, recherche et attribution de rôles (ADMIN/EMPLOYE).
* **Gestion des Départements** : Création de départements et assignation de managers.
* **Gestion de Projets** : Suivi des projets par état (En cours, Terminé, Annulé) et constitution des équipes.
* **Fiches de Paie** : Génération de bulletins de salaire avec calcul automatique (Bonus, Déductions, Net à payer).
* **Tableau de Bord** : Vue synthétique des statistiques de l'entreprise.

## 🛠 Stack Technique

* **Langage** : Java (JDK 17+)
* **Framework Web** : Jakarta EE 10 (Servlets, JSP, JSTL)
* **ORM** : Hibernate 7.1
* **Base de données** : MySQL 8+
* **Build Tool** : Maven
* **Serveur d'application** : Apache Tomcat 10.1+ (Support Jakarta EE requis)

## ⚙️ Prérequis

Assurez-vous d'avoir installé :
1.  **Java JDK 17** ou supérieur.
2.  **Apache Maven**.
3.  **MySQL Server**.
4.  **Apache Tomcat 10** (ou tout autre serveur compatible Jakarta EE 10).

## 📦 Installation et Configuration

### 1. Base de données
1.  Connectez-vous à votre instance MySQL.
2.  Exécutez le script SQL situé dans `data/database.sql`.
    * Cela créera la base de données `rhxmanager`, les tables nécessaires et un utilisateur par défaut.

### 2. Configuration JDBC
Vérifiez les paramètres de connexion à la base de données dans le fichier :
`src/main/resources/META-INF/persistence.xml`

Modifiez les lignes suivantes si votre configuration MySQL est différente (notamment le mot de passe) :
```xml
<property name="jakarta.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/rhxmanager"/>
<property name="jakarta.persistence.jdbc.user" value="root"/>
<property name="jakarta.persistence.jdbc.password" value=""/>
````

### 3\. Compilation (Build)

À la racine du projet, ouvrez un terminal et lancez :

```bash
mvn clean install
```

Cela générera le fichier **RHxManager.war** dans le dossier `target/`.

### 4\. Déploiement

1.  Copiez le fichier `.war` généré.
2.  Collez-le dans le dossier `webapps` de votre installation Tomcat.
3.  Démarrez Tomcat (`bin/startup.sh` ou `bin/startup.bat`).

## 🖥️ Utilisation

Une fois le serveur démarré, accédez à l'application via :

> **URL :** `http://localhost:8080/RHxManager`

### Identifiants par défaut

Utilisez le compte administrateur créé par le script SQL pour vous connecter :

  * **Nom d'utilisateur :** `aze`
  * **Mot de passe :** `aze`

