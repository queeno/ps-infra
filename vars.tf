variable "project_id" {
  description = "Project ID in GCP"
}

variable "region" {
  description = "Region in GCP"
  default = "europe-west4"
}

variable "terraform_state_bucket" {
  description = "The bucket name holding the terraform state"
}