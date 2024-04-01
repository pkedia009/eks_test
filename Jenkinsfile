pipeline {
    agent any
   
    environment {
        registry = "533267099239.dkr.ecr.us-east-1.amazonaws.com/eks_test"
        // Define the path to your Dockerfile
        DOCKERFILE_PATH = '/var/lib/jenkins/workspace/eks'
        // Define the AWS ECR repository URL
        AWS_ECR_REPO_URL = 'your-aws-ecr-repo-url'
    }
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/pkedia009/eks_test.git']]])     
            }
        }
      
        stage('Building Docker image') {
           
            steps {
                echo '=== Building Docker Image ==='
                script {
                      // Build the Docker image using the specified Dockerfile path
                    dockerImage = docker.build("-f ${DOCKERFILE_PATH} .")
                    // Tag the Docker image with the build number
                    dockerImage.tag("${BUILD_NUMBER}")
                }
            }
        }
        stage('Pushing to ECR') {
            when {
                branch 'master'
            }
            steps {
                echo '=== Pushing Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true).trim()
                    SHORT_COMMIT = GIT_COMMIT_HASH.take(7)
                    
                    docker.withRegistry("${AWS_ECR_REPO_URL}", ecrCredentials) {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecrRegistryUrl"
                         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'your-aws-credentials-id']]) {
                        // Push the Docker image to AWS ECR
                   'ecr:us-east-1') 
                            dockerImage.push("${BUILD_NUMBER}")
                        
                    
                }
            }
        }
        stage ('Helm Deploy') {
            steps {
                script {
                    sh "helm upgrade first --install mychart --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
                }
            }
        }
    }
}
