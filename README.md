# Démo d'Intégration Ballerina - Spring Boot

Ce projet est une démonstration d'une architecture à trois niveaux utilisant :
- Un frontend HTML/JavaScript
- Un middleware Ballerina
- Un backend Spring Boot

## Architecture

```
Frontend (client.html) --> Middleware (Ballerina) --> Backend (Spring Boot)
    file://                Port 8080                Port 8081
```

## Composants

1. **Backend (Spring Boot)**
   - API REST simple qui accepte prénom/nom et renvoie un message de salutation
   - Écoute sur le port 8081

2. **Middleware (Ballerina)**
   - Transforme une requête avec nom complet en prénom/nom
   - Gère les requêtes CORS
   - Écoute sur le port 8080

3. **Frontend (HTML/JavaScript)**
   - Interface utilisateur simple
   - Affiche les requêtes et réponses en temps réel
   - Montre la transformation des données à chaque étape

## Prérequis

- Java 17 ou supérieur
- Ballerina

## Lancement de l'application

1. **Démarrer le backend Spring Boot** :
   ```bash
   cd /Users/mloubari/Projects/Chaima/balllerina-expo
   java -jar target/balllerina-expo-1.0.0.jar
   ```

2. **Démarrer le middleware Ballerina** :
   ```bash
   cd /Users/mloubari/Projects/Chaima/balllerina-expo
   bal run middleware.bal
   ```

3. **Accéder à l'application** :
   - Ouvrir le fichier `client.html` directement dans votre navigateur préféré
   - Ou double-cliquer sur le fichier dans votre explorateur de fichiers

## Test de l'application

1. Entrez un nom complet (par exemple "Chaima Loubari") dans le champ de texte
2. Cliquez sur "Send to Ballerina"
3. Observez :
   - La requête envoyée au middleware
   - La transformation effectuée pour le backend
   - La réponse du backend
   - La réponse finale du middleware

## Structure des données

### Requête frontend → middleware
```json
{
  "fullName": "Chaima Loubari"
}
```

### Requête middleware → backend
```json
{
  "firstName": "Chaima",
  "lastName": "Loubari"
}
```

### Réponse backend → middleware
```json
{
  "greeting": "Hello, Chaima Loubari!"
}
```

### Réponse middleware → frontend
```json
{
  "msg": "Hello, Chaima Loubari!"
}
```
