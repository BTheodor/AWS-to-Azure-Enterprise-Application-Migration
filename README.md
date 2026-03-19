# AWS to Azure Enterprise Application Migration – Portfolio Project

## Overview
This repository showcases one of six enterprise-level cloud migration projects I have worked on, involving the migration of a mission-critical application from AWS to Microsoft Azure. I applied best practices in cloud architecture, security, governance, and DevOps to ensure a smooth and secure transition. The project demonstrates my hands-on expertise with Azure services, Infrastructure as Code (IaC), and the practical management of trade-offs and risks in complex cloud migrations.

> **Privacy & Confidentiality Notice:** As this project simulates a migration for a financial application ("GlobalFinance Portal"), all sensitive, private, and confidential data has been removed, anonymized, or replaced with architectural placeholders to comply with security best practices and data protection standards. No real customer data or proprietary business logic is contained within this repository.

## Business Problem
An organization is running a customer-facing "GlobalFinance Portal" on AWS with increasing operational cost, limited governance, and scalability challenges. The goal is to migrate the application to Microsoft Azure while improving:
- **Security and governance** (Zero Trust model)
- **Scalability and resilience** (PaaS-first approach)
- **Operational efficiency** (Managed services)
- **Cost optimization** (Serverless and right-sizing)
- **Time to market** (Automated CI/CD)

## Source Architecture (AWS)
The existing AWS environment consists of:
- **Web Tier:** React SPA hosted on NGINX/Ubuntu EC2 instances.
- **API Tier:** .NET Core Web API on Windows Server EC2 instances.
- **Data Tier:** Amazon RDS for SQL Server (Multi-AZ).
- **Storage:** Amazon S3 for user documents and static assets.
- **Networking:** Application Load Balancer (ALB), Route 53, and standard VPC.

**Challenges identified:** Limited automation, manual infrastructure changes, and high overhead for OS patching and maintenance.

## Target Architecture (Azure)
The application is migrated and modernized using Azure-native PaaS services:
- **Azure Landing Zone:** Hub-and-Spoke VNet model with dedicated subnets for integration and Private Endpoints.
- **Compute:** **Azure App Service** (Linux for Frontend, Windows for Backend) with Regional VNet Integration.
- **Database:** **Azure SQL Database** (General Purpose Serverless) for cost-efficient scaling.
- **Storage:** **Azure Blob Storage** with Zone-Redundant Storage (ZRS).
- **Edge:** **Azure Front Door** (Premium) providing Global Load Balancing and WAF.
- **Security:** **Azure Key Vault** for secrets and **Private Endpoints** for all data-tier services.

The design follows Microsoft Cloud Adoption Framework (CAF) and Well-Architected Framework (WAF) principles.

## Migration Strategy
The migration approach is based on the **6Rs methodology**, specifically focusing on **Replatforming** to maximize PaaS benefits:
- **Azure Database Migration Service (DMS):** Used for **Online Migration** of SQL Server to ensure minimal downtime.
- **AzCopy & Azure Data Factory:** Utilized for high-speed synchronization of S3 data to Azure Blob Storage.
- **Incremental Migration Waves:** Discovery, Pilot (Staging), and Production Cutover.

**Key considerations:** Minimal downtime via DNS cutover, 1-hour RPO/4-hour RTO, and a clear rollback plan.

## Architecture & Design Artifacts
This repository includes:
- **High-Level (HLD) and Low-Level (LLD) designs** (located in `02-architecture/`).
- **Network and Security models** emphasizing micro-segmentation.
- **Zero Trust Identity model** using System-Assigned Managed Identities.
- **Trade-off analysis** (e.g., App Service vs. AKS, SQL Serverless vs. Provisioned).

## Infrastructure as Code (IaC)
All Azure resources are provisioned using **Terraform**, organized into a modular structure:
- **03-Landing-Zone:** Foundation (VNet, Subnets, NSGs, Resource Groups).
- **04-Infrastructure:** Application-specific resources (App Services, SQL, Storage).
- **Best Practices:** Strict naming conventions, consistent tagging, and remote state management.

## Repository Structure
This repository is organized to reflect the end-to-end migration lifecycle:
- **`01-assessment/`**: Discovery, 6Rs analysis, and migration strategy documents.
- **`02-architecture/`**: High-level and low-level target Azure architecture designs.
- **`03-landing-zone/`**: Terraform code for the foundational Azure network and security.
- **`04-infrastructure/`**: Terraform code for application-specific PaaS resources (App Service, SQL, Storage).
- **`05-migration/`**: Technical guides and playbooks for data and database migration.
- **`06-devops/`**: Azure DevOps YAML pipelines for infrastructure and application deployment.
- **`07-operations/`**: Monitoring, backup, and cost optimization strategies.
- **`08-post-migration/`**: Modernization roadmap and lessons learned.
- **`src/`**: Functional source code for the **React Frontend** and **.NET Backend API**, used to demonstrate CI/CD automation.

## CI/CD and DevOps
The project implements robust CI/CD pipelines using **Azure DevOps YAML**:
- **Infrastructure Pipeline:** Automated Terraform Plan/Apply with manual approval gates for Production.
- **Application Pipeline:** .NET build, test, and deploy to App Service **Staging Slots** with automated swap to Production.
- **Governance:** Automated linting and validation checks.

## Security & Governance
Security is a foundational pillar of this migration:
- **Zero Trust:** Public network access is disabled for all data services; communication occurs exclusively via **Private Endpoints**.
- **Governance:** **Azure Policy** enforced for resource tagging and region restriction.
- **Secrets:** Zero-cleartext secret policy using Azure Key Vault and Managed Identities.

## Operations & Optimization
- **Monitoring:** Integrated **Azure Monitor** and **Application Insights** for end-to-end observability.
- **Cost Optimization:** Simulated AWS vs. Azure cost analysis showing a **~28% reduction** in monthly spend through Serverless SQL and PaaS efficiency.
- **Backup/DR:** Zone-redundant storage and SQL Point-in-Time Restore (PITR) enabled.

## Risks & Mitigations
| Risk | Mitigation |
| :--- | :--- |
| **Data migration failure** | Online replication via DMS with continuous validation. |
| **Downtime during cutover** | Parallel environment testing and DNS TTL reduction for rapid switch. |
| **Security misconfiguration** | IaC-based deployment with built-in NSG and Private Link controls. |
| **Cost overruns** | Azure SQL Serverless auto-pausing and Budget alerts. |

## Tools & Technologies Used
- **Cloud:** Microsoft Azure, Amazon Web Services (Source).
- **IaC:** Terraform.
- **DevOps:** Azure DevOps (Pipelines, Boards, Artifacts).
- **Data:** Azure SQL, Azure DMS, AzCopy.
- **Compute:** Azure App Service (.NET & React).
- **Security:** Azure Key Vault, Private Link, Entra ID (Azure AD).

## Results & Benefits
- **~28% Cost Reduction** compared to legacy AWS IaaS.
- **Zero Public Exposure** of backend data services.
- **Automated Deployments** reducing time-to-market from days to minutes.
- **Improved Resilience** through Zone-Redundant architectures.

## Lessons Learned
- **Replatforming over Rehosting:** Moving to PaaS immediately removed the "technical debt" of OS management.
- **Identity-First Security:** Managed Identities are superior to connection strings for long-term maintenance.
- **Data Gravity:** Starting data sync (S3/SQL) early is critical for meeting cutover windows.

## Future Enhancements
- **AKS-based microservices architecture** for Phase 2.
- **Multi-region disaster recovery** (Active-Active).
- **Zero Trust evolution** with Conditional Access and Microsoft Sentinel.
- **GitHub Actions** as an alternative CI/CD provider.

## Author
**Theodor Burcea
