variable "region" {
	default = "eu-west-1"
}

variable "subnets_cidr" {
	type    = list
	default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "azs" {
	type    = list
	default = ["eu-west-1a", "eu-west-1b"]
}

variable "aws_region" {
	default = "eu-west-1"
}

variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "webservers_ami" {
  default = "ami-0f89681a05a3a9de7"
}

variable "instance_type" {
  default = "t2.micro"
}