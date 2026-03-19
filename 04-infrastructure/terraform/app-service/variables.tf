variable "project_name" {
  description = "Project name"
  type        = string
  default     = "global-finance"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_subnet_id" {
  description = "ID of the subnet for App Service Regional VNet Integration"
  type        = string
}

variable "db_connection_string" {
  description = "SQL Database connection string"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Project     = "AWS-to-Azure-Migration"
    Component   = "Compute"
    Environment = "prod"
  }
}