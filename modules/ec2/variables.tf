variable "ami" {
  type = string
}

variable "name" {
  type = string
}

variable "instance_count" {
  type = number
  default = 1
}

variable "instance_type" {
  type = string
}

variable "monitoring" {
  type = bool
  default = false
}

variable "vpc_security_group_ids" {
  type = list(string)
  default = null
}

variable "subnet_id" {
  type = string
}

variable "use_num_suffix" {
  type = bool
  default = false
}
variable "root_block_device" {
  type = list(map(string))
  default = []
}

variable "ebs_block_device" {
  type = list(map(string))
  default = []
}

variable "tags" {
  type = map(string)
}

variable "iam_instance_profile" {
  type = string
  default = ""
}

variable "associate_public_ip_address" {
  type = bool
  default = false
}

variable "disable_api_termination" {
  type = bool
  default = false
}
variable "key_name" {
  type = string
}