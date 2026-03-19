variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "global-finance"
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_subnet_cidr" {
  description = "CIDR block for the App Service integration subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_endpoint_subnet_cidr" {
  description = "CIDR block for the Private Endpoints subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Standard tags for all resources"
  type        = map(string)
  default = {
    Project     = "AWS-to-Azure-Migration"
    ManagedBy   = "Terraform"
    Environment = "prod"
  }
}