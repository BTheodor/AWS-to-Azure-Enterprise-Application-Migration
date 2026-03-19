# Data Migration: Amazon S3 to Azure Blob Storage

## 1. Objective
Migrate approximately 2 TB of user-uploaded documents (PDFs, Images, Logs) from AWS S3 to Azure Blob Storage while maintaining file integrity and metadata.

## 2. Migration Tools
We will use **AzCopy**, a high-performance command-line utility designed for copying data to/from Azure Storage. For large-scale enterprise migrations, **Azure Data Factory** would be the preferred alternative for scheduling and monitoring.

## 3. Security & Authentication
- **AWS Side:** Create an IAM user with `AmazonS3ReadOnlyAccess` and generate an Access Key / Secret Key.
- **Azure Side:** Generate a **SAS (Shared Access Signature) Token** for the target Blob Storage container with `Write` and `Add` permissions.

## 4. Migration Execution

### Step 1: Initial Migration (The "Bulk" Load)
Run AzCopy from a high-bandwidth migration VM (or locally if bandwidth permits):
```bash
azcopy copy "https://s3.amazonaws.com/[my-bucket]/" "https://[mystorageaccount].blob.core.windows.net/[container]?[sas-token]" --recursive=true
```

### Step 2: Verification
- Compare file counts and total sizes between the S3 bucket and the Blob container.
- Use `azcopy jobs show [job-id]` to verify that all transfers were successful.

### Step 3: Final Sync (Delta Copy)
Immediately prior to the application cutover, run a final sync to capture any files uploaded during the bulk migration phase:
```bash
azcopy sync "https://s3.amazonaws.com/[my-bucket]/" "https://[mystorageaccount].blob.core.windows.net/[container]?[sas-token]"
```
*Note: The `sync` command is more efficient than `copy` as it only transfers new or modified files.*

## 5. Application Code Updates
The .NET Backend API must be updated to use the `Azure.Storage.Blobs` NuGet package instead of `AWSSDK.S3`. 

**Key Code Changes:**
- Replace `AmazonS3Client` with `BlobServiceClient`.
- Replace `PutObjectRequest` with `UploadAsync`.
- Replace `GetPreSignedURL` with `GenerateSasUri`.

## 6. Optimization Tips
- **Parallelism:** Use the `AZCOPY_CONCURRENCY_VALUE` environment variable to increase throughput if migrating over a high-speed connection (e.g., ExpressRoute).
- **Blob Tiers:** If the data includes legacy logs or archives, consider migrating them directly to the **Azure Blob Archive Tier** to save costs.