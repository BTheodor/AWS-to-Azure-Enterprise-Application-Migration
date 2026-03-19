# AWS Source Environment Inventory

## 1. Executive Summary
This document provides a comprehensive inventory of the current AWS infrastructure hosting the legacy multi-tier enterprise application ("GlobalFinance Portal"). This inventory serves as the baseline for our migration assessment and Azure target architecture design.

## 2. Application Architecture Overview
The current application is a traditional 3-tier architecture:
- **Presentation Layer:** React-based Single Page Application (SPA).
- **Application Layer:** .NET Core Web API handling business logic and integrations.
- **Data Layer:** Relational data stored in SQL Server, with caching provided by Redis and object storage for user documents.

## 3. Detailed Infrastructure Inventory

### 3.1 Compute (Amazon EC2 & Auto Scaling)
| Component | AWS Service | Instance Type | Count | OS | Purpose |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Frontend Web Servers** | EC2 (Auto Scaling) | `t3.medium` | 2-4 | Ubuntu 22.04 | NGINX hosting React static files |
| **Backend API Servers** | EC2 (Auto Scaling) | `m5.large` | 2-6 | Windows Server 2019 | Hosting .NET Core Web API (IIS) |
| **Bastion Host** | EC2 | `t3.micro` | 1 | Amazon Linux 2 | Secure administrative access |

### 3.2 Database & Storage
| Component | AWS Service | Specifications | Size/Volume | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Primary Database** | Amazon RDS for SQL Server | `db.m5.xlarge`, Multi-AZ | 500 GB | Core transactional database |
| **Cache** | Amazon ElastiCache (Redis) | `cache.t3.medium` | 2 Nodes | Session state and API caching |
| **Document Storage** | Amazon S3 | Standard Tier | 2 TB | Storing user-uploaded PDF/Images |

### 3.3 Networking & Security
| Component | AWS Service | Details | Purpose |
| :--- | :--- | :--- | :--- |
| **Load Balancing** | Application Load Balancer (ALB) | 2 ALBs (Public & Internal) | Traffic distribution for Web & API |
| **DNS Management** | Amazon Route 53 | Public Hosted Zone | Domain name resolution |
| **Content Delivery** | Amazon CloudFront | Global Distribution | Caching static web assets |
| **Firewall / WAF** | AWS WAF | Attached to Public ALB | Protection against common web exploits |
| **VPC & Subnets** | Amazon VPC | 1 VPC, 6 Subnets (3x Public, 3x Private) | Network isolation across 3 AZs |
| **Secrets Management** | AWS Secrets Manager | Standard | Storing DB credentials and API keys |

## 4. Operational & Monitoring Tools
- **Logging & Metrics:** Amazon CloudWatch (Logs, Alarms, Metrics).
- **Infrastructure as Code:** CloudFormation (currently used, migrating to Terraform for Azure).
- **CI/CD Pipeline:** AWS CodePipeline & CodeBuild.

## 5. Discovered Dependencies & Integration Points
1. **Third-Party Payment Gateway:** Outbound API calls from Backend API (requires NAT Gateway/static outbound IP).
2. **On-Premises Active Directory:** Site-to-Site VPN to corporate HQ for employee authentication.
3. **SMTP Relay:** Amazon SES for sending transactional emails.

---
*Note: This inventory was generated using simulated output from AWS Application Discovery Service and manual stakeholder interviews.*