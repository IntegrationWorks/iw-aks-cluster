variable "cluster_name" {
  type    = string
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

variable "agents_pool_name" {
  type    = string
  default = "default"
}

variable "agents_count" {
  type    = string
  default = "1"
}

variable "agents_min_count" {
  type    = string
  default = "1"
}

variable "agents_max_count" {
  type    = string
  default = "10"
}

variable "agents_size" {
  type    = string
  default = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  type    = number
  default = 50
}

variable "os_disk_type" {
  type    = string
  default = "Ephemeral"
}