pipeline {
    agent any

    tools {
    maven 'apache-maven-3.6.1'
    }
    
    /*
    triggers {
        githubPush()       
    }
    */
     
    stages {  
        /*
        stage('Continuous Integration') {
            steps {                 
                sh '''
                   mvn clean package
                   '''
                script {
                    //app = docker.build("weather-app:${env.BUILD_NUMBER}")
                    app = docker.build("weather-app:latest")
                    app.inside { sh 'echo "Tests passed"'
                    }
                    docker.withRegistry('http://technet-k8s.hds-cloudconnect.com:8551/weather-app', 'nexus-credentials') {
                        app.push()
                    }
                }
            }
        }
        */
        stage('Continuous Delivery') {
            steps {
                    withKubeConfig([credentialsId: 'k8suser', serverUrl: 'https://10.4.1.50:6443']) {                    
                    sh '''  
                        if kubectl describe service weather-app-service -n demo-env-dev; then
                            echo "Service already exists, delete first"
                            kubectl delete service weather-app-service -n demo-env-dev
                        fi
                        if kubectl describe deployment weather-app-deployment -n demo-env-dev; then
                            echo "Application already exists, delete first"
                            kubectl delete deployment weather-app-deployment -n demo-env-dev
                        fi                        
                        echo "deploy to K8S"                                  
                        sed -i.bak 's#weather-app:latest#http://technet-k8s.hds-cloudconnect.com:8551/weather-app:latest#' ./*.yaml
                        kubectl --namespace=demo-env-dev apply -f ./deployment.yaml
                        kubectl --namespace=demo-env-dev apply -f ./service.yaml                                                        
                        '''                
                    }
               }
          }
     }
}
