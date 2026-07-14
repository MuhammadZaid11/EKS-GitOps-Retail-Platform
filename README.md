# EKS GitOps Retail Platform

A production-style deployment of a multi-tier microservices retail application on **Amazon EKS (Auto Mode)**, provisioned with **Terraform** and deployed using **GitOps principles with ArgoCD** and **GitHub Actions**.

> Built as a hands-on learning project to understand how real DevOps teams take infrastructure and applications from code to production. Based on the [retail-store-sample-app](https://github.com/LondheShubham153/retail-store-sample-app) reference architecture, adapted and documented by Muhammad Zaid.

---

## Architecture

```
Developer pushes code
        │
        ▼
GitHub Actions (CI) ── builds Docker image ── pushes to Amazon ECR
        │
        ▼
ArgoCD (CD) ── watches Git repo for manifest/Helm changes ── syncs desired state
        │
        ▼
Amazon EKS (Auto Mode) ── runs the workloads
        │
        ▼
NGINX Ingress Controller ── routes external traffic ── Load Balancer URL
        │
        ▼
Cert Manager ── issues/renews TLS certificates automatically
```

*(Add your own architecture diagram screenshot here once your cluster is live — e.g. from draw.io or excalidraw.com)*

---

## Tech Stack

| Category | Tools |
|---|---|
| Cloud Provider | AWS (EKS, VPC, IAM, ECR, ELB) |
| Infrastructure as Code | Terraform |
| Container Orchestration | Kubernetes (EKS Auto Mode) |
| GitOps / CD | ArgoCD |
| CI | GitHub Actions |
| Networking | NGINX Ingress Controller |
| TLS | Cert Manager (Let's Encrypt) |
| Package Management | Helm |

---

## What This Project Demonstrates

- **Infrastructure as Code**: Entire AWS infrastructure (VPC, subnets, EKS cluster, IAM roles, security groups) defined declaratively in Terraform — no manual console clicking.
- **GitOps workflow**: Git is the single source of truth. Any change to application manifests is automatically detected and synced to the cluster by ArgoCD — no manual `kubectl apply`.
- **CI/CD separation of concerns**: GitHub Actions handles build (CI), ArgoCD handles deploy (CD) — cluster credentials never live inside the CI pipeline.
- **Managed Kubernetes at scale**: EKS Auto Mode removes manual node group management, letting AWS handle compute provisioning, scaling, and patching.
- **Secure ingress**: All traffic routed through NGINX Ingress with automated TLS certificate issuance via Cert Manager.

---

## Getting Started

### Prerequisites

- AWS CLI v2, configured with an IAM user (not root)
- Terraform >= 1.5
- kubectl
- Helm
- Docker

### 1. Provision infrastructure

```bash
cd terraform/
terraform init
terraform apply --auto-approve
```

This creates the VPC, EKS cluster (Auto Mode), IAM roles/security groups, and installs ArgoCD, NGINX Ingress, and Cert Manager.

### 2. Connect to the cluster

```bash
aws eks update-kubeconfig --name retail-store --region <your-region>
kubectl get nodes
```

### 3. Access the application

```bash
kubectl get svc -n ingress-nginx
```

Copy the `EXTERNAL-IP` of the ingress-nginx-controller service and open it in your browser.

### 4. Access ArgoCD UI

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Use this password with username `admin` to log into the ArgoCD dashboard and watch live sync status.

### 5. Tear down (important — avoid unwanted AWS charges)

```bash
terraform destroy --auto-approve
```

---

## Lessons Learned

*(Fill this in as you go — this section is what makes your README stand out to recruiters. Document real issues you hit and how you solved them.)*

- 
- 
- 

---

## Author

**Muhammad Zaid** — Transitioning from Mechanical Engineering into DevOps & Cloud Engineering.
[LinkedIn](#) · [GitHub](#)