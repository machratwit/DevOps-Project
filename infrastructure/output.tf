output "instance_public_ip" {
  description = "Public Elastic IP of the EC2 instance"
  value       = data.aws_eip.existing_eip.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance (resolves from EIP)"
  value       = data.aws_eip.existing_eip.public_dns
}

output "ecr_repository_url" {
  description = "URL of the ECR repository to push Docker images"
  value       = aws_ecr_repository.app.repository_url
}

output "security_group_id" {
  description = "ID of the security group used by the instance"
  value       = aws_security_group.ec2_sg.id
}
