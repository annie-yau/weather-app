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
        
        stage('Continuous Delivery') {
            steps {
                    withKubeConfig([credentialsId: 'k8suser', serverUrl: 'https://api.k8s.technet-k8s.hds-cloudconnect.com']) {                    
                    sh '''   
                        echo "deploy to K8S"
                        kubectl create ns demo-dev-env                    
                        sed -i.bak 's#weather-app:latest#http://technet-k8s.hds-cloudconnect.com:8551/weather-app:latest#' ./*.yaml 
                        kubectl --namespace=demo-dev-env apply -f ./deployment.yaml
                        kubectl --namespace=demo-dev-env apply -f ./service.yaml                                                        
                        '''                
                    }
               }
          }
     }
}
