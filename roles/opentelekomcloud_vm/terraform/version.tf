terraform {
  required_providers {
    opentelekomcloud = {
      source  = "opentelekomcloud/opentelekomcloud"
      version = ">=1.27.1"
    }
  }
}

provider "opentelekomcloud" {}
