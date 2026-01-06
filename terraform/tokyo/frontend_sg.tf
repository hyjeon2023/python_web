resource "aws_security_group" "hy_frontend_sg" {
    name        = "hy_frontend_sg"
    description = "Security group for Frontend service (HTTP to Backend)"
    vpc_id      = aws_vpc.hy_vpc.id

    # HTTP from anywhere
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
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
        Name = "hy_frontend_sg"
    }
}

