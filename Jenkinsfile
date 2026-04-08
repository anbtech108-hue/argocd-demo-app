pipeline {
    agent any

    environment {
        IMAGE_NAME = "anbtech108/argocd-demo-demo-app1"
        VERSION = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                // Ensure we fetch the correct branch
                git branch: 'main', url: 'https://github.com/anbtech108-hue/argocd-demo-app.git'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:v$VERSION ."
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME:v$VERSION
                    """
                }
            }
        }

        stage('Update GitOps Repo') {
            steps {
                // Optional: Only if you want to automatically update image tag in Argo CD repo
                sh """
                    cd ../argocd-manifests
                    sed -i 's|image:.*|image: $IMAGE_NAME:v$VERSION|' deployment-app1.yaml
                    git add deployment-app1.yaml
                    git commit -m 'Update app1 image to v$VERSION'
                    git push origin main
                """
            }
        }
    }
}