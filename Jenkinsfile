pipeline {
    agent any

    environment {
        IMAGE_NAME = "anbtech108/argocd-demo-demo-app1"
        VERSION = "v${env.BUILD_NUMBER}"  // Jenkins build number as version
    }

    stages {

        stage('Checkout App Repo') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/anbtech108-hue/argocd-demo-app.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$VERSION ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker push $IMAGE_NAME:$VERSION
                    """
                }
            }
        }

        stage('Update GitOps Repo') {
            steps {
                dir('../ArgoCD-Demo/development') {  // path to your GitOps repo
                    sh """
                        git pull origin main
                        sed -i 's|image:.*|image: $IMAGE_NAME:$VERSION|' deployment.yaml
                        git add deployment.yaml
                        git commit -m "Update image tag to $VERSION"
                        git push origin main
                    """
                }
            }
        }
    }
}