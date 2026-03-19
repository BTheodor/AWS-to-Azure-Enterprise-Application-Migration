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

variable "vnet_id" {
  description = "ID of the existing VNet"
  type        = string
}

variable "pe_subnet_id" {
  description = "ID of the Private Endpoint subnet"
  type        = string
}

variable "sql_admin_login" {
  description = "SQL administrator login"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL administrator password (sensitive)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Project     = "AWS-to-Azure-Migration"
    Component   = "Database"
    Environment = "prod"
  }
}