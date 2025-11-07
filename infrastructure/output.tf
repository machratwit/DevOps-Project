output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
  sensitive   = true
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app_server.public_dns
  sensitive   = true
}

output "ecr_repository_url" {
  description = "URL of the ECR repository to push Docker images"
  value       = aws_ecr_repository.app.repository_url
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the security group used by the instance"
  value       = aws_security_group.ec2_sg.id
  sensitive   = true
}
