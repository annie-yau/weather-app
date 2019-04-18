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
        app-name = weather-app
        nexus-docker-registry = "http://202.77.40.221:12015/docker-private"
        stage('Continuous Integration') {
            steps {                 
                sh '''
                   mvn clean package
                   '''
                script {
                    def dockerHome = tool 'myDocker'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                    app = docker.build($app-name)
                    app.inside { sh 'echo "Tests passed"'
                    }
                    docker.withRegistry($nexus-docker-registry, $nexus-credentials) {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Continuous Delivery') {
            steps {
                    withKubeConfig([credentialsId: 'k8suser', serverUrl: 'https://202.77.40.221']) {
                    sh '''   
                        namespace = "demo-dev-env"
                        imageTag = "$nexus-docker-registry/$app-name:${env.BUILD_NUMBER}"
                        echo "deploy to K8S"
                            kubectl get ns $namespace || kubectl create ns $namespace
                            sed -i.bak 's#$nexus-docker-registry/$app-name:#$imageTag#' ./*.yaml 
                            kubectl --namespace=${namespace} apply -f ./deployment.yaml
                            kubectl --namespace=${namespace} apply -f ./service.yaml                                                        
                        '''
                    }
                }
            }
        }
    }
}
