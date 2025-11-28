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

# Setup configuration files
task setup-config
```

Edit the generated `.env` file with your credentials:

```bash
# Linode Configuration
TF_VAR_linode_token="your_linode_personal_access_token"
TF_VAR_root_password="your_secure_root_password"

# SSH Configuration
TF_VAR_ssh_public_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExample your-email@example.com"
TF_VAR_ssh_private_key_file="~/.ssh/id_ed25519"

# GitHub Container Registry 
TF_VAR_github_username="your_github_username"
TF_VAR_github_token="ghp_your_github_personal_access_token"

# Domain Configuration (optional - leave empty for IP-only access)
TF_VAR_domain_name=""  # e.g., "constellation.example.com"
TF_VAR_domain_email="" # e.g., "admin@example.com"
```

Deploy the infrastructure:

```bash
# Deploy everything
task deploy

# Check deployment status
task status

# Full health check
task health
```

</details>

<details>
<summary>🛠️ Available Commands</summary>
<br>

The `Taskfile.yml` provides a set of convenient commands:

```bash
# Setup and Configuration
task setup-config  # Copy configuration files from examples
task init          # Initialize Terraform and Ansible
task validate      # Validate configurations

# Deployment and Management  
task plan          # Preview infrastructure changes
task deploy        # Deploy complete stack
task configure     # Run Ansible configuration only
task update        # Update application only

# Monitoring and Debugging
task status        # Quick deployment status
task health        # Comprehensive health check
task logs          # View application logs

# Maintenance
task backup        # Create system backup
task destroy       # Destroy all infrastructure
```

</details>

<details>
<summary>⚙️ Customization</summary>
<br>

### Deployment Modes

**HTTP-Only Mode (Default)**
```bash
# Leave domain fields empty for IP-only access
TF_VAR_domain_name=""
TF_VAR_domain_email=""
```
- Access via server IP on port 80 (HTTP)
- No SSL certificates required
- Ideal for development and internal networks

**HTTPS Mode with Domain**
```bash
# Configure domain for SSL certificates
TF_VAR_domain_name="constellation.yourdomain.com"  
TF_VAR_domain_email="admin@yourdomain.com"
```
- Automatic SSL certificates via Let's Encrypt
- HTTP redirects to HTTPS
- Production-ready configuration

### Application Configuration

The deployment automatically configures the Constellation Overwatch application with secure defaults:

```yaml
# API Security
API_BEARER_TOKEN: "reindustrialize-dev-token"

# Network Binding  
HOST: "0.0.0.0"          # All interfaces
PORT: "8080"             # Web UI and API port

# NATS Messaging
NATS_HOST: "0.0.0.0"     # All interfaces  
NATS_PORT: "4222"        # NATS client port
NATS_ENABLE_AUTH: "true" # Authentication enabled
NATS_AUTH_TOKEN: "reindustrialize-america"

# Web UI
WEB_UI_PASSWORD: "reindustrialize"
ALLOWED_ORIGINS: "*"     # CORS policy (development)
```

### Advanced Customization

To modify application settings, edit the template files:

- **Environment Variables**: `ansible/roles/constellation/templates/constellation.env.j2`
- **Docker Configuration**: `ansible/roles/constellation/templates/docker-compose.yml.j2` 
- **Nginx Proxy**: `ansible/roles/constellation/templates/nginx.conf.j2`
- **Systemd Service**: `ansible/roles/constellation/templates/constellation-overwatch.service.j2`

After modifications, redeploy with:
```bash
task configure  # Apply configuration changes only
# or
task deploy     # Full deployment
```

</details>

## Project Structure

```
overwatch-iac-toolbelt/
├── ansible/                    # Ansible playbooks and roles
│   ├── inventories/           # Inventory files (auto-generated by Terraform)
│   ├── playbooks/            # Main deployment playbooks
│   │   ├── site.yml         # Complete system configuration
│   │   └── deploy.yml       # Application updates only
│   ├── roles/               # Reusable configuration roles
│   │   ├── security/        # UFW firewall, Fail2Ban, SSH hardening
│   │   ├── docker/          # Docker Engine installation
│   │   └── constellation/   # Application deployment and configuration
│   ├── requirements.yml     # External role dependencies
│   └── ansible.cfg          # Ansible configuration
├── config/                  # Configuration examples
│   └── ansible.cfg.example  # Ansible configuration template
├── terraform/               # Infrastructure as Code
│   ├── main.tf             # Linode resources and local files
│   ├── variables.tf        # Input variable definitions
│   ├── outputs.tf          # Output definitions
│   └── inventory.tpl       # Ansible inventory template
├── keys/                    # SSH keys (git-ignored)
├── .env.example            # Environment variables template
├── Taskfile.yml            # Automation commands
├── prd.md                  # Product Requirements Document
└── README.md               # This documentation
```

## Contributing

We welcome contributions to the Constellation Overwatch IaC Toolbelt! Please check out our [contribution guidelines](CONTRIBUTING.md) to get started.

## License

This project is licensed under the [MIT License](LICENSE).