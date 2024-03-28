#terraform block

terraform {
  required_version = "~>  1.7.5"
  
  #use official and verified providers
  required_providers {

    aws={
        source = "hashicorp/aws"
        #version = "~> 2.70.0"
        #version =  "~> 5.42.0"
        version = "~> 3.0"
    }
    
    
  }
}

#proivder block
provider "aws" {
  region="us-east-1"

  #profile="dev"
}

provider "kubernetes" {
  host = data.terraform_remote_state.eks.outputs.cluster_endpoint 
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.cluster.token
}
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


/*
terraform {
  required_providers {
    aws = {
      version = "~> 2.13.0"
    }
    random = {
      version = ">= 2.1.2"
    }
  }

  required_version = "~> 0.12.29"
}

*/
######remote state backend for eks cluster in s3 bucket#############



data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

