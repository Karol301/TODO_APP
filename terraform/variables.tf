variable "project_name" {
  description = "Nazwa projektu używana do tagowania i nazw zasobów"
  type        = string
  default     = "todo"
}

variable "cluster_name" {
  description = "Nazwa klastra EKS"
  type        = string
  default     = "todo-eks"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}