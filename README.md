### Create a basic VPC with terraform

We will be creating a basic AWS VPC resources including the following:

* VPC 
* Subnets (one public and two privates)
* Routes 
* Route tables 
* Elastic IP (EIP)
* NAT Gateway 
* Route table association


## Requirement
- Terraform (https://www.terraform.io/downloads.html)
- Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variable in your local environment



## Deployment steps
1. cd to dev/vpc or prod/vpc
2. Modify module input variables and provider varables
3. Run `terraform init` to initialize things
4. Run `terraform plan` and confirm changes
5. Run `terraform apply`