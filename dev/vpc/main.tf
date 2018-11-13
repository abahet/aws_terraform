/* Region settings for AWS provider */
provider "aws" {
    region = "us-west-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "ahmed"
}

module "my_vpc" {
    source                  = "../../modules/vpc"
    name_prefix             = "abahet"
    aws_region              = "eu-west-1"
    vpc_cidr                = "10.0.0.0/16"
    public_subnet_cidr      = "10.0.1.0/24"
    public_subnet_az        = "eu-west-1a"
    private_1_subnet_cidr   = "10.0.2.0/24"
    private_subnet_az_1     = "eu-west-1a"
    private_2_subnet_cidr   = "10.0.3.0/24"
    private_subnet_az_2     = "eu-west-1b"
}