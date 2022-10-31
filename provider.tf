terraform {
  cloud {
    organization = "friends_of_fate_903"

    workspaces {
      name = "scaling-succotash"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}




provider "aws" {
  region = "us-east-1"
}
