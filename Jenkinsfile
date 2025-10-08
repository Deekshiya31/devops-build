pipeline {
  agent any

  environment {
    DOCKER_USER = "deekshiya31"
    DOCKERHUB_CREDENTIALS_ID = "dockerhub-creds"
    DEV_REPO = "${DOCKER_USER}/dev"
    PROD_REPO = "${DOCKER_USER}/prod"
    
    // !!! IMPORTANT: PASTE THE CURRENT PUBLIC IP OF YOUR DEVOPS EC2 HERE !!!
    DEVOPS_IP = "3.110.143.246" 
    DEVOPS_SSH_CREDS = "devops-ssh-key" 
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        echo "Source code checked out successfully."
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DEV_REPO:latest .'
      }
    }

    stage('Push & Deploy Dev') {
      when { branch 'dev' }
      steps {
        script {
          // 1. PUSH TO DOCKERHUB DEV REPO
          echo "1. Pushing to DockerHub DEV repo..."
          withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DBUSER', passwordVariable: 'DBPASS')]) {
            sh '''
              echo "$DBPASS" | docker login -u "$DBUSER" --password-stdin
              docker push $DEV_REPO:latest
              docker logout
            '''
          }
          
          // 2. DEPLOY DEV IMAGE VIA SSH
          echo "2. Deploying DEV image to DevOps EC2 at $DEVOPS_IP..."
          sshagent(credentials: ["${DEVOPS_SSH_CREDS}"]) { 
            // Executes the deploy.sh script (which pulls $DEV_REPO:latest)
            sh "ssh -o StrictHostKeyChecking=no ec2-user@$DEVOPS_IP '~/deploy.sh'"
          }
        }
      }
    }

    stage('Push & Deploy Prod') {
      when { branch 'main' } 
      steps {
        script {
          // 1. TAG FOR PROD
          echo "1. Tagging DEV image for PROD repo..."
          sh 'docker tag $DEV_REPO:latest $PROD_REPO:latest'
          
          // 2. PUSH TO DOCKERHUB PROD REPO
          echo "2. Pushing to DockerHub PROD private repo..."
          withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS_ID}", usernameVariable: 'DBUSER', passwordVariable: 'DBPASS')]) {
            sh '''
              echo "$DBPASS" | docker login -u "$DBUSER" --password-stdin
              docker push $PROD_REPO:latest
              docker logout
            '''
          }
          
          // 3. DEPLOY PROD IMAGE VIA SSH
          echo "3. Deploying PROD image to DevOps EC2 at $DEVOPS_IP..."
          sshagent(credentials: ["${DEVOPS_SSH_CREDS}"]) { 
            // IMPORTANT: If you created deploy_prod.sh, use that here!
            sh "ssh -o StrictHostKeyChecking=no ec2-user@$DEVOPS_IP '~/deploy_prod.sh'" 
          }
        }
      }
    }
  }

  post {
    success { echo "✅ Pipeline completed successfully!" }
    failure { echo "❌ Pipeline failed — check build logs for errors." }
  }
}
