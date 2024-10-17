terraform {
    required_providers {
      aws ={
        source = "hashicorp/aws"
        version = "~> 5.6"
      }
    }

    backend "s3" {
        bucket = "demo-bucket-31"
        key = "expense-sg-dev"
        region = "us-east-1"
        dynamodb_table= "demo_key"        
    }
}

provider "aws" {
    region = "us-east-1"
}