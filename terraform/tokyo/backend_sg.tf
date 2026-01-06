# Backend Service Security Group
resource "aws_security_group" "hy_backend_sg" {
    name        = "hy_backend_sg"
    description = "Security group for Backend API service (port 9000)"
    vpc_id      = aws_vpc.hy_vpc.id

    # SSH 접근 (Bastion에서만 접근 가능)
    ingress {
        description     = "SSH from Bastion"
        from_port       = var.ssh-port
        to_port         = var.ssh-port
        protocol        = "tcp"
        security_groups = [aws_security_group.hy_bastion_sg.id]
    }

    # API Service Port 9000 (프런트엔드 SG에서만 접근 허용)
    ingress {
        description     = "API Service Port 9000 from Frontend SG"
        from_port       = var.backend-port
        to_port         = var.backend-port
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "hy_backend_sg"
    }
}

