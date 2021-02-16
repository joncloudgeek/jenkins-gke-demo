pipeline {
  agent {
    kubernetes {
      // Without cloud, Jenkins will pick the first cloud in the list
      cloud "test-cluster"
      label "jenkins-agent"
      yamlFile "jenkins-build-pod.yaml"
    }
  }

  stages {
    stage("Build") {
      steps {
        dir("hello-app") {
          container("gcloud") {
            // Cheat by using Cloud Build to help us build our container
            sh "gcloud builds submit -t ${params.IMAGE_URL}:${GIT_COMMIT}"
          }
        }
      }
    }

    stage("Deploy") {
      steps {
        container("kubectl") {
          sh """cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello-app
  template:
    metadata:
      labels:
        app: hello-app
    spec:
      containers:
      - name: hello-app
        image: ${params.IMAGE_URL}:${GIT_COMMIT}
---
apiVersion: v1
kind: Service
metadata:
  name: hello-app
spec:
  selector:
    app: hello-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
"""
          sh "kubectl rollout status deployments/hello-app"
        }
      }
    }
  }
}