# Backend EC2 Instance
resource "aws_instance" "backend" {
    ami                    = "ami-0aec5ae807cea9ce0"  # Bastion과 동일한 AMI
    instance_type          = "t3.micro"                # Bastion과 동일한 인스턴스 타입
    associate_public_ip_address = false                # Private subnet이므로 false
    key_name               = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids = [aws_security_group.hy_backend_sg.id]
    subnet_id              = aws_subnet.hy_private_subnet.id
    private_ip             = "10.0.2.10"                 # 고정 Private IP (private subnet)


    tags = {
        Name = "hy_backend"
        Service = "backend-api"
    }

    lifecycle {
    prevent_destroy = true  # 실수 삭제 방지
    ignore_changes = [
      user_data,
      instance_type,
      subnet_id,
      key_name
      ]
    }
}

