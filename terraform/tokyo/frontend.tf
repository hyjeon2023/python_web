resource "aws_instance" "frontend" {
    ami                         = "ami-0aec5ae807cea9ce0"  # 동일 AMI
    instance_type               = "t3.micro"               # 동일 사양
    private_ip                  = "10.0.1.10"              # 고정 Private IP
    key_name                    = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids      = [aws_security_group.hy_frontend_sg.id, aws_security_group.hy_internal_ssh_sg.id]
    subnet_id                   = aws_subnet.hy_subnet.id  # Public subnet

    # Frontend: Nginx reverse proxy -> Backend 9000
    user_data = <<-EOF
                  #!/bin/bash
                  apt-get update
                  apt-get install -y nginx

                  cat > /etc/nginx/sites-available/default << 'NGINX_CONF'
                  server {
                      listen 80 default_server;
                      listen [::]:80 default_server;

                      # 프런트엔드 / 요청을 백엔드 /health 로 프록시
                      location / {
                          proxy_pass http://${aws_instance.backend.private_ip}:9000/health;
                          proxy_set_header Host $host;
                          proxy_set_header X-Real-IP $remote_addr;
                          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                          proxy_set_header X-Forwarded-Proto $scheme;
                      }
                  }
                  NGINX_CONF

                  systemctl enable nginx
                  systemctl restart nginx
                  EOF

    tags = {
        Name    = "hy_frontend"
        Service = "frontend"
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

# Elastic IP for Frontend
resource "aws_eip" "hy_frontend_eip" {
    domain = "vpc"

    tags = {
        Name = "hy_frontend-eip"
    }
}

# Associate EIP with Frontend instance
resource "aws_eip_association" "hy_frontend_eip_assoc" {
    instance_id   = aws_instance.frontend.id
    allocation_id = aws_eip.hy_frontend_eip.id
}

