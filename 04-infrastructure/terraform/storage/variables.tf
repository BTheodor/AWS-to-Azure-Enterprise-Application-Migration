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

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default = {
    Project     = "AWS-to-Azure-Migration"
    Component   = "Storage"
    Environment = "prod"
  }
}