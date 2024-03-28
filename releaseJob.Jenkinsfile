pipeline {
    agent any
    
    environment {
        registryCredential = 'ecr:us-east-1:aws_cred'
        appRegistry = "533267099239.dkr.ecr.us-east-1.amazonaws.com/test_eks" 
        myprojectRegistry = "https://533267099239.dkr.ecr.us-east-1.amazonaws.com/"
    }
    
    parameters {
        string(name: 'FROM_BUILD', defaultValue: 'PROD', description: 'Build Source')
    }

    stages {
        stage('DEPLOY') {
            steps {
                echo "Deploy from source ${params.FROM_BUILD}"
            }
        }
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], userRemoteConfigs: [[url: 'https://github.com/pkedia009/eks_test.git']]])
            }
        }
        
        stage('Build') {
            steps {
                echo '=== Building and testing Application ==='
                // Add your build steps here
            }
        }
        
        stage('Building Docker Image') {
            steps {
                echo '=== Building Docker Image ==='
                script {
                    dockerImage = docker.build("${appRegistry}:${BUILD_NUMBER}", "/var/lib/jenkins/workspace/eks")
                }
            }
        }
        
        stage('Pushing to ECR') {
            steps {
                echo '=== Pushing Docker Image to ECR ==='
                script {
                    GIT_COMMIT_HASH = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true).trim()
                    SHORT_COMMIT = GIT_COMMIT_HASH.take(7)
                    docker.withRegistry(myprojectRegistry, registryCredential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
