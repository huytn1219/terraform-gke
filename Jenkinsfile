pipeline {

    options {
        buildDiscarder(logRotator(numToKeepStr:'50'))
        ansiColor('xterm')
    }    

    // Utilize Kubernetes as an agent to build this job 
    agent {
        kubernetes {
            label "terraform-${env.APP_NAME}"
            defaultContainer 'jnlp'
            yaml """
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        components: c1
    spec:
    # Use a service account that can deploy to all namespaces
      serviceAccountName: cd-jenkins
      slaveConnectionTimeout: 500
      containers:
      - name: terraform
        image: gcr.io/shipwire-eng-core-dev/sw-terraform
        command:
        - cat
        tty: true
    """
        }
    }

    stages {
        stage('Terraform Init') {
            steps {
                container('terraform') {
                    sh """
                    cd gke-cluster
                    terraform init
                    """
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                container('terraform') {
                    sh """
                    cd gke-cluster
                    terraform plan
                    """
                }
            }
        }
        stage('Approve') {
            steps {
                script {
                    deployToAlpha = input(
                            id: 'Proceed', message: 'Deploy to Alpha?', parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Proceed with deployment?']
                    ])
                }
            }   
        }
        stage('Deploy To Alpha') {
            when {
                expression { deployToAlpha == true }
            }
            steps {
                container('terraform') {
                    sh """
                    cd gke-cluster
                    echo 'yes' | terraform apply
                    """
                }
            }
        }
    }
}
