terraform {
  required_version = ">= 1.14.8"

  required_providers {
    cloudstack = {
      source  = "cloudstack/cloudstack"
      version = "0.5.0"
    }
  }
}
