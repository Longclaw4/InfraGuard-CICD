pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        BUCKET_NAME = 'infraguard-vaibhav-1551-demo'
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Upload Dashboard') {
            steps {
                sh 'aws s3 cp index.html s3://$BUCKET_NAME/index.html'
            }
        }
    }
}