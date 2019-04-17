pipeline {
    agent any

    tools {
    maven 'apache-maven-3.5.4'
    }
       
    triggers {
        githubPush()
        pollSCM('')
    }
     
    stages {
        stage('Continuous Integration') {
            steps {                 
                sh '''
                   mvn clean package
                   '''
             }
            app = docker.build("weather-app")
            app.inside { sh 'echo "Tests passed"'
            }
            docker.withRegistry('http://202.77.40.221:12015', 'nexus-credentials') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest")
            }
        }
        stage('Continuous Delivery') {
            steps {
                    sh '''   
                        echo "deploy to K8S "
                    '''
            }
        }
    }
}
