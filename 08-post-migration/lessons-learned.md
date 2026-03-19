# Lessons Learned: AWS to Azure Migration

## 1. Overview
This document summarizes the key takeaways from the migration of the "GlobalFinance Portal". Capturing these lessons is vital for refining the migration factory model and improving future cloud transitions.

## 2. Successes

### 2.1 Replatforming vs. Rehosting
The decision to replatform to **Azure App Service** and **Azure SQL** was the single greatest success factor. It immediately eliminated the need for OS-level patching and allowed the DevOps team to focus on deployment automation rather than infrastructure maintenance.

### 2.2 Infrastructure as Code (IaC)
Utilizing a modular **Terraform** structure ensured that the development, staging, and production environments were 100% identical. This eliminated the "it works on my machine" class of errors during the final cutover.

### 2.3 Managed Identities
Moving away from SQL connection strings stored in `appsettings.json` to **Azure Managed Identities** significantly improved our security posture and simplified credential rotation.

## 3. Challenges & Mitigations

### 3.1 S3 to Blob Metadata
- **Challenge:** We discovered that some legacy application logic relied on specific S3 metadata tags that did not map directly to Azure Blob metadata during the initial AzCopy.
- **Mitigation:** We developed a small PowerShell script to post-process the blobs after migration to re-apply the necessary metadata values.

### 3.2 SQL Server Compatibility
- **Challenge:** The AWS RDS SQL instance used several "Cross-Database Queries" which are not supported in the single-database model of Azure SQL Database.
- **Mitigation:** We consolidated the secondary lookup tables into the main database and updated the .NET repository layer to remove the cross-db references.

### 3.3 Network Latency during Sync
- **Challenge:** During the "Online" database migration via DMS, we experienced higher than expected latency over the standard Internet-based VPN.
- **Mitigation:** We increased the DMS instance size and optimized the replication batch sizes to improve throughput during the final sync.

## 4. Key Takeaways for Future Projects
- **Early Assessment:** Run the Azure Migrate assessment *before* committing to a target architecture.
- **Data First:** Start data replication (S3 and SQL) as early as possible. Data is the "heavy" part of any migration.
- **Zero Trust by Default:** Building networking with Private Endpoints from Day 1 is easier than trying to "bolt it on" later.
- **Communication:** Daily standups between the AWS (Source) and Azure (Target) teams are essential during the cutover week.
