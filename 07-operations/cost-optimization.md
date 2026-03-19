# Cost Optimization & Governance

## 1. Objective
Optimize the Azure consumption costs of the "GlobalFinance Portal" while maintaining high performance and reliability.

## 2. Cost Management Strategy

### 2.1 Right-Sizing
- **App Service:** Start with **Premium V3 (P1v3)** instances and use **Autoscale** to scale out during peak hours and scale in during nights/weekends.
- **Azure SQL:** Utilize the **Serverless** compute tier for the database. This allows the database to automatically scale compute based on demand and **auto-pause** during periods of zero activity (e.g., in Dev/Test environments), saving significantly on costs.

### 2.2 Reserved Instances & Savings Plans
- For the Production environment, we will commit to a **1-year or 3-year Azure Reservation** for App Service and Azure SQL to achieve up to 40-60% savings compared to pay-as-you-go pricing.

### 2.3 Storage Lifecycle Management
- Implement policies on Azure Blob Storage to automatically move documents older than 90 days to the **Cool Tier** and documents older than 365 days to the **Archive Tier**.

## 3. Cost Comparison (Simulated: AWS vs. Azure)

| Tier | AWS Monthly Cost (Est.) | Azure Monthly Cost (Est.) | Savings/Notes |
| :--- | :--- | :--- | :--- |
| **Compute** | $450 (EC2 + ALB) | $320 (App Service + Front Door) | PaaS reduces OS management costs. |
| **Database** | $280 (RDS SQL Multi-AZ) | $190 (Azure SQL Serverless) | Serverless scaling is more efficient for variable workloads. |
| **Storage** | $150 (S3 Standard) | $120 (Blob ZRS) | Comparable, but Lifecycle policies reduce long-term costs. |
| **Total** | **$880** | **$630** | **~28% Reduction in Monthly Spend** |

## 4. Governance & Policies
- **Azure Policy:** Enforce tagging (Environment, Project, Owner) to ensure accurate cost center reporting.
- **Budget Alerts:** Set up Azure Cost Management budgets with alerts at 50%, 75%, and 90% of the monthly forecast.
- **Resource Locking:** Apply `CanNotDelete` locks on production-critical resources (VNets, SQL Servers) to prevent accidental deletion.

## 5. Tagging Standard
- `Project`: GlobalFinance
- `Environment`: Production
- `CostCenter`: IT-Operations
- `ManagedBy`: Terraform
