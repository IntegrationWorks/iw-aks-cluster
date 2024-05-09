variable "cluster_name" { type = string }
variable "cluster_version" {
  type    = string
  default = "1.29"
}
variable "vpc_id" {
  type    = string
  default = "vpc-0b117481408397d7a"
}
variable "environment" {
  type    = string
  default = "SANDPIT"
}
variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-04ce63a3d7b11f082", "subnet-0d85a0f1acb66cf69", "subnet-0995e9fe63aad9798"]
}
variable "default_ami_type" {
  type    = string
  default = "AL2_x86_64"
}
variable "default_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}
variable "cluster_read_only_arn" {
  type = string
}
variable "cluster_admin_arn" {
  type = string
}
variable "deployment_automation_arn" {
  type = string
}
variable "vnet_subnet_id" {
  type    = string
  default = ""
}