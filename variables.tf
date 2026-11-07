variable "my_ip" {
  description = "My public IP address for SSH access"
  type        = string
  sensitive   = true
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}