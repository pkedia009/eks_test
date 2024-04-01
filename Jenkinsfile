pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID="533267099239"
        AWS_DEFAULT_REGION="us-east-1"
        // Define the path to your Dockerfile
        DOCKERFILE_PATH = '/var/lib/jenkins/workspace/eks'
        IMAGE_REPO_NAME="test_eks"
        IMAGE_TAG="v1"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/pkedia009/eks_test.git']]])     
            }
        }
        
        stage('Logging into AWS ECR') {
            steps {
                script {
                     // Get the AWS credentials from Jenkins credentials
                    // Get the AWS credentials from Jenkins credentials
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_cred']]) {
                // Use the AWS CLI to retrieve an authentication token to use for Docker login
                def ecrLoginCmd = "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${REPOSITORY_URI}"
                sh ecrLoginCmd
                    }
                }
            }
        }

        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        
        stage('Pushing to ECR') {
            steps {
                script {
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}"
                    sh "docker push ${REPOSITORY_URI}:${IMAGE_TAG}"
                }
            }
        }
        
        stage('Helm Deploy') {
            steps {
                script {
                    // Deploy using Helm
                    sh "helm upgrade first --install mychart --namespace helm-deployment --set image.tag=${IMAGE_TAG}"
                }
            }
        }
    }
}
