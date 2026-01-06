# Backend Outputs
output "backend_instance_id" {
  description = "Backend EC2 Instance ID"
  value       = aws_instance.backend.id
}

output "backend_private_ip" {
  description = "Backend Private IP"
  value       = aws_instance.backend.private_ip
}

output "backend_api_url" {
  description = "Backend API URL (from Public Subnet)"
  value       = "http://${aws_instance.backend.private_ip}:9000"
}

output "public_subnet_cidr" {
  description = "Public Subnet CIDR (for API access)"
  value       = aws_subnet.hy_subnet.cidr_block
}

output "private_subnet_cidr" {
  description = "Private Subnet CIDR"
  value       = aws_subnet.hy_private_subnet.cidr_block
}

# Frontend Outputs
output "frontend_instance_id" {
  description = "Frontend EC2 Instance ID"
  value       = aws_instance.frontend.id
}

output "frontend_public_ip" {
  description = "Frontend Public IP"
  value       = aws_eip.hy_frontend_eip.public_ip
}

output "frontend_url" {
  description = "Frontend Service URL"
  value       = "http://${aws_instance.frontend.public_ip}"
}
