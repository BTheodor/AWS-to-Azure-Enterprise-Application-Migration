# VM Migration: AWS EC2 to Azure App Service (Replatforming)

## 1. Context
Although we are **replatforming** the core application to Azure App Service (PaaS), some legacy background services or administrative utilities currently running on EC2 instances might require a direct **rehost** (IaaS) or a staged migration. This document outlines the process for those specific components.

## 2. Recommended Tool: Azure Migrate
Azure Migrate is the primary service for discovering, assessing, and migrating on-premises and AWS workloads to Azure.

## 3. Migration Workflow

### Step 1: Discovery & Assessment
1. Deploy the **Azure Migrate Appliance** (simulated) or use the agent-based discovery.
2. Perform a dependency analysis to ensure all required ports and background services are accounted for.
3. Review the **Azure Migrate Assessment** report for "Azure Readiness" and estimated costs.

### Step 2: Replication
1. Install the **Azure Site Recovery (ASR)** agent on the AWS EC2 instances.
2. Initiate continuous replication of the VM disks from AWS to the Azure Managed Disks in the target region.
3. Monitor the "Health" of the replication in the Azure Migrate portal.

### Step 3: Test Migration (Dry Run)
1. Perform a "Test Failover" in Azure Migrate.
2. This creates a clone of the VM in a non-production VNet.
3. Verify that the application starts, services are running, and internal connectivity works.
4. Clean up the test migration once validated.

### Step 4: Final Cutover
1. Shut down the AWS EC2 instances to ensure no new data is written.
2. Perform the final replication sync.
3. Initiate the "Migrate" action in Azure Migrate.
4. The VM is provisioned in Azure, and its IP address/DNS is updated within the VNet.

## 4. Post-Migration Cleanup
- Uninstall the ASR agents.
- Decommission the AWS EC2 instances and associated EBS volumes.
- Update the Azure Backup policy to include the new VMs.

## 5. Why we chose Replatforming for the Main App
It is important to note that for the main **GlobalFinance Portal**, we opted *against* VM migration in favor of Azure App Service. 
- **Efficiency:** App Service eliminates the need for managing OS-level replication.
- **Modernization:** It allows us to immediately leverage features like Deployment Slots, Auto-scaling, and Managed Identities which are not available on standard VMs.
