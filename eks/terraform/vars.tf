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