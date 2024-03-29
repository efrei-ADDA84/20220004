# 20220004
Repository of Mahir AKHAYAR

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

