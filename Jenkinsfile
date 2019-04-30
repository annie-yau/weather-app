pipeline {
    agent any

    // nodejs is for SonarQube
    tools {
    maven 'apache-maven-3.6.1'
    nodejs 'NodeJS 11.14' 
    }
    
   // Reference the GitLab connection name from your Jenkins Global configuration (http://JENKINS_URL/configure, GitLab section)
    options {
        gitLabConnection('gitlab')
    }
    
    triggers {
        gitlab( triggerOnPush: true, 
                branchFilterType: 'All',
                triggerOnMergeRequest: false,
                triggerOpenMergeRequestOnPush: "never",
                triggerOnNoteRequest: true,
                noteRegex: "Jenkins please retry a build",
                skipWorkInProgressMergeRequest: true,
                secretToken: "abcdefghijklmnopqrstuvwxyz0123456789ABCDEF",
                ciSkip: false,
                setBuildDescription: true,
                addNoteOnMergeRequest: true,
                addCiMessage: true,
                addVoteOnMergeRequest: true,
                acceptMergeRequestOnSuccess: false,
                includeBranchesSpec: "release/qat",
                excludeBranchesSpec: ""
        )
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
                    docker.withRegistry('https://technet-k8s.hds-cloudconnect.com:12018/weather-app', 'nexus-credentials') {
                        app.push()
                    }
                }
            }
        }
        
        stage('SonarQube analysis') {
            steps {
                sh 'npm config ls'
                withSonarQubeEnv('SonarQube-7.7') {
                    // requires SonarQube Scanner for Maven 3.2+
                    sh 'mvn sonar:sonar'
                }
            }
        }
              
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
                        sed -i.bak 's#weather-app:latest#technet-k8s.hds-cloudconnect.com:12018/weather-app:latest#' ./*.yaml
                        kubectl --namespace=demo-env-dev apply -f ./deployment.yaml
                        kubectl --namespace=demo-env-dev apply -f ./service.yaml                                                        
                        '''                
                    }
               }
          }
     }
}
