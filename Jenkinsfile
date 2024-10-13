pipeline {
    agent any

    environment {
        SVC_ACCOUNT_KEY = credentials('NGINX-MIG-AUTH') 
    }

    stages {
        stage('Set Terraform path') {
            steps {
                script {
                    def tfHome = tool name: 'Terraform'
                    env.PATH = "${tfHome}:${env.PATH}"
                }
                sh 'pwd'
                sh "echo ${SVC_ACCOUNT_KEY} | base64 -d > ./terraform.json"
                sh 'terraform --version'               
            }
        }

        stage('Set up Service Account and Auth') {
            steps {
                sh 'bash setup_service_account.sh'
            }
        }

        stage('Create Instance Template with NGINX') {
            steps {
                sh 'bash create_instance_template.sh'
            }
        }

        stage('Create Managed Instance Group') {
            steps {
                sh 'bash create_managed_instance_group.sh'
            }
        }
        
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform plan') {
		 steps {
		
		 sh 'terraform plan'
        	}
    	}

        stage('Terraform Action') {
            steps {
                sh "terraform ${params.ACTION} --auto-approve"
            }
        }
    }

    // Post actions to handle success/failure
    post {
        success {
            echo 'Terraform action completed successfully.'
        }
        failure {
            echo 'There was an error during the Terraform action.'
        }
        always {
            // Cleanup actions or notifications can be added here
            sh 'rm -f ./terraform.json' // Clean up the service account key
        }
    }
}
