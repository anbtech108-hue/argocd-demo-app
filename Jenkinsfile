pipeline {
    agent any

    environment {
        IMAGE_NAME = "anbtech108/argocd-demo"
    }

    stages {

        stage('Clone') {
            steps {
                git 'https://github.com/anbtech108-hue/argocd-demo-app.git'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $IMAGE_NAME:latest'
                }
            }
        }
    }
}