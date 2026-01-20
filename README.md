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

<img width="1609" height="394" alt="image" src="https://github.com/user-attachments/assets/e5fcefa7-e7df-4f81-a59f-68b8686aba3e" />

<img width="1436" height="98" alt="image" src="https://github.com/user-attachments/assets/b4fd3517-6500-454e-8e46-a7356373d4a1" />

<img width="1015" height="367" alt="image" src="https://github.com/user-attachments/assets/a9a65fc1-d2fd-4458-895f-f5cb46291ae1" />

<img width="858" height="882" alt="image" src="https://github.com/user-attachments/assets/87fa5b9c-27d1-4c60-9b6d-16b8354f4921" />




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

<img width="779" height="730" alt="image" src="https://github.com/user-attachments/assets/a359f7b3-4fdb-4948-8d33-bee4e1bdcfdb" />

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

<img width="1543" height="279" alt="image" src="https://github.com/user-attachments/assets/474f8294-58db-47dd-82ca-eb8efa8ceb33" />

<img width="861" height="730" alt="image" src="https://github.com/user-attachments/assets/b73dd41f-6bcc-4389-9ead-d7ffde795af4" />


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

<img width="808" height="288" alt="image" src="https://github.com/user-attachments/assets/d6a1a546-9c99-4507-8aa8-33cb8b9e2e83" />

<img width="914" height="600" alt="image" src="https://github.com/user-attachments/assets/1d733781-ba8e-433d-82c1-65459612adcf" />

<img width="573" height="486" alt="image" src="https://github.com/user-attachments/assets/c6db0ae8-f705-4e03-878d-57cbd0eb86b1" />

<img width="627" height="700" alt="image" src="https://github.com/user-attachments/assets/47ff77a9-c9c1-4ffc-8c49-9b2b852e4b82" />


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
<img width="460" height="149" alt="image" src="https://github.com/user-attachments/assets/7259f71f-c2c9-4e39-bedc-3cd6f5ca75dc" />

<img width="614" height="89" alt="image" src="https://github.com/user-attachments/assets/b82baab7-9bed-4924-8afa-db24f4e342eb" />

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
