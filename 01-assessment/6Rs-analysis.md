# 6Rs Migration Analysis

## 1. Overview
The "6Rs" (Rehost, Replatform, Repurchase, Refactor, Retire, Retain) is a framework used to determine the best migration strategy for each component of the application portfolio. For the "GlobalFinance Portal" migration from AWS to Azure, we have analyzed the current architecture and identified the optimal path for each component.

## 2. Core Strategy: Replatforming (PaaS-First)
Our primary strategy for this migration is **Replatforming** (also known as "Lift, Tinker, and Shift"). 

**Why Replatform over Rehost (IaaS)?**
- Moving from AWS EC2 VMs directly to Azure VMs (IaaS) would carry over technical debt, OS management overhead, and patching responsibilities.
- By moving to Azure Platform-as-a-Service (PaaS) offerings like Azure App Service and Azure SQL, we reduce operational overhead, improve automated scaling, and enhance security without requiring a complete rewrite of the application code.

## 3. Component Analysis & Decisions

### 3.1 Frontend Web Servers (React SPA)
* **Current State:** NGINX on Ubuntu EC2 instances behind an ALB.
* **Migration Strategy:** **Replatform**
* **Target Azure Service:** **Azure App Service (Linux) or Azure Static Web Apps**
* **Rationale:** React SPAs do not require full VMs. Azure App Service can natively host Node/Nginx workloads, drastically reducing maintenance. Alternatively, Static Web Apps offer even lower costs and global distribution. (We will use App Service Linux for consistency with the backend deployment model).

### 3.2 Backend API Servers (.NET Core)
* **Current State:** IIS on Windows Server 2019 EC2 instances behind an ALB.
* **Migration Strategy:** **Replatform**
* **Target Azure Service:** **Azure App Service (Windows)**
* **Rationale:** .NET Core runs natively and excellently on Azure App Service. This eliminates the need to manage Windows Server updates, IIS configuration, and VM scaling.

### 3.3 Database (SQL Server)
* **Current State:** Amazon RDS for SQL Server (Multi-AZ).
* **Migration Strategy:** **Replatform**
* **Target Azure Service:** **Azure SQL Database (Provisioned or Serverless)**
* **Rationale:** Azure SQL Database provides a nearly 100% compatibility match with on-premises/RDS SQL Server but as a fully managed PaaS. It offers built-in high availability, automated backups, and advanced threat protection without managing the underlying OS.

### 3.4 Caching Layer (Redis)
* **Current State:** Amazon ElastiCache (Redis).
* **Migration Strategy:** **Replatform**
* **Target Azure Service:** **Azure Cache for Redis**
* **Rationale:** Direct 1:1 replacement. Azure Cache for Redis is a fully managed Redis service that requires zero code changes beyond updating connection strings.

### 3.5 Document Storage
* **Current State:** Amazon S3.
* **Migration Strategy:** **Replatform**
* **Target Azure Service:** **Azure Blob Storage**
* **Rationale:** Direct 1:1 replacement for object storage. Requires minor code updates in the .NET backend to use the Azure Storage SDK instead of the AWS SDK.

### 3.6 CI/CD Pipelines
* **Current State:** AWS CodePipeline & CodeBuild.
* **Migration Strategy:** **Refactor / Replatform**
* **Target Azure Service:** **Azure DevOps (Pipelines) or GitHub Actions**
* **Rationale:** Pipelines must be rewritten. We will build new Terraform pipelines for Infrastructure as Code and application deployment pipelines.

## 4. Summary Table

| AWS Component | 6R Strategy | Azure Target |
| :--- | :--- | :--- |
| React Frontend (EC2) | Replatform | Azure App Service (Linux) |
| .NET Backend (EC2) | Replatform | Azure App Service (Windows) |
| SQL Server (RDS) | Replatform | Azure SQL Database |
| Redis (ElastiCache) | Replatform | Azure Cache for Redis |
| File Storage (S3) | Replatform | Azure Blob Storage |
| DNS (Route53) | Replatform | Azure DNS |
| CDN (CloudFront) | Replatform | Azure Front Door |
| WAF (AWS WAF) | Replatform | Azure WAF (on Front Door) |
| Secrets (Secrets Manager) | Replatform | Azure Key Vault |