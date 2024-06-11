variable "cluster_name" {
  type = string 
  default = "iw-aks-cluster"
}
variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "environment" {
  type    = string
  default = "SANDPIT"
}