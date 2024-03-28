pipeline {
    agent any
    triggers {
        pollSCM "* * * * *"
    }
    environment {
        registryCredential = 'ecr:us-east-1:aws creds'
        appRegistry = "533267099239.dkr.ecr.us-east-1.amazonaws.com/eks_test" 
        myprojectRegistry = "https:533267099239.dkr.ecr.us-east-1.amazonaws.com/"
    }
    stages {
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
            when {
                branch 'develop'
            }
            steps {
                echo '=== Building Docker Image ==='
                script {
                    dockerImage = docker.build("${appRegistry}:${BUILD_NUMBER}", "./Docker-files/app/multistage/")
                }
            }
        }
        stage('Pushing to ECR') {
            when {
                branch 'master'
            }
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
        stage('Helm Deploy') {
            steps {
                script {
                    sh "helm upgrade first --install mychart --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
                }
            }
        }
    }
}
