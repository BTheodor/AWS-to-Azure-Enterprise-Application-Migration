# Security & Networking Design

## 1. Zero Trust Principles
The target architecture is built upon the **Zero Trust** security model: "Never trust, always verify." We achieve this through stringent identity controls, network micro-segmentation, and encryption at all stages.

## 2. Network Topology & Micro-segmentation

### 2.1 Hub and Spoke Model
The Azure Virtual Network (VNet) follows a standard Hub and Spoke topology (defined in the Landing Zone):
- **Hub VNet:** Contains shared services like Azure Firewall, VPN Gateway (for on-premises connectivity), and centralized logging.
- **Spoke VNet (Workload):** Dedicated to the "GlobalFinance Portal" application.

### 2.2 Subnet Design
The workload Spoke VNet is segmented into the following subnets:
1. **AppServiceSubnet:** Dedicated for App Service Regional VNet Integration.
2. **PrivateEndpointSubnet:** Houses all Private Endpoints for PaaS resources (SQL, Redis, Key Vault).

## 3. Inbound Traffic & WAF
- All inbound user traffic *must* flow through **Azure Front Door**.
- The Azure Front Door **Web Application Firewall (WAF)** is configured in Prevention mode with Managed Rule Sets to block SQLi, XSS, and other OWASP Top 10 vulnerabilities.
- **Access Restrictions:** The Azure App Services are configured to *only* accept traffic originating from the specific Azure Front Door instance (using `X-Azure-FDID` validation). Direct internet access to the App Services is blocked.

## 4. Backend Communication (Private Endpoints)
To secure the "Data Tier", we eliminate public internet exposure for the database, cache, and storage:
- **Azure SQL Database, Azure Cache for Redis, and Azure Blob Storage** have public network access completely disabled.
- They are accessed strictly via **Azure Private Endpoints** located in the `PrivateEndpointSubnet`.
- The .NET Backend API (App Service) uses **Regional VNet Integration** to route its outbound traffic into the VNet, allowing it to securely communicate with the database and storage via private IP addresses.

## 5. Identity & Access Management (RBAC)

### 5.1 Managed Identities
We eliminate the use of shared credentials (passwords/connection strings) wherever possible.
- The **.NET Backend App Service** is assigned a **System-Assigned Managed Identity**.
- This identity is granted explicit RBAC roles:
  - `Key Vault Secrets User` on the Azure Key Vault.
  - `Storage Blob Data Contributor` on the Storage Account.
  - `db_datareader` and `db_datawriter` roles within the Azure SQL Database (using Azure AD authentication for SQL).

### 5.2 Administrative Access
- Human access to the Azure Portal and CLI requires Multi-Factor Authentication (MFA) via Entra ID (Azure AD).
- Just-In-Time (JIT) access and Privileged Identity Management (PIM) are enforced for administrative roles.

## 6. Encryption
- **In Transit:** TLS 1.2+ is enforced for all inbound HTTP traffic and all backend service-to-service communication.
- **At Rest:** All data in Azure SQL, Blob Storage, and Redis is encrypted at rest using Microsoft-managed keys (with the option to upgrade to Customer-Managed Keys in Key Vault).