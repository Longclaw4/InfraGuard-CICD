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

        stage('Generate Live Dashboard Data') {
            steps {
                sh '''
                DATE=$(date)

                INSTANCE_ID=$(aws ec2 describe-instances \
                  --filters "Name=tag:Name,Values=InfraGuard-Server-Jenkins" \
                  --query "Reservations[0].Instances[0].InstanceId" \
                  --output text)

                INSTANCE_STATE=$(aws ec2 describe-instances \
                  --instance-ids $INSTANCE_ID \
                  --query "Reservations[0].Instances[0].State.Name" \
                  --output text)

                PUBLIC_IP=$(aws ec2 describe-instances \
                  --instance-ids $INSTANCE_ID \
                  --query "Reservations[0].Instances[0].PublicIpAddress" \
                  --output text)

                cat > data.js <<EOF
window.pipelineStatus = "SUCCESS";
window.lastDeploy = "$DATE";
window.instanceId = "$INSTANCE_ID";
window.instanceState = "$INSTANCE_STATE";
window.publicIp = "$PUBLIC_IP";
EOF
                '''
            }
        }

        stage('Upload Dashboard') {
            steps {
                sh '''
                aws s3 cp index.html s3://$BUCKET_NAME/index.html
                aws s3 cp data.js s3://$BUCKET_NAME/data.js
                '''
            }
        }
    }
}