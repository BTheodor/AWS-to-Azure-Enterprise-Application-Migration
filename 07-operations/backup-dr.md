# Backup & Disaster Recovery (DR) Strategy

## 1. Objective
Ensure the resilience of the "GlobalFinance Portal" against data loss and regional outages, meeting the business RTO (Recovery Time Objective) of 4 hours and RPO (Recovery Point Objective) of 1 hour.

## 2. Backup Strategy (Local Resilience)

### 2.1 Azure SQL Database
- **Point-in-Time Restore (PITR):** Automatically enabled. Backups are taken every 5-10 minutes (transaction logs) and daily (full backups). 
- **Retention:** Configured for 35 days of short-term retention.
- **Redundancy:** Backups are stored in **Zone-Redundant Storage (ZRS)**.

### 2.2 Azure Blob Storage
- **Soft Delete:** Enabled for blobs and containers (14-day retention) to protect against accidental deletions.
- **Versioning:** Enabled to allow recovery of previous file versions.
- **Redundancy:** Uses **Zone-Redundant Storage (ZRS)**.

### 2.3 App Service
- **Code:** Persisted in GitHub/Azure DevOps. Deployment is fully automated via CI/CD.
- **Configuration:** Managed as code via Terraform.

## 3. Disaster Recovery Strategy (Regional Resilience)

### 3.1 Multi-Region Design (Proposed)
To achieve high availability in the event of a total Azure region failure:
- **Secondary Region:** Provision a mirrored environment in a paired region (e.g., East US paired with West US).
- **Traffic Routing:** **Azure Front Door** performs global load balancing. In the event of Primary region health check failure, traffic is automatically rerouted to the Secondary region.

### 3.2 Data Replication
- **Azure SQL:** Enable **Active Geo-Replication**. The secondary database is kept in sync and can be promoted to primary during a failover.
- **Blob Storage:** Enable **Geo-Zone-Redundant Storage (GZRS)**. Data is replicated asynchronously to the secondary region.

## 4. Recovery Procedures
- **Database Failover:** Manual or automatic failover via the Azure Portal or CLI.
- **DNS Update:** If not using Front Door, update DNS CNAME records to point to the secondary region's endpoint.
- **Verification:** Execute smoke tests in the secondary region before opening traffic to users.

## 5. DR Drills
- Conduct semi-annual "Game Day" exercises where a simulated regional failure is triggered in the staging environment to validate the failover process and documentation.
