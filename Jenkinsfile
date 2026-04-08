pipeline {
    agent any
    environment {
        DOCKER_USER = credentials('docker-user')   // Docker username
        DOCKER_PASS = credentials('docker-pass')   // Docker password
        GIT_USER   = credentials('github-username') // GitHub username
        GIT_TOKEN  = credentials('github-token')    // GitHub Personal Access Token
    }
    stages {
        stage('Checkout App Repo') {
            steps {
                git branch: 'main',
                    url: 'http://github.com/anbtech108-hue/argocd-demo-app.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t anbtech108/argocd-demo-demo-app1:v15 .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push anbtech108/argocd-demo-demo-app1:v15
                '''
            }
        }

        stage('Update GitOps Repo') {
            steps {
                sh '''
                    if [ ! -d "ArgoCD-Demo" ]; then
                        git clone http://$GIT_USER:$GIT_TOKEN@github.com/anbtech108-hue/ArgoCD-Demo.git
                    fi
                    cd ArgoCD-Demo/development
                    git checkout main
                    git pull origin main
                    sed -i "s|image:.*|image: anbtech108/argocd-demo-demo-app1:v15|" deployment.yaml
                    git add deployment.yaml
                    git commit -m "Update image tag to v15" || echo "No changes to commit"
                    git push http://$GIT_USER:$GIT_TOKEN@github.com/anbtech108-hue/ArgoCD-Demo.git main
                '''
            }
        }
    }
    post {
        always {
            echo "Pipeline finished."
        }
        success {
            echo "Pipeline succeeded!"
        }
        failure {
            echo "Pipeline failed. Check the logs."
        }
    }
}