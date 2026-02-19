# terraform/variables.tf

variable "region" {
  description = "AWS region"
  type        = string  
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "learn-eks"
}

variable "admin_users" {
  type        = list(string)
  description = "List of IAM user ARNs to grant admin access to the EKS cluster"
  default     = []
}

variable "desired_nodes" {
  type        = int
  description = "The number of desired node to run in the cluster"
  default     = 2
}

