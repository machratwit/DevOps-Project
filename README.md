# DevOps Project: End-to-End CI/CD with Terraform, Docker, AWS, and GitHub Actions

**Overview**

This project demonstrates a complete, production-style DevOps workflow using Infrastructure as Code, containerization, and CI/CD automation. The system provisions AWS infrastructure with Terraform, builds and scans a Dockerized Node.js application, pushes images to Amazon ECR, and deploys the application to an EC2 instance automatically using GitHub Actions.

The focus of this project is end-to-end ownership: infrastructure, security, pipelines, deployment, and runtime.

## Infrastructure as Code with Terraform

Terraform is used to provision and manage all AWS infrastructure.

**Key Infrastructure Features**

- Remote Terraform state stored in S3 with encryption enabled

- AWS provider locked to a specific version

 - Amazon ECR repository for Docker images

- EC2 security group allowing HTTP (3000) and SSH (22)

- IAM role and instance profile allowing EC2 to access ECR

- EC2 instance bootstrapped automatically using a user data script

**Terraform Backend**

Terraform state is stored remotely to enable safe, repeatable deployments:

- S3 bucket backend

- Encrypted state

- Consistent state key per environment



## EC2 Bootstrapping with User Data

The EC2 instance is fully configured at launch using a Bash user data script.

**What the Script Does**

- Updates system packages

- Installs Docker from the official Docker repository

- Enables and starts the Docker service

- Adds the default user to the Docker group

- Installs AWS CLI v2 if not already present

- Prepares a directory for application deployment

This ensures the instance is deployment-ready without manual SSH configuration.


## Application Layer

The application is a simple Node.js Express service designed to demonstrate deployment and health checking.

**Application Endpoints**

- / returns JSON with environment info

- /health returns a simple OK response

The app listens on port 3000, which aligns with the EC2 security group and Docker port mapping.


## Containerization with Docker

The application is packaged into a Docker image using a custom Dockerfile.

**Benefits demonstrated:**

- Environment consistency

- Easy deployment and rollback

- Compatibility with CI/CD pipelines

The Docker image is tagged and pushed to Amazon ECR during the pipeline run.


## CI/CD Pipeline with GitHub Actions

The CI/CD pipeline is defined in `.github/workflows/cicd.yml` and can be manually triggered.

**Pipeline Highlights**

- Uses OIDC-based authentication to assume an AWS IAM role securely

- Installs dependencies and runs tests

- Builds and tags Docker images

- Scans images using Trivy for vulnerabilities

- Pushes images to Amazon ECR

- Reads EC2 public IP directly from Terraform state

- Deploys to EC2 over SSH and runs the container

This pipeline eliminates hardcoded credentials and manual deployment steps.


## Deployment Process

1. Pipeline is triggered manually or via push

2. Docker image is built and scanned

3. Image is pushed to Amazon ECR

4. Terraform state is read to retrieve EC2 IP

5. Pipeline SSHs into EC2

6. EC2 pulls the latest image from ECR

7. Existing container is replaced

8. New container starts on port 3000

## Verification

Once deployed, the application can be verified by accessing:
```
http://<EC2_PUBLIC_IP>:3000/
http://<EC2_PUBLIC_IP>:3000/health
```

## Security Considerations

- No long-lived AWS credentials in GitHub

- OIDC-based role assumption

- Least-privilege IAM roles

- Encrypted Terraform state

- Image vulnerability scanning before deployment
  

## What This Project Demonstrates

- Infrastructure as Code with Terraform

- Remote state management and safe deployments

- Secure AWS authentication using GitHub OIDC

- Docker image lifecycle management

- Automated vulnerability scanning

- CI/CD pipeline design

- Automated EC2 provisioning and bootstrapping

- Zero-touch application deployment
