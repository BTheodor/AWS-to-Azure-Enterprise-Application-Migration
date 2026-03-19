# Monitoring & Observability Design

## 1. Objective
Establish a comprehensive monitoring and observability framework for the "GlobalFinance Portal" using Azure-native tools, ensuring high availability and rapid incident response.

## 2. Monitoring Stack: Azure Monitor
We leverage the **Azure Monitor** suite to collect, analyze, and act on telemetry from our PaaS resources.

### 2.1 Application Insights (APM)
- **Target:** .NET Backend API and React Frontend (via SDK).
- **Key Features:**
  - **Live Metrics:** Real-time monitoring of request rates, response times, and failure rates.
  - **Application Map:** Visual representation of service dependencies and performance bottlenecks.
  - **Transaction Diagnostics:** End-to-end tracing of requests from the frontend to the backend and database.
  - **Exceptions & Logs:** Automatic capture of stack traces and correlation with custom traces.

### 2.2 Log Analytics
- **Centralized Logging:** All Azure resources (App Service, Azure SQL, Redis, Front Door) are configured to send their diagnostic logs to a central **Log Analytics Workspace**.
- **Kusto Query Language (KQL):** Used for advanced analysis, such as identifying spikes in 4xx/5xx errors or analyzing database performance trends.

## 3. Alerting Strategy
We use **Azure Monitor Alerts** to notify the DevOps team of critical issues:
- **Availability Alerts:** Triggered if the App Service health check or an external ping test fails.
- **Latency Alerts:** Triggered if the 95th percentile (P95) response time exceeds 2 seconds.
- **Error Rate Alerts:** Triggered if the HTTP 5xx error rate exceeds 5% over a 5-minute window.
- **Resource Exhaustion:** Triggered if App Service Plan CPU/Memory exceeds 80% or Azure SQL DTU/vCore usage is consistently high.

## 4. Dashboards & Visualization
- **Azure Dashboards:** A single-pane-of-glass dashboard displaying the health of all tiers (Front Door, App Service, SQL).
- **Workbooks:** Custom interactive reports for long-term trend analysis and performance audits.

## 5. Security Monitoring (Microsoft Defender for Cloud)
- Continuous assessment of the security posture of our Azure resources.
- Recommendations for hardening (e.g., enabling SQL vulnerability assessment).
- Detection of potential threats, such as SQL injection attempts or unusual access patterns on the storage account.
