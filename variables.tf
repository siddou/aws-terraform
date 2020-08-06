variable "region" {
  description = "This is the cloud hosting region where your app will be deployed."
  default     = "eu-west-1"
}

variable "prefix" {
  description = "This is the environment where your app is deployed. qa, prod, or dev"
}

variable "amis" {
  description = "This is the ami that will be used"
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "vpc_name" {
  description = "VPC Default Name"
  default     = ""
  type        = string
}

variable "vpc_igw" {
  description = "Internet GW Default Name"
  default     = ""
  type        = string
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  description = "assign_generated_ipv6_cidr_block"
  default     = "false"
}

variable "availability_zones_public" {
  default     = "eu-west-1a"
  type        = string
  description = "availability_zones_public"
}

variable "availability_zones_private" {
  default     = "eu-west-1b"
  type        = string
  description = "availability_zones_private"
}


variable "vpc_subnet_private" {
  description = "vpc_subnet_private"
  default     = ""
  type        = string
}

variable "vpc_subnet_public" {
  description = "vpc_subnet_public"
  default     = ""
  type        = string
}

variable "vpc_subnet_private_cidr" {
  description = "vpc_subnet_private_cidr"
  default     = ""
}

variable "vpc_subnet_public_cidr" {
  description = "vpc_subnet_public_cidr"
  default     = ""
}

variable "vpc_route_public" {
  description = "vpc_route_public"
  default     = ""
  type        = string
}

variable "vpc_destination_cidr_block" {
  description = "vpc_destination_cidr_block"
  default     = "0.0.0.0/0"
}

variable "instance_name1" {
  description = "instance_name1"
  default     = ""
  type        = string
}

variable "instance_name2" {
  description = "instance_name2"
  default     = ""
  type        = string
}

variable "vpc_security_group" {
  description = "vpc_security_group"
  default     = ""
  type        = string
}

variable "vpc_security_group2" {
  description = "vpc_security_group2"
  default     = ""
  type        = string
}


variable "key_name" {
  description = "key_name"
  default     = ""
  type        = string
}

variable "public_key" {
  description = "public_key"
  default     = ""
  type        = string
}