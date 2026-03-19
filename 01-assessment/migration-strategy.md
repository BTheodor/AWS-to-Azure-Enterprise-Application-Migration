# Migration Strategy & Execution Plan

## 1. Objective
Define a structured, low-risk approach to migrating the "GlobalFinance Portal" from AWS to Azure. The primary goals are to ensure data integrity, minimize downtime, and seamlessly transition traffic to the new Azure infrastructure.

## 2. Discovery Approach
To validate the infrastructure inventory and dependency mapping, the following discovery approach was utilized (simulated):
- **Automated Discovery:** Used AWS Application Discovery Service and Azure Migrate (Discovery and Assessment tool) to map server dependencies, network connections, and database performance metrics.
- **Codebase Scanning:** Analyzed the .NET backend to identify hardcoded AWS SDK references (e.g., S3 integration) that need replacement with Azure SDK equivalents.
- **Stakeholder Interviews:** Identified maintenance windows, compliance requirements, and third-party integrations (e.g., VPNs, Payment Gateways).

## 3. Migration Phases

### Phase 1: Preparation & Landing Zone Setup
1. Deploy the Azure Landing Zone via Terraform (Management Groups, Subscriptions, Hub-Spoke VNet, Policies).
2. Establish Identity integration (Azure AD / Entra ID).
3. Set up Azure DevOps CI/CD pipelines for infrastructure deployment.
4. Deploy Target PaaS Resources (App Services, Azure SQL, Redis, Storage) using Terraform.

### Phase 2: Application Modernization & Testing
1. **Code Modification:** Update the .NET backend to replace AWS SDK for S3 with Azure Blob Storage SDK. Update connection string logic to pull from Azure Key Vault.
2. **Initial Data Sync:** Perform an offline copy of S3 data to Azure Blob Storage using Azure Data Factory or AzCopy.
3. **Database Schema Sync:** Use Azure Database Migration Service (DMS) to replicate the RDS SQL schema to Azure SQL.
4. **UAT (User Acceptance Testing):** Deploy the application to the Azure staging environment and conduct end-to-end testing against the replicated database.

### Phase 3: The Cutover Strategy (Blue/Green Deployment)
To minimize downtime, we will use a parallel deployment strategy. 

**Pre-Cutover (T-minus 24 Hours):**
1. Initiate continuous data replication for the database using Azure DMS (Online Migration).
2. Perform a delta-sync of the AWS S3 bucket to Azure Blob Storage using AzCopy to catch any newly uploaded documents.
3. Lower DNS TTL on AWS Route 53 to 60 seconds.

**Cutover Window (Maintenance Window - 2 Hours):**
1. **Freeze:** Put the AWS application into "Maintenance Mode" (Read-only or offline) to prevent new data writes.
2. **Final Data Sync:** Ensure Azure DMS completes the final replication transaction. Failover the database so Azure SQL becomes the primary.
3. **Final Blob Sync:** Run a final AzCopy delta sync.
4. **Traffic Switch:** Update public DNS records to point the domain to Azure Front Door / Application Gateway.
5. **Validation:** Perform smoke testing on production URLs.

**Post-Cutover:**
1. Monitor Azure Application Insights and Log Analytics for errors.
2. Verify autoscaling rules are triggering correctly on App Services.

## 4. Downtime Minimization
- **Online Database Migration:** By using Azure DMS in "Online" mode, the SQL database synchronizes continuously, reducing the final cutover time to minutes (just the time it takes to switch connections).
- **Parallel Environments:** The Azure environment will be fully provisioned, tested, and warmed up before any traffic is routed to it.
- **DNS TTL Reduction:** Lowering the TTL ensures global DNS caches expire quickly, directing users to Azure rapidly upon cutover.

## 5. Rollback Plan
If critical, unresolvable issues occur during the validation phase of the cutover window:
1. Revert the DNS changes back to the AWS ALB.
2. Take the Azure application offline.
3. Since the AWS environment was placed in Read-Only mode and no new data was written to Azure (or if it was, it's considered disposable), the AWS database remains the source of truth.
4. Analyze logs to determine the root cause of the failure and reschedule the cutover.
*Note: Once DNS changes have propagated and the Azure environment is taking live read/write traffic, rollback becomes significantly more complex (requiring reverse data replication) and is generally avoided in favor of "failing forward" (fixing issues live).*