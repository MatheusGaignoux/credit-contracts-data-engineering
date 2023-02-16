terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

resource "aws_redshift_cluster" "etude_credit_contracts_redshift" {
  provider = aws.us-east-1
  cluster_identifier = var.redshift_args["cluster_identifier"]
  database_name      = var.redshift_args["database_name"]
  master_username    = var.redshift_args["master_username"]
  master_password    = var.redshift_args["master_password"]
  node_type          = var.redshift_args["node_type"]
  cluster_type       = var.redshift_args["cluster_type"]
  vpc_security_group_ids = ["${aws_security_group.etude_credit_contracts_securitygroup.id}"]
  tags = {
    Name = "etude_redshift"
  }
}

resource "aws_redshift_cluster_iam_roles" "etude_credit_contracts_redshift_iam_roles" {
  cluster_identifier = aws_redshift_cluster.etude_credit_contracts_redshift.cluster_identifier
  iam_role_arns = [aws_iam_role.allow_access_to_s3_from_redshift_role.arn]
}

resource "aws_s3_bucket" "etude_credit_contracts_s3" {
  bucket = "s3etudecreditcontracts"

  tags = {
    Name = "etude_s3"
  }
}

resource "aws_s3_bucket_acl" "etude_credit_contracts_s3_acl" {
  bucket = aws_s3_bucket.etude_credit_contracts_s3.id
  acl    = "private"
}
