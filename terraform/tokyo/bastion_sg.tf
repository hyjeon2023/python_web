resource "aws_security_group" "hy_bastion_sg" {
    name = "hy_bastion_sg"
    description = "hy bastion sg"
    vpc_id = aws_vpc.hy_vpc.id

    ingress {
        from_port = var.ssh-port
        to_port = var.ssh-port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = var.bastion-http-test-port
        to_port = var.bastion-http-test-port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}