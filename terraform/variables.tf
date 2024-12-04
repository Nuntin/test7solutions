variable "project_id" {
  type        = string
}

variable "project_name" {
  type        = string
  default     = "myproject"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
