Cloud Native Resource Monitoring Python App on Kubernetes
What You’ll Learn 🤯
Create a monitoring application in Python using Flask and psutil.
Run a Python app locally.
Learn Docker: containerize a Python application, create Dockerfiles, build images, and run containers.
Push Docker images to AWS ECR using boto3.
Learn Kubernetes: Create an EKS cluster, node groups, and deploy applications using Python.
Step-by-step demonstration with a YouTube video tutorial.
Prerequisites
Before starting, ensure you have the following:

An AWS Account with CLI configured for programmatic access.
Python 3, Docker, and kubectl installed.
A code editor (e.g., VS Code).
Project Breakdown
Part 1: Deploy the Flask Application Locally
Clone the Repository

bash
Copy
Edit
git clone <repository_url>
cd <project_directory>
Install Dependencies Install the required libraries:

bash
Copy
Edit
pip3 install -r requirements.txt
Run the Application Start the Flask server:

bash
Copy
Edit
python3 app.py
Open your browser and navigate to: http://localhost:5000.

Part 2: Dockerize the Flask Application
Create a Dockerfile Add the following Dockerfile to the project root:

dockerfile
Copy
Edit
FROM python:3.9-slim-buster
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY . .
ENV FLASK_RUN_HOST=0.0.0.0
EXPOSE 5000
CMD ["flask", "run"]
Build the Docker Image

bash
Copy
Edit
docker build -t <image_name> .
Run the Docker Container

bash
Copy
Edit
docker run -p 5000:5000 <image_name>
Access the app at http://localhost:5000.

Part 3: Push Docker Image to AWS ECR
Create an ECR Repository Use the following Python script to create a repository:

python
Copy
Edit
import boto3

ecr_client = boto3.client('ecr')
response = ecr_client.create_repository(repositoryName='my-ecr-repo')
print(response['repository']['repositoryUri'])
Push the Docker Image to ECR Replace <ecr_repo_uri> with the URI from the script and run:

bash
Copy
Edit
docker tag <image_name> <ecr_repo_uri>:latest
docker push <ecr_repo_uri>:latest
Part 4: Deploy the App on Kubernetes (EKS)
Set Up EKS Cluster

Create an EKS cluster and a node group (refer to AWS documentation for setup).
Create Deployment and Service Use the following Python script (eks.py):

python
Copy
Edit
from kubernetes import client, config

config.load_kube_config()
api_client = client.ApiClient()

deployment = client.V1Deployment(
    metadata=client.V1ObjectMeta(name="my-flask-app"),
    spec=client.V1DeploymentSpec(
        replicas=1,
        selector=client.V1LabelSelector(match_labels={"app": "my-flask-app"}),
        template=client.V1PodTemplateSpec(
            metadata=client.V1ObjectMeta(labels={"app": "my-flask-app"}),
            spec=client.V1PodSpec(
                containers=[
                    client.V1Container(
                        name="my-flask-container",
                        image="<ecr_repo_uri>:latest",
                        ports=[client.V1ContainerPort(container_port=5000)]
                    )
                ]
            )
        )
    )
)

service = client.V1Service(
    metadata=client.V1ObjectMeta(name="my-flask-service"),
    spec=client.V1ServiceSpec(
        selector={"app": "my-flask-app"},
        ports=[client.V1ServicePort(port=5000)]
    )
)

client.AppsV1Api(api_client).create_namespaced_deployment(namespace="default", body=deployment)
client.CoreV1Api(api_client).create_namespaced_service(namespace="default", body=service)
Update <ecr_repo_uri> with your ECR image URI.

Verify Deployment Run the following commands:

bash
Copy
Edit
kubectl get deployment -n default
kubectl get service -n default
kubectl get pods -n default
Access the App Forward the service port:

bash
Copy
Edit
kubectl port-forward service/my-flask-service 5000:5000
Open http://localhost:5000.

