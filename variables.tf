
# Variables file implemented terraform workspaces using maps

variable "workspace_to_environment_map" {
  type = map
  default = {
    sbx = ""
    dev = "dev"
    qa  = "qa"
    prd = "prd"
  }
}

#copy vpc id into place holders.
variable "vpc_map" {
  type = map
  default = {
    sbx = ""
    dev = ""
    qa  = ""
    prd = ""
  }
}

#Private subnet id1 to be used for AD creation 
variable "private_subnet1_map" {
  type = map
  default = {
    sbx = ""
    dev = ""
    qa  = ""
    prd = ""
  }
}

#Private subnet id1 to be used for AD creation 
variable "private_subnet2_map" {
  type = map
  default = {
    sbx = ""
    dev = ""
    qa  = ""
    prd = ""
  }
}

#your company domain name , ex : lineofbusiness-dev.company.net
variable "dns_name_map" {
  type = map
  default = {
    sbx = ""
    dev = "yourdomain name"
    qa  = "yourdomain name"
    prd = "yourdomain name"
  }
}
#dns short name, example lineofbusiness ( taken from the above domain name)
# this short name is used while you login to your Active directory, ex : lineofbusiness\Admin
variable "dns_short_name_map" {
  type = map
  default = {
    sbx = ""
    dev = ""
    qa  = ""
    prd = ""
  }
}

#learn work terraform workspaces here - https://www.terraform.io/docs/state/workspaces.html
# command to initilize environment specific workspace ( dev, qa, prd)
# each env will have a separate backend file
# terraform init -backend-config=backends/dev-env.tf
# then init follow the below commands
# terraform workspace new "dev"
# terraform plan
# terraform apply
locals {
  workspace_env = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  #convert to uppercase 
  environment     = "${upper(local.workspace_env)}"
  vpc_id          = "${var.vpc_map[local.workspace_env]}"
  private_subnet1 = "${var.private_subnet1_map[local.workspace_env]}"
  private_subnet2 = "${var.private_subnet2_map[local.workspace_env]}"
  dns_name        = "${var.dns_name_map[local.workspace_env]}"
  dns_short_name  = "${var.dns_short_name_map[local.workspace_env]}"

  #EC2 specific
  sg_cidr_ingress   = "${var.sg_cidr_ingress_map[local.workspace_env]}"
  sg_cidr_egress    = "${var.sg_cidr_egress_map[local.workspace_env]}"
  tag_prefix        = "${var.tag_prefix_map[local.workspace_env]}"
  ec2_instance_type = "${var.ec2_instance_type_map[local.workspace_env]}"
  ami_id            = "${var.ami_map[local.workspace_env]}"
  ec2_key_pair_name = "${var.ec2_key_pair_map[local.workspace_env]}"
  az_zone           = "${var.az_map[local.workspace_env]}"
}


#Below variables are specific to create ec2 instane and domain join
variable "az_map" {
  description = "A map from environment to a list of availability zones"
  type        = map
  default = {
    sbx = ""
    dev = "us-east-1"
    qa  = ""
    prd = ""
  }
}
variable "ec2_instance_type_map" {
  description = "A map from environment to a list of EC2 instance types"
  type        = map
  default = {
    sbx = ""
    dev = "t2.small"
    qa  = ""
    prd = "t2.medium"
  }
}

#create EC2 key ahead / or use an existing one, use the name as value
variable "ec2_key_pair_map" {
  description = "A map from environment to a list of key pairs"
  type        = map
  default = {
    sbx = ""
    dev = ""
    qa  = ""
    prd = ""
  }
}

#Amazon AMI's fow windows instances. use AMI id's
variable "ami_map" {
  description = "A map from environment to a list of AMI IDs"
  type        = map
  default = {
    sbx = ""
    dev = "ami-0e0564dc8e882f217"
    qa  = ""
    prd = ""
  }
}

#CIDR blocks for EC2 security groups, dont use 0.0.0.0/0 
variable "sg_cidr_ingress_map" {
  description = "A map from environment to a list of CIDR blocks"
  type        = map
  default = {
    sbx = ""
    dev = "0.0.0.0/0"
    qa  = ""
    prd = "0.0.0.0/0"
  }
}

variable "sg_cidr_egress_map" {
  description = "A map from environment to a list of CIDR blocks"
  type        = map
  default = {
    sbx = ""
    dev = "0.0.0.0/0"
    qa  = ""
    prd = "0.0.0.0/0"
  }
}

#app specific tag prefix , ex : DEN
#Account specific prefix (3-4 letter ) to be used for tagging purpose
#Example :  ACCOUNTING, LIFE, FINANCE, TRANSPORTATION , Etc 
variable "tag_prefix_map" {
  description = "A map from environment to a list of values for Tag prefix tag"
  type        = map
  default = {
    sbx = ""
    dev = "FIN"
    qa  = "FIN"
    prd = "FIN"
  }
}
