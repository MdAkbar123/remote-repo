# Node.js CI/CD Pipeline on AWS with Terraform, Ansible & GitHub Actions

## 🎯 Objective

Automate the infrastructure provisioning, configuration, and deployment of a Node.js application using:

- **Terraform**: Provision AWS EC2 instances.
- **Ansible**: Configure servers and deploy the application.
- **GitHub Actions**: Implement CI/CD triggered on every push to the main branch.

### Goal

Ensure that after each push to the `main` branch, the code is automatically deployed to the EC2 instance via the pipeline.

---

## 🧱 Core Components

| Layer              | Tool            | Purpose                                     |
|--------------------|-----------------|---------------------------------------------|
| **Infrastructure** | Terraform       | Create AWS EC2 instances and security groups |
| **Config Management** | Ansible       | Install Node.js, clone the repository, and start the app |
| **CI/CD**          | GitHub Actions  | Automate build and deployment on each push  |
| **Runtime**        | Node.js         | Run the Express application on port 80      |
| **Cloud Provider** | AWS             | Provide production-grade hosting            |

---

## 🧭 Architecture Overview

1. Developer pushes code → GitHub Repository.
2. GitHub Actions Workflow is triggered:
    - **Terraform**: Provisions EC2 instances.
    - **Ansible**: Configures the server and deploys the application.
    - **SSH**: Connects to EC2 to start the application.

---

## 🪜 Implementation Phases

### Phase 1: Terraform Setup

- Use `main.tf`, `variables.tf`, and `outputs.tf` to:
  - Create EC2 instances.
  - Define security groups.
  - Generate key pairs.

### Phase 2: Ansible Setup

- Write playbooks to:
  - Install Node.js.
  - Clone the GitHub repository.
  - Launch the Express server.

### Phase 3: GitHub Actions Workflow

- Create `.github/workflows/deploy.yml` to automate:
  - Building and testing the application.
  - Connecting to the EC2 instance via SSH.
  - Deploying the application.

### Phase 4: GitHub Secrets

- Securely store sensitive credentials:
  - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
  - `EC2_SSH_KEY`
  - `EC2_HOST`

### Phase 5: (Optional) Terraform + Ansible Integration

- Use Terraform to dynamically generate Ansible inventory files.
- Enable zero-touch deployment by chaining Terraform and Ansible.

---

## ✅ Deliverable

A fully automated pipeline that accomplishes the following:

- **Push** → **Build** → **Provision** → **Configure** → **Deploy** → **Live Application**

The Node.js application will be accessible at:

```
http://<EC2_PUBLIC_IP>/
```