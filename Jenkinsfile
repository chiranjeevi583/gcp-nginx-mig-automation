pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select the Terraform action to perform')
    }

    environment {
        SVC_ACCOUNT_KEY = credentials('NGINX-MIG-AUTH') 
    }

    stages {
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

        stage('Terraform Action') {
            steps {
                script {
                    sh "terraform ${params.ACTION} --auto-approve"
                }
            }
        }
    }
}
