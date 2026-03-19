# Database Migration: AWS RDS SQL Server to Azure SQL

## 1. Objective
Migrate the production "GlobalFinance" database from Amazon RDS for SQL Server to Azure SQL Database with minimal downtime and zero data loss.

## 2. Migration Method: Online Migration
We have selected **Azure Database Migration Service (DMS)** using the "Online" migration path. This approach allows for continuous synchronization from the source AWS RDS instance to the target Azure SQL Database, reducing downtime to a brief cutover window.

## 3. Prerequisites
- **Azure DMS Instance:** Provisioned in the Hub or Spoke VNet.
- **Connectivity:** Site-to-Site VPN or ExpressRoute between AWS and Azure. Alternatively, public IP with firewall whitelisting (less secure).
- **Source Config:** AWS RDS instance must have `CDC` (Change Data Capture) enabled for online migration.
- **Target Config:** Azure SQL Database must be pre-provisioned (completed via Terraform).

## 4. Execution Steps

### Step 1: Initial Assessment
1. Run **Azure Data Studio** with the **Azure SQL Migration extension**.
2. Connect to the AWS RDS instance and run the "Assessment" to identify any compatibility issues.
3. Fix any schema-level blockers (e.g., unsupported CLR types or specific T-SQL syntax).

### Step 2: Schema Migration
1. Use **SQL Server Management Studio (SSMS)** or the **SQL Server Migration Assistant (SSMA)** to export the schema from AWS RDS.
2. Apply the schema (tables, indexes, stored procedures) to the target Azure SQL Database.

### Step 3: Migration Project Configuration
1. Create a new "Migration Project" in the Azure DMS portal.
2. Select **Source:** Amazon RDS for SQL Server.
3. Select **Target:** Azure SQL Database.
4. Select the tables to migrate.

### Step 4: Initial Load & Continuous Sync
1. DMS performs an initial full load of the data.
2. Once the initial load is complete, DMS enters the **Continuous Sync** phase, replicating any new transactions from AWS to Azure.

### Step 5: Cutover (The "Moment of Truth")
1. **Application Freeze:** Place the AWS application into Read-Only mode.
2. **Final Sync:** Wait for the "Pending Changes" count in DMS to reach zero.
3. **Failover:** In DMS, initiate the cutover. This disconnects the sync and makes the Azure SQL Database the primary source of truth.
4. **Update Connection Strings:** Update the .NET Backend App Service settings to point to the new Azure SQL FQDN.

## 5. Rollback Strategy
- If the cutover fails, the AWS RDS instance remains untouched and available.
- Re-enable write access on AWS RDS and point applications back to the original source.
- Analyze DMS logs for errors before re-attempting.

---
*Note: For smaller databases (<10GB), a BACPAC export/import can be used as a simpler alternative if a longer maintenance window is available.*