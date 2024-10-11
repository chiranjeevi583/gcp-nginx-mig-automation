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

        stage('Destroy Existing Instance Template') {
            steps {
                script {
                    // Only run if ACTION is 'apply'
                    if (params.ACTION == 'apply') {
                        def destroyResult = sh(script: "terraform destroy -auto-approve -target=google_compute_instance_template.nginx_template", returnStatus: true)
                        if (destroyResult != 0) {
                            error("Failed to destroy existing instance template.")
                        }
                    }
                }
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    def result = sh(script: "terraform ${params.ACTION} --auto-approve", returnStatus: true)
                    if (result != 0) {
                        error("Terraform action failed with status: ${result}")
                    }
                }
            }
        }
    }
}
