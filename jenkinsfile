pipeline {
    agent any
    environment {
        // 🚨--- ACTION REQUIRED: SET THIS ---🚨
        // REPLACE with your actual DockerHub username
        DOCKERHUB_USERNAME = 'ahamedshakir' // Make sure this is YOUR username

        // This is the name for your image
        IMAGE_NAME = "devops-challenge-1-flask"

        // 🚨--- ACTION REQUIRED: SET THIS ---🚨
        // This ID must match the one you create in Jenkins
        DOCKER_CREDENTIAL_ID = '8d133e65-cd62-48dd-8fbe-d9f46d25d0a0' 
    }

    stages {
        // 1. Build Stage
        stage('Build Image') {
            steps {
                echo "Building Docker image: ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_ID}"
                script {
                    // Builds the image using the Dockerfile in your folder
                    dockerImage = docker.build("${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_ID}", ".")
                }
            }
        }

        // 2. Test Stage (This is the corrected version)
        stage('Test') {
            steps {
                echo 'Running tests inside the container...'
                // This command runs 'pytest' inside the image you just built
                // If the tests fail, the pipeline will stop.
                sh "docker run --rm ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_ID} pytest"
            }
        }

        // 3. Push Stage
        stage('Push Image') {
            steps {
                echo "Pushing image to DockerHub as: ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                
                // Uses the credential ID you set in the environment section
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIAL_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    
                    // Tag the build-specific image as 'latest'
                    sh "docker tag ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_ID} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                    
                    // Log in to DockerHub
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    
                    // Push the 'latest' image
                    sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
                }
            }
        }

        // 4. Deploy Stage
        stage('Deploy Locally') {
            steps {
                echo 'Deploying container locally...'
                // Stop and remove any old container with this name
                sh "docker stop flask-app || true"
                sh "docker rm flask-app || true"

                // Run the new container
                sh "docker run -d -p 5000:5000 --name flask-app ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
            }
        }
    }
    
    // This runs at the end to clean up and log out
    post {
        always {
            echo "Logging out of DockerHub..."
            sh "docker logout"
        }
        success {
            echo "Pipeline finished successfully! 🚀"
            echo "Access your running app at http://localhost:5000"
        }
        failure {
            echo "Pipeline failed. 😢"
        }
    }
}