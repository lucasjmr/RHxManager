# RHxManager

## 👥 Auteurs

* Lucas J.
* Pierre G.
* Maxime D.
* Armand P.
* Gabriel B.


## Infos Technique

* **Langage** : Java (JDK 17+)
* **Framework Web** : Jakarta EE 10 (Servlets, JSP, JSTL)
* **ORM** : Hibernate 7.1
* **Base de données** : MySQL 8+
* **Build Tool** : Maven
* **Serveur d'application** : Apache Tomcat 10.1+ (Support Jakarta EE requis)

## Prérequis

Assurez-vous d'avoir installé :
1.  **Java JDK 17** ou supérieur.
2.  **Apache Maven**.
3.  **MySQL Server**.
4.  **Apache Tomcat 10** (ou tout autre serveur compatible Jakarta EE 10).

## Installation et Configuration

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
