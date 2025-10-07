pipeline {
  agent any

  environment {
    DOCKER_USER = "deekshiya31"
    DEV_REPO = "${DOCKER_USER}/dev"
    DOCKERHUB_CREDENTIALS_ID = "dockerhub-creds"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'ls -la'
      }
    }

    stage('Build Docker image') {
      steps {
        sh 'docker build -t $DEV_REPO:latest .'
      }
    }

    stage('Push to DockerHub (Dev)') {
      when { branch 'dev' }
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DBUSER', passwordVariable: 'DBPASS')]) {
          sh '''
            echo "$DBPASS" | docker login -u "$DBUSER" --password-stdin
            docker push $DEV_REPO:latest
            docker logout
          '''
        }
      }
    }
  }

  post {
    success { echo "✅ Build & Push success" }
    failure { echo "❌ Build failed — check logs" }
  }
}

