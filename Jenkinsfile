pipeline {
    agent any
    triggers {
        pollSCM "* * * * *"
    }
    environment {
        registry = "account_id.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo"
        ecrRegistryUrl = 'https://account_id.dkr.ecr.us-east-1.amazonaws.com'
        ecrCredentials = 'ECR_Credentials'
    }
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], userRemoteConfigs: [[url: 'https://github.com/pkedia009/eks_test.git']]])
            }
        }
        stage('Build') {
            steps {
                echo '=== Building  and testing Application ==='
                
            }
        }
        stage('Building Docker Image') {
            when {
                branch 'develop'
            }
            steps {
                echo '=== Building Docker Image ==='
                script {
                    dockerImage = docker.build registry
                    dockerImage.tag("$BUILD_NUMBER")
                    dockerImage.push()
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

                    docker.withRegistry(ecrRegistryUrl, ecrCredentials) {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecrRegistryUrl"
                        app = docker.image(registry)
                        app.push("$BUILD_NUMBER")
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
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
