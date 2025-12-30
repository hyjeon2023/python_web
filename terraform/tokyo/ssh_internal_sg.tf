resource "aws_security_group" "hy_internal_ssh_sg" {
  name        = "hy_internal_ssh_sg"
  description = "Allow SSH from Bastion to internal subnets"
  vpc_id      = aws_vpc.hy_vpc.id

  ingress {
    description     = "SSH from Bastion SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.hy_bastion_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hy_internal_ssh_sg"
  }
}

