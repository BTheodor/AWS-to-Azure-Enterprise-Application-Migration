# Target Azure Architecture

## 1. Overview
This document details the specific Azure services, SKUs, and configurations that make up the target architecture for the migrated application.

## 2. Resource Specifications

### 2.1 Networking & Delivery
| Component | Azure Service | SKU / Tier | Purpose |
| :--- | :--- | :--- | :--- |
| **Global Load Balancer** | Azure Front Door | Premium | Global routing, CDN, and advanced WAF. |
| **Virtual Network** | Azure VNet | Standard | Logical isolation for backend resources. |
| **Private DNS** | Azure Private DNS Zones | Standard | Name resolution for Private Endpoints. |

### 2.2 Compute (Web & API)
| Component | Azure Service | SKU / Tier | Count | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Frontend App** | App Service (Linux) | Premium V3 (P1v3) | 2-4 | Hosting the React SPA. Auto-scales on CPU/Memory. |
| **Backend API** | App Service (Windows) | Premium V3 (P2v3) | 2-6 | Hosting the .NET Core API. VNet Integrated. |

### 2.3 Data & Storage
| Component | Azure Service | SKU / Tier | Purpose |
| :--- | :--- | :--- | :--- |
| **Primary Database** | Azure SQL Database | General Purpose (Serverless) | Relational database. Auto-pauses and scales based on compute demand. |
| **Cache** | Azure Cache for Redis | Standard (C1) | Session state and frequent API response caching. |
| **Document Storage** | Azure Storage Account | Standard general-purpose v2 (ZRS) | Zone-redundant blob storage for user files. |

### 2.4 Management & Security
| Component | Azure Service | SKU / Tier | Purpose |
| :--- | :--- | :--- | :--- |
| **Secrets Manager** | Azure Key Vault | Standard | Storing DB connection strings, API keys, and TLS certificates. |
| **Monitoring** | Azure Monitor & Log Analytics | Pay-as-you-go | Centralized logging, metrics collection, and alerting. |
| **Application Insights** | Application Insights | Pay-as-you-go | APM (Application Performance Monitoring) for the .NET API. |

## 3. High Availability & Disaster Recovery
- **Availability Zones:** All critical services (App Service, Azure SQL, Redis, Storage) are deployed using Zone Redundancy to protect against datacenter-level failures.
- **Backups:** Azure SQL Database automatically maintains 35 days of point-in-time restore backups. Blob storage uses soft delete and versioning.
- **Cross-Region DR (Optional Phase 2):** In the future, a secondary region (e.g., East US paired with West US) can be established, with Azure Front Door routing traffic to the active region and Geo-Replication enabled on Azure SQL and Blob Storage.