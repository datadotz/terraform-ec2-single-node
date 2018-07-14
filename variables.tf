variable "aws_accessKey" {}
variable "aws_secretKey" {}
variable "aws_region" {
  description = "Default Region to launch it"
  default = "us-east-1"
}
variable "instance_type" {
  description = "Default Instance Type"
  default = "t2.small"
}
variable "instance_name" {
  default = "TestMachine"
}
variable "aws_image_id" {
  description = "Enter AMI to use"
  default = "ami-cfe4b2b0"
}
variable "iam_instance_profile" {
  description = "Enter Instance ROle for the Ec2 machine"
  default = ""
}

variable "security_group" {}
variable "availability_zones" {
  description = "Enter Availability Zones"
  default = "us-east-1a"
}

variable "subnets_id" {
  description = "Enter Subnet Ids"
}
variable "user_data" {
  description = "Enter file Name of the user data"
  default = "install.sh"
}
variable "sns_topic" {
  description = "Enter SNS Topic to recieve notifications"
}
variable "root_volume_size" {
  description = "Enter Root Volume Size in GB for EBS"
  default = "50"
}

variable "sampletag" {
  default = "Sample Tag"
}
variable "ebs_optimized" {
  description = "Enter True or false for optimized EBS"
  default = "false"
}
variable "aws_keypair_name" {
}
variable "asg_min_size" {
  default = "1"
}
variable "asg_desired_capacity" {
  default = "1"
}
variable "asg_max_size" {
  default = "1"
}
variable "instance_port" {
  default = "22"
}
variable "instance_protocol" {
  default = "TCP"
}
