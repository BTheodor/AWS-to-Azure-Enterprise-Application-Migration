# AWS to Azure Enterprise Application Migration – Portfolio Project

## Overview

This repository demonstrates an **end-to-end migration of an enterprise application from AWS to Microsoft Azure**, following industry best practices for cloud architecture, security, governance, and DevOps.
The project showcases **architecture leadership**, **hands-on Azure implementation**, **Infrastructure as Code**, and **clear communication of trade-offs and risks**, aligned with real-world cloud migration programs.

## Business Problem

An organization is running a customer-facing application on AWS with increasing operational cost, limited governance, and scalability challenges. The goal is to migrate the application to **Microsoft Azure** while improving:

* Security and governance
* Scalability and resilience
* Operational efficiency
* Cost optimization
* Time to market

---

## Source Architecture (AWS)

The existing AWS environment consists of:

* EC2 instances hosting Web and API tiers
* RDS MySQL for transactional data
* S3 for static content and backups
* Application Load Balancer
* IAM roles and security groups

Challenges identified:

* Limited automation
* Manual infrastructure changes
* No standardized governance model
* Scaling requires operational overhead

---

## Target Architecture (Azure)

The application is migrated and modernized using Azure native services:

* Azure Landing Zone (hub-and-spoke model)
* Azure App Service for Web and API tiers
* Azure Database for MySQL or Azure SQL
* Azure Blob Storage
* Azure Application Gateway
* Azure Monitor and Log Analytics
* Azure DevOps CI/CD pipelines
* Full Infrastructure as Code using Terraform

The design follows Microsoft Cloud Adoption Framework principles.

---

## Migration Strategy

The migration approach is based on the **6Rs methodology**:

* Rehost for initial infrastructure workloads
* Replatform application tiers to PaaS
* Refactor selected components for scalability
* Retire unused resources

Key considerations:

* Minimal downtime
* Rollback capability
* Security-first approach
* Incremental migration waves

---

## Architecture & Design Artifacts

This repository includes:

* High-level and low-level architecture designs
* Network and security models
* Data flow diagrams
* Non-functional requirements (availability, performance, RTO/RPO)
* Trade-off analysis (App Service vs AKS, Azure SQL vs Cosmos DB)

---

## Infrastructure as Code

All Azure resources are provisioned using **Terraform**, including:

* Management groups and subscriptions
* Virtual networks and subnets
* Application services
* Databases and storage accounts
* Monitoring and governance controls

The IaC design emphasizes:

* Modularity
* Reusability
* Environment separation (dev/test/prod)
* Consistent naming and tagging standards

---

## CI/CD and DevOps

The project implements CI/CD pipelines using Azure DevOps:

* Terraform deployment pipeline
* Application build and release pipeline
* Manual approvals for production
* Automated validation and quality checks

This enables repeatable, reliable, and auditable deployments.

---

## Security & Governance

Security is built into the architecture:

* Azure Active Directory and RBAC
* Network isolation and private endpoints
* Azure Policy for compliance enforcement
* Centralized logging and monitoring
* Secure secrets management

---

## Operations & Optimization

Post-migration activities include:

* Monitoring and alerting setup
* Backup and disaster recovery strategy
* Cost optimization and right-sizing
* Performance tuning
* Operational runbooks

---

## Risks & Mitigations

| Risk                      | Mitigation                   |
| ------------------------- | ---------------------------- |
| Data migration failure    | Dry runs and validation      |
| Downtime during cutover   | Blue/green deployment        |
| Security misconfiguration | Policy-based governance      |
| Cost overruns             | Budget alerts and monitoring |

---

## Tools & Technologies Used

* Microsoft Azure
* Amazon Web Services (source)
* Terraform
* Azure DevOps
* Azure App Service
* Azure SQL / Azure Database for MySQL
* Azure Storage (Blob)
* Azure Monitor and Log Analytics

---

## Results & Benefits

* Improved scalability and resilience
* Reduced operational overhead
* Standardized governance and security
* Faster deployment cycles
* Clear cost visibility and optimization

---

## Lessons Learned

* Early assessment and dependency mapping are critical
* IaC significantly reduces operational risk
* Governance must be designed from day one
* Incremental modernization delivers faster value

---

## Future Enhancements

* AKS-based microservices architecture
* Multi-region disaster recovery
* Advanced analytics using Azure Synapse
* Zero Trust security enhancements
* GitHub Actions as alternative CI/CD

---

## Author

Theodor Burcea


