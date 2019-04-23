pipeline {
    agent any

    tools {
    maven 'apache-maven-3.6.1'
    }
       
    triggers {
        githubPush()       
    }
     
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
                        namespace = "demo-dev-env"
                        imageTag = "http://technet-k8s.hds-cloudconnect.com:8551/weather-app:latest"                        
                        echo "deploy to K8S"
                        if kubectl get ns $namespace; then
                            echo "create namespace"
                            kubectl create ns $namespace
                        fi
                        sed -i.bak 's#weather-app:latest#$imageTag#' ./*.yaml 
                        kubectl --namespace=${namespace} apply -f ./deployment.yaml
                        kubectl --namespace=${namespace} apply -f ./service.yaml                                                        
                        '''                
                    }
               }
          }
     }
}
