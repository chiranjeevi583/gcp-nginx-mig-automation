pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Set Terraform Path') {
            steps {
                script {
                    // Set up the Terraform path if needed
                }
            }
        }
        
        stage('Set Up Service Account and Auth') {
            steps {
                script {
                    // Your existing script to set up service account
                    sh 'bash setup_service_account.sh'
                }
            }
        }
        
        stage('Create Instance Template with NGINX') {
            steps {
                script {
                    // Your existing script to create instance template
                    sh 'bash create_instance_template.sh'
                }
            }
        }
        
        stage('Create Managed Instance Group') {
            steps {
                script {
                    // Your existing script to create managed instance group
                    sh 'bash create_managed_instance_group.sh'
                }
            }
        }

        // New stage to destroy existing resources before applying Terraform
        stage('Terraform Destroy') {
            steps {
                script {
                    // Destroy existing resources (MIG and instance template)
                    sh 'terraform destroy -auto-approve'
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    // Apply Terraform changes
                    sh 'terraform apply --auto-approve'
                }
            }
        }
    }
}
