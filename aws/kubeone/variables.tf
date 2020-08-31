/*
Copyright 2019 The KubeOne Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

variable "cluster_name" {
  description = "Name of the cluster"
}

variable "worker_os" {
  description = "OS to run on worker machines"

  # valid choices are:
  # * ubuntu
  # * centos
  # * coreos
  # * flatcar
  default = "ubuntu"
}

variable "ssh_public_key_file" {
  description = "SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
}

variable "ssh_username" {
  description = "SSH user, used only in output"
  default     = "ubuntu"
}

variable "ssh_private_key_file" {
  description = "SSH private key file used to access instances"
  default     = ""
}

variable "ssh_agent_socket" {
  description = "SSH Agent socket, default to grab from $SSH_AUTH_SOCK"
  default     = "env:SSH_AUTH_SOCK"
}

variable "bastion_port" {
  description = "Bastion SSH port"
  default     = 22
}

variable "bastion_user" {
  description = "Bastion SSH username"
  default     = "ubuntu"
}

# Provider specific settings

variable "aws_region" {
  default     = "eu-west-3"
  description = "AWS region to speak to"
}

variable "vpc_id" {
  default     = "default"
  description = "VPC to use ('default' for default VPC)"
}

variable "control_plane_type" {
  default     = "t3.medium"
  description = "AWS instance type"
}

variable "control_plane_volume_size" {
  default     = 100
  description = "Size of the EBS volume, in Gb"
}

variable "worker_type" {
  default     = "t3.medium"
  description = "instance type for workers"
}

variable "ami" {
  default     = ""
  description = "AMI ID, use it to fixate control-plane AMI in order to avoid force-recreation it at later times"
}

variable "subnets_cidr" {
  default     = 24
  description = "CIDR mask bits per subnet"
}

variable "internal_api_lb" {
  default     = false
  description = "make kubernetes API loadbalancer internal (reachible only from inside the VPC)"
}

variable "open_nodeports" {
  default     = false
  description = "open NodePorts flag"
}

variable "initial_machinedeployment_replicas" {
  default     = 1
  description = "number of replicas per MachineDeployment"
}

//DATABASE STANDALONE
variable "allocated_storage" {
  default     = 20
  description = "storage size for postgresql"
}
variable "storage_type" {
  default     = "gp2"
  description = "storage type for postgresql"
}
variable "engine" {
  default     = "postgresql"
  description = "engine"
}
variable "engine_version" {
  default     = "11.6"
  description = "postgresql version"
}
variable "instance_class" {
  default     = "db.t2.micro"
  description = "instance db class"
}
variable "db_name" {
  default     = "thingsboard"
  description = "db name"
}
variable "db_username" {
  default     = "tb-admin"
  description = "db user name"
}
variable "db_userpass" {
  default     = "tb-password"
  description = "db user password"
}
variable "parameter_group_name" {
  default     = "default.postgres11"
  description = "config parameter group name"
}

// DATABASE CLUSTER
//variable "cluster_allocated_storage" {
//  default     = 20
//  description = "storage size for postgresql"
//}
//variable "cluster_storage_type" {
//  default     = "gp2"
//  description = "storage type for postgresql"
//}
variable "cluster_engine" {
  default     = "aurora-postgresql"
  description = "engine"
}
variable "cluster_engine_version" {
  default     = "11.6"
  description = "postgresql version"
}
variable "db_cluster_name" {
  default     = "thingsboard"
  description = "db name"
}
variable "master_username" {
  default     = "tb-admin"
  description = "db user name"
}
variable "master_userpass" {
  default     = "tb-password"
  description = "db user password"
}
variable "cluster_identifier" {
  default     = "thingsboard"
  description = "database cluster identifier"
}
variable "backup_window" {
  default     = "07:00-09:00"
  description = "window for backup"
}
variable "period" {
  default     = "3"
  description = "number of backups. daily backup"
}