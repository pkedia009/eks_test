pipeline {
    agent any
    triggers {
        pollSCM "* * * * *"
    }
    environment {
        registry = "533267099239.dkr.ecr.us-east-1.amazonaws.com/test_eks"
    }
    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/pkedia009/eks_test.git']]])     
            }
        }
        stage ('Build') {
            steps {
                echo '=== Building Application ==='
                sh 'mvn clean install'           
            }
        }
        stage('Building Docker image') {
            when {
                branch 'master'
            }
            steps {
                echo '=== Building Docker Image ==='
                script {
                    dockerImage = docker.build registry 
                    dockerImage.tag("$BUILD_NUMBER")
                    app = docker.build("ibuchh/petclinic-spinnaker-jenkins")
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
                    
                    docker.withRegistry(ecrRegistryUrl, ecrCredentials) {
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ecrRegistryUrl"
                        app.push("$BUILD_NUMBER")
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
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
