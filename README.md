<p align="center">
  <img src="https://raw.githubusercontent.com/Constellation-Overwatch/constellation-overwatch/main/pkg/services/web/static/images/favicon.svg" alt="Constellation Overwatch" width="120"/>
  <h1 align="center">Constellation Overwatch IaC Toolbelt</h1>
</p>

<p align="center">
  Open source Infrastructure as Code (IaC) toolbelt for rapid deployment of Constellation Overwatch C4ISR Server Mesh on Linode.
</p>

<p align="center">
  <a title="Build Status" target="_blank" href="https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt/actions"><img src="https://img.shields.io/github/actions/workflow/status/Constellation-Overwatch/overwatch-iac-toolbelt/ci.yml?style=flat-square"></a>
  <a title="License" target="_blank" href="https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt/blob/main/LICENSE"><img src="http://img.shields.io/badge/license-MIT-orange.svg?style=flat-square"></a>
  <br>
  <a title="GitHub Pull Requests" target="_blank" href="https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt/pulls"><img src="https://img.shields.io/github/issues-pr-closed/Constellation-Overwatch/overwatch-iac-toolbelt.svg?style=flat-square&color=FF9966"></a>
  <a title="GitHub Commits" target="_blank" href="https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt/commits/main"><img src="https://img.shields.io/github/commit-activity/m/Constellation-Overwatch/overwatch-iac-toolbelt.svg?style=flat-square"></a>
  <a title="Last Commit" target="_blank" href="https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt/commits/main"><img src="https://img.shields.io/github/last-commit/Constellation-Overwatch/overwatch-iac-toolbelt.svg?style=flat-square&color=FF9900"></a>
</p>

---

## About

The **Constellation Overwatch IaC Toolbelt** is a specialized suite of automation tools designed to streamline the deployment of the Constellation Overwatch C4ISR server mesh. By leveraging industry-standard Infrastructure as Code (IaC) principles, this toolbelt enables rapid, reproducible, and secure provisioning of cloud computing resources.

Currently optimized for **Linode**, it automates the entire lifecycle of your infrastructure—from spinning up virtual private servers (VPS) to configuring security layers and deploying the application stack.

> **⚠️ Warning:** This toolbelt currently **only supports Linode** as a cloud provider. Support for additional providers is planned for future releases.

## Features and Roadmap

*   **One-Command Deployment** using Task runner for a simplified developer experience
*   **Automated Provisioning** of Linode instances via Terraform
*   **Security Hardening** including UFW firewall, Fail2Ban, and SSH key enforcement
*   **Container Orchestration** with Docker and Docker Compose for application isolation
*   **Reverse Proxy Configuration** using Nginx with automatic SSL and rate limiting
*   **Idempotent Configuration** via Ansible to ensure consistent server state
*   **GHCR Integration** for pulling the latest authenticated container images
*   **Disaster Recovery** with automated backup and restore capabilities

The following features are on our current roadmap:

*   **Multi-Cloud Support** (AWS, GCP, Azure)
*   **Kubernetes (K8s) Support** for larger scale deployments
*   **GitOps Integration** for continuous delivery
*   **Monitoring Stack** with Prometheus and Grafana pre-configured
*   **VPN Integration** for secure private networking between nodes

## Architecture

### Deployment Architecture Diagram

```mermaid
graph TD
    subgraph "Local Control Plane"
        User[Operator]
        Task[Task Runner]
        TF[Terraform]
        Ansible[Ansible]
    end

    subgraph "Linode Cloud"
        VPS[Linode VPS<br/>(Ubuntu 24.04)]
        
        subgraph "Security Layer"
            FW[UFW Firewall]
            F2B[Fail2Ban]
            SSH[Hardened SSH]
        end
        
        subgraph "Application Layer"
            Nginx[Nginx Proxy]
            Docker[Docker Engine]
            
            subgraph "Containers"
                OW[Constellation Overwatch]
                NATS[Embedded NATS]
            end
        end
    end

    User --> Task
    Task --> TF
    Task --> Ansible
    
    TF -- "Provisions" --> VPS
    Ansible -- "Configures" --> VPS
    
    VPS --> FW
    FW --> Nginx
    Nginx --> OW
    OW --> NATS
    
    style User fill:#f9f,stroke:#333,stroke-width:2px
    style VPS fill:#00b159,stroke:#333,stroke-width:2px
    style OW fill:#4CAF50,stroke:#333,stroke-width:2px
```

## Getting Started

Please see the [Quick Start Guide](#quick-start) below for detailed usage examples.

<details>
<summary>📋 Prerequisites</summary>
<br>

- [Task](https://taskfile.dev/) - Task runner
- [Terraform](https://terraform.io/) >= 1.0
- [Ansible](https://ansible.com/) >= 2.9
- Linode Account and API Token
- GitHub Account (for GHCR access)

</details>

<details>
<summary>⚡ Quick Start</summary>
<br>

Clone the repository and initialize the configuration:

```bash
# Clone the repository
git clone https://github.com/Constellation-Overwatch/overwatch-iac-toolbelt.git
cd overwatch-iac-toolbelt

# Setup configuration
task setup-config
```

Edit the generated `config/terraform.tfvars` file with your credentials:

```hcl
linode_token    = "your-linode-token"
root_password   = "your-secure-password"
ssh_public_key  = "ssh-ed25519 ..."
github_username = "your-github-user"
github_token    = "your-github-token"
```

Deploy the infrastructure:

```bash
# Deploy everything
task deploy
```

</details>

<details>
<summary>🛠️ Available Commands</summary>
<br>

The `Taskfile.yml` provides a set of convenient commands:

```bash
task init       # Initialize Terraform and Ansible
task validate   # Validate configurations
task plan       # Preview infrastructure changes
task deploy     # Deploy complete stack
task update     # Update application only
task logs       # View application logs
task backup     # Create system backup
task destroy    # Destroy all infrastructure
```

</details>

## Project Structure

```
overwatch-iac-toolbelt/
├── ansible/            # Ansible playbooks and roles
│   ├── inventories/    # Inventory files (auto-generated)
│   ├── playbooks/      # Main deployment playbooks
│   └── roles/          # Reusable roles (common, docker, security, etc.)
├── config/             # Configuration files
│   └── terraform.tfvars # User configuration (git-ignored)
├── terraform/          # Terraform infrastructure definitions
│   ├── main.tf         # Main resources
│   ├── variables.tf    # Variable definitions
│   └── outputs.tf      # Output definitions
├── Taskfile.yml        # Task runner definitions
├── prd.md              # Product Requirements Document
└── README.md           # This file
```

## Contributing

We welcome contributions to the Constellation Overwatch IaC Toolbelt! Please check out our [contribution guidelines](CONTRIBUTING.md) to get started.

## License

This project is licensed under the [MIT License](LICENSE).