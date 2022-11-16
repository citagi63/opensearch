variable "name" {
  description = "The name of the Opensearch domain"
  type        = string 
}


variable "instance_count" {
    description = "Enter number of instace"
    type        =  string
}

variable "ebs_enbled"{
    description = "Enter ebs requied or not"
    type        = bool
}

variable "volume_size" {
    description = "Mention how much volume needed"
    type        = string
}

variable "volume_type" {
    description = "Enter which type of volume needed"
    type        = string
    default     = "gp2"
}
variable "enforce_https" {
    description = "Whether or not to require HTTPS."
    type        = bool
}
 variable "tls_security_policy" {
    description = "Name of the TLS security policy that needs to be applied to the HTTPS endpoint."
    type        = string
    default     =  "Policy-Min-TLS-1-0-2019-07"
 }
 variable "master_user_name" {
  description = "Name of the master user within this Opensearch cluster."
  type        = string
  default     = "root"
}
variable "kms_key_id" {
  description = "The key to use to encrypt the cluster."
  type        = string
}
variable "internal_user_database_enabled" {
  description = "Whether the internal user database is enabled."
  type        = bool

}
variable "include_numbers" {
  description = "Whether or not to include numbers in the password."
  type        = bool
  default     = true
}
variable "encrypt_at_rest" {
  description = "Whether or not to enforce encryption at rest. Only available for certain instance types."
  type        = bool
  default     = true
}
variable "dedicated_master_enabled" {
  description = "Whether dedicated main nodes are enabled for the cluster."
  type        = bool
}
variable "dedicated_master_enabled" {
  description = "Whether dedicated main nodes are enabled for the cluster."
  type        = bool
}
variable "node_to_node_encryption" {
    type = bool
}
variable "vpc_id" {
    description = "The ID of the VPC to provision into."
    type        = string
}
variable "subnet_id" {
    description = "list of all subnets"
    type = string
}
variable "aws_vpc" {
    description = "Name of vpc"
    type        = string
    default     = "opensearch"
}
variable "cidr_block"{
    type        = string
    default     = "10.0.0.0/16"
}
variable "aws_subnet" {
    description = "Name the subnets"
    type        = string
    default     = "openserach"
}
variable "aws_internet_gateway" {
    description = "internet gateway name"
    type        = string
    default = "opensearch_igw"
}
variable "sub_cidr_block_public" {
    type        = string
    default     = "10.0.1.0/24"
}
variable "sub_cidr_block_private" {
    type        = string
    default     = "10.0.2.0/24"
}
variable "ingress_rule" {
    description "security rules"
    type = map(list(string))
     default     = {
    "description" = ["For HTTPs", "For SSH"]
    "from_port"   = ["443", "22"]
    "to_port"     = ["443", "22"]
    "protocol"    = ["tcp", "tcp"]
    "cidr_blocks" = ["0.0.0.0/0", "0.0.0.0/0"]
  }
}
