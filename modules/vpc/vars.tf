/* Terraform constraints */
terraform {
    required_version = ">= 0.11, < 0.12"
}

variable "name_prefix" {
    default = "abahet"
    description = "Name prefix for this environment."
}

variable "aws_region" {
    default = "eu-west-1"
    description = "Determine AWS region endpoint to access."
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "public_subnet_az" {
    description = "Public subnet availability_zone"
    default = "eu-west-1a"
}

variable "private_1_subnet_cidr" {
    description = "CIDR for the Private Subnet 1"
    default = "10.0.2.0/24"
}

variable "private_subnet_az_1" {
    description = "Private Subnet 1 availability zone"
    default = "eu-west-1a"
}

variable "private_2_subnet_cidr" {
    description = "CIDR for the Private Subnet 2"
    default = "10.0.3.0/24"
}

variable "private_subnet_az_2" {
    description = "Private Subnet 2 availability zone"
    default = "eu-west-1b"
}