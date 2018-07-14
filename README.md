# terraform-ec2-single-node
Sample terraform scripts to launch a single ec2 node under an ASG in a subnet. 

## Pre-requisties
* Terraform
* AWS Account - accesskey and Secretkey
* VPC  and a Subnet
* Securitygroups
* Keypair
* SNS topic to send AutoScaling notifications


## Input varibales
Please specify all the variables as per variables.tf. Either you can hard code them in variables.tf or you can specify while running terraform commands

## Steps to run after checkout
```
terraform init

terraform plan

terraform apply

```

### For destroying the stack
```
terraform destroy

```
