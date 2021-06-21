# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The name of the region, such as us-east-1, in which to launch the EC2 instance to create the AMI."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet, such as subnet-12345def, where Packer will launch the EC2 instance."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "iam_instance_profile" {
  description = "The name of an IAM instance profile to launch the EC2 instance with."
  type        = string
  default     = "packer-ec2"
}

variable "instance_type_amd64" {
  description = "The EC2 instance type to use while building the AMI for AMD64 architecture."
  type        = string
  default     = "t3.micro"
}

variable "instance_type_arm64" {
  description = "The EC2 instance type to use while building the AMI for ARM64 architecture."
  type        = string
  default     = "t4g.micro"
}

variable "regions_to_copy" {
  description = "A list of regions to copy the AMI to."
  type        = list(string)
  default     = []
}

variable "users_to_share" {
  description = "A list of AWS account IDs to share AMI with."
  type        = list(string)
  default     = []
}

variable "timezone" {
  description = "The system time zone the AMI is configured with."
  type        = string
  default     = "Asia/Shanghai"
}

variable "git_commit" {
  description = "The commit of the Git repository that AMIs are built with."
  type        = string
  default     = "N/A"
}
