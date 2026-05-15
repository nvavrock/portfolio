# DevOps Project Sketch: The "Always-On" Weather Dashboard

This project demonstrates a production-grade infrastructure and CI/CD workflow using cost-effective tools. It follows the architecture of building an end-to-end pipeline, containerizing with Docker, managing infrastructure with Terraform, orchestrating via Kubernetes, and ensuring reliability through monitoring.

## 1. CI/CD Pipeline (GitHub Actions)
**Objective:** Automate the transition from code to deployment.
- **Workflow:** On every `git push`, the pipeline triggers.
- **Jobs:**
    - **Lint & Test:** Verify code quality and run unit tests.
    - **Build & Push:** Create a Docker image and push it to the GitHub Container Registry (GHCR).
- **Tool:** GitHub Actions (Free for public and many private repos).

## 2. Docker Integration (Containerization)
**Objective:** Create a portable environment for the application.
- **The App:** A simple Python Flask or Node.js application that fetches weather data from a free API (like OpenWeatherMap).
- **Dockerfile:** Create a multi-stage build to keep the final image size small and secure.
- **Registry:** Store images in GitHub Container Registry or Docker Hub.

## 3. Infrastructure as Code (Terraform)
**Objective:** Provision cloud resources programmatically to avoid manual configuration.
- **Provider:** AWS (Free Tier) or Oracle Cloud (Always Free Tier).
- **Resources:**
    - **VPC/Network:** Define subnets and security groups.
    - **Compute:** Provision 2-3 small virtual machines (instances) to serve as Kubernetes nodes.
- **Outcome:** Running `terraform apply` builds your entire data center in minutes.

## 4. Kubernetes Deployment (Orchestration)
**Objective:** Manage scaling and high availability.
- **Distribution:** Use **K3s** (a lightweight Kubernetes distribution) which is perfect for small-scale cloud instances.
- **Manifests:**
    - **Deployment:** Define the number of replicas (e.g., 3 instances of the app).
    - **Service:** Load balance traffic across the replicas.
    - **Ingress:** Route external web traffic to the internal service.

## 5. Proper Monitoring (Observability)
**Objective:** Gain visibility into system health and performance.
- **Stack:** Prometheus & Grafana.
- **Metrics:**
    - **System:** Track CPU/RAM usage of your nodes.
    - **Application:** Track HTTP request latency and error rates.
- **Visualization:** Build a Grafana dashboard to visualize the health of the entire cluster.

---

## Implementation Roadmap (The "Nate" Strategy)
1. **Local Dev:** Build the app and `Dockerfile` locally.
2. **Infrastructure:** Use Terraform to spin up 2 Oracle Cloud ARM instances (Always Free).
3. **Cluster Setup:** Install K3s on those instances.
4. **Automation:** Configure GitHub Actions to deploy to the K3s cluster using `kubectl` or Helm.
5. **Observability:** Deploy the Prometheus-Grafana stack via a Helm chart to monitor the results.