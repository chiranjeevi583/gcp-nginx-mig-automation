pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select the Terraform action to perform')
    }

    environment {
        SVC_ACCOUNT_KEY = credentials('TERRAFORM-AUTHE') 
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
        
        // Optional Debug Stage
        stage('Debug') {
            steps {
                sh 'echo "Service Account Key exists: ${SVC_ACCOUNT_KEY != null}"'
                sh 'cat ./terraform.json' // Caution: Avoid exposing sensitive information!
            }
        }
    }
}
