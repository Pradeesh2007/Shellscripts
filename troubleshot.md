# Complete Jenkins + Maven + Docker + Tomcat10 CI/CD Setup & Troubleshooting Reference

This is the full working setup and all troubleshooting steps we completed for your project.

---

# Final Architecture

```text id="2r6x9w"
GitHub Repository
        ↓
Jenkins Master
        ↓
Jenkins Slave/Agent (Ubuntu EC2)
        ├── Maven Build
        ├── Docker Build
        ├── Docker Container Deployment
        └── SCP WAR Deployment
                    ↓
            Remote Tomcat10 EC2
```

---

# Environment Used

## Jenkins Slave EC2

Installed:

* JDK 21
* Maven
* Docker
* Git

OS:

* Ubuntu

---

## Remote Server

Installed:

* Apache Tomcat 10

OS:

* Ubuntu EC2

---

# Maven Project Requirements

Project must generate WAR file.

In `pom.xml`:

```xml id="9m3v7q"
<packaging>war</packaging>
```

---

# Required Project Structure

```text id="5n1k8p"
src/
 └── main/
      ├── java/
      ├── resources/
      └── webapp/
           └── index.jsp
```

---

# Test JSP Page

File:

```text id="6x2r9m"
src/main/webapp/index.jsp
```

Content:

```jsp id="3f8w1n"
<h1>Deployment Successful</h1>
```

---

# Jenkins Slave Setup

Install Java + Maven:

```bash id="4p7x2k"
sudo apt update
sudo apt install openjdk-21-jdk maven git -y
```

Verify:

```bash id="8m5q1r"
java -version
mvn -version
```

---

# Docker Installation

Install Docker:

```bash id="1v9k4m"
sudo apt install docker.io -y
```

Start Docker:

```bash id="7w3x8p"
sudo systemctl enable docker
sudo systemctl start docker
```

---

# Docker Permission Fix

Main issue solved:

```text id="9q4r2w"
permission denied while trying to connect to docker.sock
```

Fix:

```bash id="2m8v5x"
sudo usermod -aG docker ansible
```

Apply:

```bash id="6n1x7q"
newgrp docker
```

OR reboot:

```bash id="4k9w2p"
sudo reboot
```

Verify:

```bash id="5r3m8x"
docker ps
```

---

# Jenkins Agent Configuration

In Jenkins:

## Manage Jenkins → Nodes

Create node:

| Field       | Value                 |
| ----------- | --------------------- |
| Name        | slave                 |
| Labels      | slave                 |
| Remote Root | /home/ansible/jenkins |

Launch:

* via SSH

---

# Jenkins Plugins Installed

Installed plugins:

* Pipeline
* Git
* Maven Integration
* SSH Agent Plugin
* Docker Pipeline

---

# SSH Key Setup

Generate key on slave:

```bash id="1z7m3q"
ssh-keygen -t rsa
```

Copy to Tomcat EC2:

```bash id="9v2x6k"
ssh-copy-id ubuntu@TOMCAT_IP
```

Test:

```bash id="8p1w5r"
ssh ubuntu@TOMCAT_IP
```

Must login without password.

---

# Jenkins Credentials Setup

## Correct Credential Type

Main issue solved:

```text id="4n8q1w"
Could not find specified credentials
```

Cause:

* credentials created under System scope
* wrong credential type

---

# Correct Credential

Create under:

```text id="6m3x8r"
Global Credentials
```

Type:

```text id="2k9w4p"
SSH Username with private key
```

Fields:

| Field       | Value               |
| ----------- | ------------------- |
| ID          | ubuntu              |
| Username    | ubuntu              |
| Private Key | paste ~/.ssh/id_rsa |

---

# Tomcat10 Setup

Tomcat webapps path found:

```text id="7p5x2m"
/var/lib/tomcat10/webapps/
```

---

# Tomcat Permission Fix

Issue:

```text id="5w8q1n"
Permission denied
```

Fix:

```bash id="9m2r6x"
sudo chown -R ubuntu:ubuntu /var/lib/tomcat10/webapps
```

---

# Dockerfile Used

File:

```text id="1x4p9m"
Dockerfile
```

Content:

```dockerfile id="6q8w3n"
FROM tomcat:10.1

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

---

# Why ROOT.war Was Needed

Issue:

```text id="2v5m8q"
HTTP 404 Not Found
```

Cause:

* WAR deployed as `myapp.war`
* app accessible at `/myapp`

Fix:

* deploy as `ROOT.war`

Now app works directly at:

```text id="3k9x1w"
http://SLAVE_IP:8090
```

---

# Final Working Jenkinsfile

```groovy id="4r7m2x"
pipeline {

    agent {
        label 'slave'
    }

    environment {

        TOMCAT_IP = '13.56.254.145'
        TOMCAT_PATH = '/var/lib/tomcat10/webapps/'

        IMAGE_NAME = 'fortask-app'
        CONTAINER_NAME = 'fortask-container'
    }

    stages {

        stage('Checkout') {

            steps {

                git branch: 'main',
                url: 'https://github.com/Pradeesh2007/fortask.git'
            }
        }

        stage('Build Maven') {

            steps {

                sh 'java -version'
                sh 'mvn -version'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Verify Artifact') {

            steps {

                sh 'ls -lh target/'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh """
                docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Stop Old Container') {

            steps {

                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                """
            }
        }

        stage('Run Docker Container') {

            steps {

                sh """
                docker run -d \
                --name ${CONTAINER_NAME} \
                -p 8090:8080 \
                ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Verify Container') {

            steps {

                sh 'docker ps'
            }
        }

        stage('Deploy to Remote Tomcat') {

            steps {

                sshagent(credentials: ['ubuntu']) {

                    sh """
                    scp -o StrictHostKeyChecking=no \
                    target/*.war \
                    ubuntu@${TOMCAT_IP}:${TOMCAT_PATH}myapp.war
                    """
                }
            }
        }
    }

    post {

        success {

            echo 'Deployment Successful'
        }

        failure {

            echo 'Pipeline Failed'
        }
    }
}
```

---

# URLs

## Docker Container

```text id="8n3w1p"
http://SLAVE_IP:8090
```

---

## Remote Tomcat

```text id="1m6q8x"
http://13.56.254.145:8080/myapp
```

---

# Troubleshooting Summary

---

## Problem 1 — Jenkins Tool Error

Error:

```text id="6r2w9m"
Tool type "jdk" does not have install configured
```

Fix:

* removed `tools {}` block
  OR
* configured Global Tool Configuration

---

## Problem 2 — sshagent Not Found

Error:

```text id="9x4m1q"
No such DSL method 'sshagent'
```

Fix:

* installed SSH Agent Plugin

---

## Problem 3 — Credentials Not Found

Error:

```text id="7m2q8w"
Could not find specified credentials
```

Fix:

* created Global SSH credential
* used correct ID

---

## Problem 4 — SCP Path Error

Error:

```text id="3p8x4n"
No such file or directory
```

Fix:

* corrected Tomcat path

Correct path:

```text id="2x9m6q"
/var/lib/tomcat10/webapps/
```

---

## Problem 5 — Docker Permission Error

Error:

```text id="4w7p2m"
permission denied docker.sock
```

Fix:

```bash id="8m1q5x"
sudo usermod -aG docker ansible
```

---

## Problem 6 — Docker 404

Error:

```text id="5x8n2q"
HTTP 404
```

Fix:

* changed WAR to ROOT.war

---

# Useful Commands

---

## Check Running Containers

```bash id="6q1x8m"
docker ps
```

---

## View Logs

```bash id="1m4w9x"
docker logs -f fortask-container
```

---

## Stop Container

```bash id="8p2x5q"
docker stop fortask-container
```

---

## Remove Container

```bash id="3n7w1m"
docker rm fortask-container
```

---

## Remove Docker Image

```bash id="5m9x2q"
docker rmi fortask-app
```

---

## Verify WAR Contents

```bash id="7x1m4q"
jar -tf target/*.war
```

---

# Recommended Future Improvements

Next steps you can implement:

* DockerHub push
* AWS ECR push
* Kubernetes deployment
* Nginx reverse proxy
* HTTPS SSL
* SonarQube scan
* Nexus artifact repository
* GitHub webhook auto-trigger
* Blue/Green deployment
* Multi-branch Jenkins pipeline

---

# Final Result

You successfully implemented:

✅ Jenkins distributed build
✅ Maven WAR build
✅ Remote Tomcat deployment
✅ Docker image build
✅ Docker container deployment
✅ SSH deployment automation
✅ CI/CD pipeline on EC2 infrastructure
