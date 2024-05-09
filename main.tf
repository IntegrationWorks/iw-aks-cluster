resource "azurerm_resource_group" "resource_group" {
  name     = "adam-sandbox"
  location = "Australia East"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type       = var.default_ami_type
    instance_types = var.default_instance_types
  }

  eks_managed_node_groups = {
    default_node_group = {
      min_size      = 1
      max_size      = 10
      desired_size  = 1
      disk_size     = 50
      capacity_type = "SPOT"

      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        CloudWatchAgentServerPolicy        = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }

      pre_bootstrap_user_data = <<-EOT
        sudo yum install amazon-ssm-agent -y
        sudo systemctl enable amazon-ssm-agent
        sudo systemctl start amazon-ssm-agent
        sudo yum install amazon-cloudwatch-agent -y
        sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudwatch-linux
      EOT
    }
  }

  access_entries = {
    read_only_access_group = {
      kubernetes_groups = []
      principal_arn     = var.cluster_read_only_arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    admin_access_group = {
      kubernetes_groups = []
      principal_arn     = var.cluster_admin_arn

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    deployment_user_access = {
      kubernetes_groups = []
      principal_arn     = var.deployment_automation_arn
      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment = var.environment
  }
}


module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 8.0.0"

  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location

  cluster_name    = var.cluster_name
  kubernetes_version = var.cluster_version

  # Resources
  agents_pool_name = "default"
  agents_count = 1
  agents_min_count = 1
  agents_max_count = 10
  agents_size = "Standard_A2_v2"

  os_disk_size_gb = 50
  os_disk_type = "Ephemeral"

  vnet_subnet_id = var.vnet_subnet_id

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_resource_group" "aks" {
  name     = "myAKSResourceGroup"
  location = "East US"
}
