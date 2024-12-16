variable "GCP_PROJECT_ID" {
  description = "The GCP project ID"
  type        = string
  default     = "sysdig-20240916"
}

variable "GCP_REGION" {
  description = "The GCP region"
  type        = string
  default     = "australia-southeast1"
}

variable "SYSDIG_SECURE_ENDPOINT_URL" {
  description = "The Sysdig Secure API endpoint URL"
  type        = string
  default     = "https://app.au1.sysdig.com"
}

variable "SYSDIG_SECURE_API_TOKEN" {
  description = "The Sysdig Secure API token"
  type        = string
}
