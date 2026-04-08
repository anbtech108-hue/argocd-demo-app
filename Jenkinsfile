pipeline {
    agent any

    environment {
        APP_IMAGE = "anbtech108/argocd-demo-demo-app1"
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
        DOCKERHUB_CREDS = "docker-creds"       // Jenkins credential ID for DockerHub
        GITHUB_CREDS = "github-creds"           // Jenkins credential ID for GitHub
        GITOPS_REPO = "https://github.com/anbtech108-hue/ArgoCD-Demo.git"
        GITOPS_DIR = "ArgoCD-Demo"
    }

    stages {

        stage('Checkout App Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/anbtech108-hue/argocd-demo-app.git',
                    credentialsId: "${GITHUB_CREDS}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t $APP_IMAGE:$IMAGE_TAG .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push $APP_IMAGE:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Update GitOps Repo') {
            steps {
                // Clone or update the GitOps repo
                sh """
                    if [ ! -d "$GITOPS_DIR" ]; then
                        git clone $GITOPS_REPO
                    fi
                    cd $GITOPS_DIR/development
                    git checkout main
                    git pull origin main
                    # Update image tag in deployment.yaml
                    sed -i "s|image:.*|image: $APP_IMAGE:$IMAGE_TAG|" deployment.yaml
                    git add deployment.yaml
                    git commit -m "Update image tag to $IMAGE_TAG"
                    git push origin main
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully. Docker image: $APP_IMAGE:$IMAGE_TAG pushed and GitOps repo updated."
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}