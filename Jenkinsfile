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
                   mvn clean deploy
                   '''
             }             
        }
        stage('Continuous Delivery') {
            steps {
                    sh '''   
                        echo "docker login to mycluster.icp"
                        echo "remove existing docker image in ICP"
                        echo "docker push"
                        echo "kubectl login"                       
                        #!/bin/bash
                        echo "checking if wlp-daytrader-jenkins already exists"
                        echo "Create application"
                        echo "Create service"
                        echo "finished"
                    '''
            }
        }
    }
}
