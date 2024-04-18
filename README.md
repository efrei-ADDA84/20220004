# 20220004
Repository of Mahir AKHAYAR


# TP1
# Wrapper de météo avec Docker et Trivy:

Ce projet consiste à créer un wrapper Python qui récupère la météo d'un lieu donné en utilisant les coordonnées de latitude et de longitude, en utilisant l'API OpenWeatherMap. Le code est ensuite empaqueté dans une image Docker, qui est ensuite mise à disposition sur DockerHub. De plus, l'image Docker est scannée pour les vulnérabilités à l'aide de Trivy.

# Contenu du Repository:

weather_wrapper.py: Le script Python qui agit comme un wrapper pour l'API OpenWeatherMap. Il prend les coordonnées de latitude et de longitude en entrée et retourne les données de météo pour ce lieu.
Dockerfile: Le fichier Dockerfile utilisé pour construire l'image Docker contenant le script Python et ses dépendances.


# Installation :

docker pull mhrr/20220004:latest

docker run --env LAT="5.902785" --env LONG="102.754175" --env API_KEY="YOUR_KEY" weatherapp:latest

Ensuite vous aurez les résultats 


## 1. Création du Wrapper Python
Créez un script Python (weather_wrapper.py) qui utilise l'API OpenWeatherMap pour récupérer les données météorologiques en fonction des coordonnées de latitude et de longitude fournies.
Assurez-vous d'utiliser des variables d'environnement pour stocker la clé API OpenWeatherMap, la latitude et la longitude.

## 2. Création du Dockerfile

```
FROM python:3.9-alpine
WORKDIR /app
COPY weather_wrapper.py .
RUN pip install requests
CMD ["python", "weather_wrapper.py"]
```
## 3. Construction de l'Image Docker

Utilisez la commande 
```
docker build -t weatherapp .
```
pour construire l'image Docker à partir du Dockerfile.
Assurez-vous de tagger l'image avec une version spécifique si vous voulez.

## 4. Mise à Disposition sur DockerHub

Connectez-vous à votre compte DockerHub en utilisant : 

```
docker login
```
Pour push l'image sur dockerhub :
```
docker tag weatherapp mhrr/20220004
```
Puis appuyé sur les trois petits points à côté de l'image créée et appuyé sur "Push to Hub".

OU 

Utilisez la commande : 

```
 docker push mhrr\weatherapp
```
pour pousser votre image Docker sur DockerHub.
Assurez-vous que l'image est accessible publiquement si nécessaire.

## 5. Analyse des Vulnérabilités avec Trivy

Installé Trivy sur votre système via docker.
commande 
```
docker run aquasec/trivy image mhrr/20220004
```
pour scanner l'image Docker que vous avez créée avec Trivy.

Mesure prise en modifiant sur le dockerfile le FROM python:3.9-slim par FROM python:3.9-alpine

## 6.  lint errors on Dockerfile (hadolint)

Pour vérifier s'il y a des erreurs de style dans votre Dockerfile, exécutez la commande suivante :

```
docker run --rm -i hadolint/hadolint < Dockerfile
```
Pour corriger les erreurs détectées,  j'ai ajouté la spécification de la version et l'option --no-cache-dir lors de l'installation du package requests dans votre Dockerfile. Cela a permis de supprimer les erreurs signalées par Hadolint.

## 7. Aucune données sensible

Pour garantir qu'aucune donnée sensible, comme la clé API OpenWeather, n'est stockée dans l'image Docker.


# TP2 DevOps - Création d'une API météo avec Docker, Flask et OpenWeatherMap

Ce tp consiste à créer une API météo qui utilise l'API OpenWeatherMap pour récupérer les données météorologiques d'un lieu donné en fonction de sa latitude et de sa longitude. L'API est développée en Python avec le framework Flask et est encapsulée dans un conteneur Docker pour une portabilité et une facilité de déploiement.

## Utilisation

Récuperer l'image
```
Docker pull mhrr/latest
```

Run le serveur 
```
docker run -p 8081:8081 --env API_KEY=YOUR_API mhrr/20220004
```

Test
```
curl "http://localhost:8081/?lat=5.902785&lon=102.754175"
```

## 1 . Github Workflows 

GitHub Actions pour automatiser le processus de construction et de poussée d'une image Docker sur Docker Hub à chaque nouveau commit sur la branche principale (main). Cela garantit que l'image Docker est mise à jour automatiquement à chaque modification du code source

### Workflow GitHub Actions

Le workflow GitHub Actions est configuré dans le fichier .github/workflows/docker-image.yml. Voici un aperçu du workflow :

```
name: Docker Image CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:

  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: docker build -t mhrr/20220004:latest .
      
    - name: Log in to Docker Hub
      run: echo ${{ secrets.DOCKERHUB_PASSWORD }} | docker login --username ${{ secrets.DOCKERHUB_USERNAME }} --password-stdin

    - name: Push Docker image to Docker Hub
      run: docker push mhrr/20220004:latest
```

Ce workflow est déclenché à chaque nouveau commit sur la branche principale. Il effectue les étapes suivantes :

Checkout repository : Récupère les fichiers du dépôt GitHub.
Build the Docker image : Construit l'image Docker à partir du Dockerfile dans le répertoire racine du dépôt.
Log in to Docker Hub : Connecte à Docker Hub en utilisant les informations d'identification fournies dans les secrets GitHub.
Push Docker image to Docker Hub : Pousse l'image Docker nouvellement construite sur Docker Hub.

### Configuration

configuration des secrets suivants dans les paramètres du dépôt GitHub :

DOCKERHUB_USERNAME : Le nom d'utilisateur du compte Docker Hub.
DOCKERHUB_PASSWORD : Le mot de passe ducompte Docker Hub.
Ces secrets permettent à GitHub Actions de se connecter à Docker Hub et de pousser l'image Docker.

Cela nous permet par la suite de publier automatiquement a chaque push sur Docker Hub

# 2 . Transformer le wrapper en API

Définition de l'endpoint: L'endpoint de l'API est défini avec @app.route('/'), ce qui signifie que l'API écoute les requêtes HTTP à la racine de l'URL.

Récupération des paramètres: Les paramètres de latitude et de longitude sont extraits de la requête HTTP GET à l'aide de request.args.get('lat') et request.args.get('lon').

Récupération de la clé API: La clé API OpenWeatherMap est récupérée à partir des variables d'environnement avec os.environ.get('API_KEY').

Construction de l'URL de l'API météo: L'URL de l'API OpenWeatherMap est construite en utilisant les paramètres de latitude, de longitude et la clé API.

Envoi de la requête à l'API météo: Une requête HTTP GET est envoyée à l'API OpenWeatherMap en utilisant l'URL construite avec requests.get(url).

Traitement de la réponse: La réponse JSON de l'API est traitée. Si la réponse est réussie (code 200), les données météorologiques (description du temps et température) sont extraites de la réponse. Sinon, un message d'erreur est renvoyé.

# 3 . Difficultés

Lorsque j'ai confronté ce problème sur Windows, j'ai rapidement réalisé que la commande docker run --network host --env API_KEY=**** maregistry/efrei-devops-tp2:1.0.0 ne fonctionnait pas comme prévu. Après quelques recherches, j'ai découvert que la raison résidait dans les différences de comportement entre Docker sur macOS et Docker sur Windows.

La solution que j'ai trouvée pour que cela fonctionne sur Windows était de modifier la commande pour exposer explicitement le port du conteneur et de définir une correspondance de port entre l'hôte et le conteneur. Ainsi, j'ai utilisé la commande suivante : docker run -p 8081:8081 --env API_KEY=190cfca07aff8b6a629657b083d72998 mhrr/20220004.

En utilisant l'option -p 8081:8081, je spécifie que le port 8081 du conteneur doit être exposé sur le port 8081 de l'hôte. Cela permet à l'application Flask dans le conteneur d'être accessible depuis l'extérieur via le port 8081 de l'hôte. De plus, j'ai toujours utilisé l'environnement API_KEY pour fournir la clé API OpenWeatherMap nécessaire à l'application.

Cette modification de la commande a permis de résoudre le problème de connectivité entre le conteneur Docker et l'hôte sur Windows, et j'ai pu utiliser l'API météo comme prévu.

# Bonus 

## Hadolint 

Incorporation de Hadolint dans mon flux de travail GitHub m'a permis d'automatiser la vérification de mon Dockerfile à chaque fois que je faisais un commit. Ainsi, chaque modification apportée au Dockerfile était immédiatement évaluée, et je recevais des commentaires sur les éventuelles erreurs ou violations des bonnes pratiques.

```
- name: Hadolint
      uses: hadolint/hadolint-action@v3.1.0
      with:
        dockerfile: Dockerfile
        fail-on: warning,error
```

## Sécurité 

Lorsque j'ai développé mon application et configuré mon environnement Docker, j'ai veillé à ne pas stocker de données sensibles dans le code source ou dans l'image Docker. Cela inclut des éléments tels que les clés API OpenWeatherMap, les informations d'identification Docker Hub ou toute autre information confidentielle.

Gestion des variables d'environnement : Plutôt que d'inclure directement des clés API ou des informations d'identification dans le code source, j'ai utilisé des variables d'environnement pour les stocker. Cela permet de les injecter dynamiquement dans le conteneur Docker au moment de son exécution, sans qu'elles ne soient exposées dans le code source.

Pour gérer mes identifications Docker Hub de manière sécurisée, j'ai utilisé des paramètres spécifiques à mon dépôt git, tel que l'outil de gestion de secrets comme Git Secret. 

# tp3
