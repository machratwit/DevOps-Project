variable "aws_region" { 
    default = "us-east-1" 
}

variable "instance_type" { 
    description = "EC2 Instance type"
    type = string
    default = "t2.micro" 
}

variable "ami" {
    description = "Amazon Machine Image to use for EC2 instance"
    type = string
    default = "ami-0360c520857e3138f"
}

variable "key_name" { 
    description = "EC2 key pair name for SSH" 
    type = string
}