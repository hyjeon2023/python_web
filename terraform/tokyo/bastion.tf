resource "aws_instance" "bastion" {
    
    ami = "ami-0aec5ae807cea9ce0"
    instance_type = "t3.micro"
    associate_public_ip_address = true  # Elastic IP 사용 시 false로 설정
    private_ip                  = "10.0.1.11"  # 고정 Private IP (public subnet)
    key_name = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids = [aws_security_group.hy_bastion_sg.id]
    subnet_id = aws_subnet.hy_subnet.id

    user_data = <<-EOF
                  #!/bin/bash
                  echo "Hello, World" > index.html
                  nohup busybox httpd -f -p 8080 &
                  EOF

    tags = {
        name = "hy_bastion"
    }

    lifecycle {
    prevent_destroy = true  # 실수 삭제 방지
    ignore_changes = [
      user_data,
      instance_type,
      subnet_id,
      vpc_security_group_ids,
      key_name
    ]
  }
}

# Elastic IP 생성 (고정 Public IP)
resource "aws_eip" "hy_bastion_eip" {
    domain = "vpc"  # VPC에서 사용하는 경우 "vpc"로 설정
    
    tags = {
        Name = "hy_bastion-elastic-ip"
    }
}

# Elastic IP를 EC2 인스턴스에 연결
resource "aws_eip_association" "hy_bastion_eip_assoc" {
    instance_id   = aws_instance.bastion.id
    allocation_id = aws_eip.hy_bastion_eip.id
}

resource "aws_key_pair" "bastion_key" {
    public_key = file(pathexpand("~/.ssh/hykey.pub"))
}