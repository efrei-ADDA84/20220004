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

# TP3 - Utilisation d'une API météo avec Azure et Prometheus
Ce TP vise à déployer une API météo à l'aide de Docker, Azure Container Registry (ACR) et Azure Container Instance (ACI). De plus, nous ajouterons l'exposition de métriques Prometheus pour surveiller notre application.

## Utilisation de l'API météo

Vous pouvez interagir avec l'API météo en utilisant Curl avec la commande suivante :
```
curl "http://devops-20220004.francecentral.azurecontainer.io:8081/?lat=5.902785&lon=102.754175"
```
Cette commande enverra une requête à notre API déployée sur Azure, fournissant les coordonnées de latitude et de longitude pour obtenir les informations météorologiques correspondantes.

## Déploiement sur Azure
Pour déployer l'application sur Azure, nous utilisons GitHub Actions pour automatiser le processus de construction et de déploiement. Voici les étapes effectuées dans le fichier YAML de notre workflow :

Connexion à Azure Container Registry (ACR) : Nous nous connectons à Azure Container Registry en utilisant les informations d'identification stockées dans les secrets GitHub.

```
- name: Log in to Azure Container Registry
      uses: docker/login-action@v1
      with: 
        registry: ${{ secrets.REGISTRY_LOGIN_SERVER }}
        username: ${{ secrets.REGISTRY_USERNAME }}
        password: ${{ secrets.REGISTRY_PASSWORD }}
```

Construction et poussée de l'image Docker vers ACR : L'image Docker est construite à nouveau et poussée vers Azure Container Registry (ACR) pour une gestion plus sécurisée des conteneurs.

```
- name: Build and push Docker image to ACR
      uses: docker/build-push-action@v2
      with:
        context: .
        file: ./Dockerfile
        push: true
        tags: ${{ secrets.REGISTRY_LOGIN_SERVER }}/20220004:latest
```

Connexion à Azure : Nous nous connectons à Azure en utilisant les informations d'identification stockées dans les secrets GitHub.

```
- name: 'Login via Azure CLI'
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
```

Déploiement sur Azure Container Instance (ACI) : L'application est déployée sur Azure Container Instance en utilisant l'image Docker stockée dans Azure Container Registry. Nous spécifions le groupe de ressources, le nom de l'instance, le label DNS, l'emplacement géographique, les informations d'identification du registre Docker, ainsi que les variables d'environnement sécurisées pour notre clé API. De plus, nous avons spécifié le port 8081 pour l'écoute de l'application.

```
- name: 'Deploy to Azure Container Instance'
      uses: azure/aci-deploy@v1
      with:
        resource-group: ${{ secrets.RESOURCE_GROUP }}
        dns-name-label: devops-20220004
        image: ${{ secrets.REGISTRY_LOGIN_SERVER }}/20220004:latest
        name: 20220004
        location: francecentral
        registry-login-server: ${{ secrets.REGISTRY_LOGIN_SERVER }}
        registry-username: ${{ secrets.REGISTRY_USERNAME }}
        registry-password: ${{ secrets.REGISTRY_PASSWORD }}
        secure-environment-variables: API_KEY=${{ secrets.API_KEY }}
        ports: 8081
```

les secrets nécessaires sont correctement configurés dans les paramètres de votre référentiel GitHub, notamment :

DOCKERHUB_USERNAME et DOCKERHUB_PASSWORD : Informations d'identification Docker Hub.
REGISTRY_LOGIN_SERVER, REGISTRY_USERNAME et REGISTRY_PASSWORD : Informations d'identification Azure Container Registry.
AZURE_CREDENTIALS : Informations d'identification Azure pour se connecter à Azure.
API_KEY : Clé d'API nécessaire pour l'application.

L'utilisation de GitHub Actions combinée à Azure permet une automatisation efficace du processus de construction et de déploiement de l'application, offrant ainsi une expérience de développement et de déploiement fluide et sécurisée.

## Utilisation de métriques Prometheus dans notre application
Cette partie de notre application consiste à intégrer des métriques Prometheus pour surveiller les performances en temps réel. Voici comment cela fonctionne :

### Intégration des métriques Prometheus
Nous avons intégré la bibliothèque Prometheus Client à notre application Flask. Cette bibliothèque nous permet de créer des compteurs pour suivre le nombre de requêtes reçues.

### Point de terminaison /metrics
Nous avons ajouté un point de terminaison /metrics à notre application. Lorsque vous accédez à ce point de terminaison, notre application renvoie les métriques Prometheus au format texte.

### Métriques disponibles
Les métriques disponibles comprennent notamment le nombre total de requêtes reçues par notre application. Ces métriques nous permettent de surveiller les performances de notre application et d'identifier les éventuels goulets d'étranglement.

### Comment utiliser
Pour accéder aux métriques Prometheus, il vous suffit de faire une requête GET vers le point de terminaison /metrics de notre application.
```
curl "http://devops-20220004.francecentral.azurecontainer.io:8081/?lat=5.902785&lon=102.754175"
```
Cela renverra les métriques Prometheus au format texte, que vous pouvez ensuite utiliser pour surveiller les performances de notre application.



# TP4 : Création d'une machine virtuelle Azure avec Terraform

Création d'une machine virtuelle Azure (VM) avec une adresse IP publique dans un réseau existant à l'aide de Terraform.

## Utilisation 

### Initialisation de Terraform :
iInitialiser Terraform dans le répertoire du projet
```
terraform init
```

### Prévisualisation du déploiement :
Effectuer une prévisualisation des changements que Terraform va appliquer à votre infrastructure :
```
terraform plan
```

### Déploiement de l'infrastructure :
Déployer l'infrastructure sur Azure
```
terraform apply
```

### Récupération de la PrivateKey 
Cette commande est utilisée pour afficher la sortie de la clé privée SSH générée dans le fichier Terraform. Cette clé privée est générée à l'aide du module tls_private_key dans le fichier ssh.tf
```
terraform output private_key_pem
```

### Connexion à la machine virtuelle :
Récupérer l'adresse IP publique de la machine virtuelle à partir de la sortie de Terraform. Utiliser la commande SSH pour vous connecter à la machine virtuelle :
```
ssh -i PrivateKey.pem  devops@52.143.143.48 cat /etc/os-release
```

"PrivateKey.pem" : Création de ce fichier via le contenu généré précédemment.
"52.143.143.48" : Adresse IP publique récupérée après avoir créé la machine virtuelle."

### Nettoyage des ressources :
Supprimer toutes les ressources déployées en exécutant la commande
```
terraform destroy
```

## Structure du code

Le code Terraform est organisé en plusieurs fichiers pour une meilleure gestion et modularité :

### data.tf : 
Ce fichier regroupe les définitions des données requises, telles que le réseau virtuel et le sous-réseau existants. Il utilise le module azurerm_virtual_network pour récupérer les informations sur le réseau virtuel et le module azurerm_subnet pour obtenir les détails du sous-réseau.

### main.tf : 
Ce fichier est le point central de la configuration. Il définit le fournisseur Azure, spécifie les détails de l'emplacement (location) et crée l'interface réseau principale de la machine virtuelle. Il utilise le module azurerm_network_interface pour créer une interface réseau avec une configuration IP.

### network.tf : 
Ce fichier contient la configuration spécifique au réseau de la machine virtuelle. Il définit la création de la carte réseau de la machine virtuelle et alloue une adresse IP publique à cette carte réseau à l'aide du module azurerm_public_ip.

### ssh.tf : 
Ici, la génération de la clé SSH est gérée à l'aide du module tls_private_key. Ce fichier définit également des sorties pour récupérer la clé privée et la clé publique générées. Cela permet une utilisation pratique des clés SSH pour l'authentification SSH ultérieure.

### variables.tf : 
Toutes les variables nécessaires au déploiement sont déclarées dans ce fichier. Cela inclut des variables telles que le nom de la machine virtuelle, le nom d'utilisateur administrateur, l'emplacement, etc. Définir ces variables dans un fichier séparé facilite la personnalisation et la gestion des valeurs.

### virtualmachine.tf : 
Ce fichier contient la configuration spécifique de la machine virtuelle Linux. Il définit la machine virtuelle elle-même en utilisant le module azurerm_linux_virtual_machine. Il comprend des détails tels que la personnalisation de l'image, la configuration du disque OS, la définition du nom d'utilisateur administrateur, et la configuration SSH pour permettre l'accès sécurisé à la machine virtuelle.

Cette structure modulaire rend le code Terraform plus lisible, plus facile à gérer et favorise la réutilisation des composants. Chaque fichier se concentre sur une tâche spécifique, ce qui simplifie le processus de développement, de maintenance et de débogage de l'infrastructure Azure déployée.


## Bonus 

1. Installation de Docker avec cloud-init

Un script est lancé au démarrage de la machine virtuelle pour installer Docker à l'aide de cloud-init. 

```
  custom_data = base64encode(<<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                sudo apt-get update
                sudo apt-get install -y docker-ce
                EOF
  )

  
```

Cette approche automatisée simplifie le processus de configuration de la machine virtuelle en installant Docker dès son démarrage. Cela permet d'accélérer le déploiement d'applications conteneurisées et de rendre l'environnement de développement plus flexible et réactif.

2. Utilisation de variables et aucune duplication de code
Pour assurer une meilleure gestion du code Terraform, les variables ont été largement utilisées, ce qui permet une personnalisation facile et une réutilisation efficace du code, avec le fichier variables.tf où est toutes les variables de ce projet sont stockées.

variables.tf:

```
variable "vm_name" {
  default = "devops-20220004"
}

variable "admin_username" {
  default = "devops"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "subnet_name" {
  default = "internal"
}

variable "virtual_network_name" {
  default = "network-tp4"
}

variable "subnet_address_prefix" {
  default = "10.0.1.0/24"
}

variable "location" {
  default = "francecentral"
}

variable "resource_group_name" {
  default = "ADDA84-CTP"
}

variable "subscription_id" {
  default = "765266c6-9a23-4638-af32-dd1e32613047"
}
```

De plus, aucune duplication de code n'a été autorisée, conformément aux bonnes pratiques de développement, ce qui garantit la cohérence et la maintenabilité du code Terraform.

3. Formatage correct du code Terraform
Le code Terraform a été correctement formaté grâce à la commande suivante :

```
terraform fmt
```

qui est utilisé avant le terraform init pour garantir la lisibilité et la cohérence du code Terraform.

## Conclusion

Pour conclure, terraform est un outil précieux pour déployer des ressources sur le cloud. En utilisant Terraform, les équipes peuvent automatiser le déploiement de l'infrastructure, assurer sa cohérence et sa reproductibilité, et gérer facilement les configurations complexes. Cela permet d'accélérer les déploiements, de réduire les erreurs humaines et d'assurer une gestion efficace de l'état de l'infrastructure. En adoptant Terraform, les organisations peuvent bénéficier d'une meilleure agilité opérationnelle, d'une scalabilité accrue et d'une meilleure fiabilité de leurs environnements cloud.



