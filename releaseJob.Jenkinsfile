pipeline {
    agent any
    
    parameters {
        string(name: 'FROM_BUILD', defaultValue: 'PROD', description: 'Build Source')
    }

    stages {
        stage('DEPLOY') {
            steps {
                echo "Deploy from source ${params.FROM_BUILD}"
            }
        }
    }
}
