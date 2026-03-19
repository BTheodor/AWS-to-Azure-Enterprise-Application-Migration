# High-Level Architecture (HLD)

## 1. Architecture Paradigm Shift
The migration of the "GlobalFinance Portal" from AWS to Azure represents a strategic shift from **Infrastructure-as-a-Service (IaaS)** to **Platform-as-a-Service (PaaS)**. 

### Why PaaS?
While a "lift-and-shift" (rehost) of VMs from AWS EC2 to Azure VMs is the fastest path, it carries over technical debt. By adopting Azure App Service and Azure SQL, we achieve:
- **Reduced Operational Overhead:** No OS patching, security hardening, or middleware management.
- **Elastic Scalability:** Built-in auto-scaling based on HTTP metrics, CPU, or memory.
- **Enhanced Security:** Managed identities, easy VNet integration, and automatic TLS/SSL management.

## 2. Multi-Tier Conceptual Architecture
The system maintains its logical 3-tier architecture, implemented via Azure native services.

### Tier 1: Delivery & Edge (Global)
- **Component:** Azure Front Door.
- **Purpose:** Acts as the global entry point. Provides Web Application Firewall (WAF), global load balancing, SSL termination, and static content caching (replacing AWS CloudFront and ALB).

### Tier 2: Presentation & Application (Compute)
- **Component:** Azure App Service.
- **Frontend:** Linux App Service hosting the React SPA.
- **Backend:** Windows App Service hosting the .NET Core Web API.
- **Purpose:** Handles all user interactions and business logic. Scales out automatically based on demand.

### Tier 3: Data & State (Storage)
- **Component:** Azure SQL Database & Azure Cache for Redis.
- **Purpose:** Relational data storage and high-speed, in-memory caching for session states and frequently accessed API data.
- **Component:** Azure Blob Storage.
- **Purpose:** Unstructured data storage for user-uploaded documents (replacing AWS S3).

## 3. High-Level Traffic Flow
1. A user requests the application via their browser.
2. The request hits **Azure Front Door**, which evaluates WAF rules and serves static assets if cached.
3. Dynamic frontend requests are routed to the **React App Service**.
4. The React app makes asynchronous API calls back through Front Door to the **.NET Core App Service**.
5. The .NET API securely queries **Azure Cache for Redis** or **Azure SQL Database** to retrieve/manipulate data.
6. If the user requests a document, the API generates a SAS (Shared Access Signature) token, allowing the frontend to securely download the file directly from **Azure Blob Storage**.