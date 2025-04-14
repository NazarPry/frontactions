pipeline {
    agent { label 'front' }  

    environment {
        DOCKER_IMAGE = "edeko/inter_frontend" 
        
    }
    
    stages {
        stage('Lint and Test') {
            steps {
                script {
                    sh 'docker build --target lint-test -t temp-lint-test . && docker rmi temp-lint-test'  
                }
            }
        }

        stage('Build and Push Docker Image') {
            when {
                branch 'main'  
            }
            steps {
                script {
                    def version = sh(script: "node -p \"require('./package.json').version\"", returnStdout: true).trim()
                    
                    
                        sh """
                            docker build -t ${DOCKER_IMAGE}:${version} .
                            docker push ${DOCKER_IMAGE}:${version}   
                            
                        """ 
                    
                }
            }
        }



    }

    post {
                
        always {
            cleanWs()   
        }
    }
}