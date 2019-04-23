pipeline {
    agent any

    tools {
    maven 'apache-maven-3.6.1'
    }
       
    triggers {
        githubPush()
        pollSCM('')
    }
     
    stages {  
        /*
        stage('Continuous Integration') {
            steps {                 
                sh '''
                   mvn clean package
                   '''
                script {
                    app = docker.build("weather-app:${env.BUILD_NUMBER}")
                    app.inside { sh 'echo "Tests passed"'
                    }
                    docker.withRegistry('http://202.77.40.221:8551/repository/mike-docker-hosted/', 'nexus-credentials') {
                        app.push()
                    }
                }
            }
        }
        */
        stage('Continuous Delivery') {
            steps {
                    withKubeConfig([credentialsId: 'k8suser', serverUrl: 'https://202.77.40.221']) {
                    sh '''   
                        namespace = "demo-dev-env"
                        imageTag = "weather-app:latest"                        
                        echo "deploy to K8S"
                            kubectl get ns $namespace || kubectl create ns $namespace
                            sed -i.bak 's#weather-app:latest#$imageTag#' ./*.yaml 
                            kubectl --namespace=${namespace} apply -f ./deployment.yaml
                            kubectl --namespace=${namespace} apply -f ./service.yaml                                                        
                        '''
                    }
               }
          }
     }
}
