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
        }
        stage('Continuous Delivery') {
            steps {
                    sh '''   
                        echo "remove existing docker image "
                        if docker inspect --type=image dhvines/weather-app:1.0-SNAPSHOT; then
                            echo "image already exists, delete first"
                            docker rmi dhvines/weather-app:1.0-SNAPSHOT
                        fi   
                        docker build -t dhvines/weather-app:1.0-SNAPSHOT .
                        docker run -p 8090:8080 dhvines/weather-app:1.0-SNAPSHOT
                    '''
            }
        }
    }
}
