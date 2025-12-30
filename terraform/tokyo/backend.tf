# Backend EC2 Instance
resource "aws_instance" "backend" {
    ami                    = "ami-0aec5ae807cea9ce0"  # Bastion과 동일한 AMI
    instance_type          = "t3.micro"                # Bastion과 동일한 인스턴스 타입
    associate_public_ip_address = false                # Private subnet이므로 false
    key_name               = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids = [aws_security_group.hy_backend_sg.id]
    subnet_id              = aws_subnet.hy_private_subnet.id
    private_ip             = "10.0.2.10"                 # 고정 Private IP (private subnet)

    # Backend API 서비스 시작 스크립트
    user_data = <<-EOF
                  #!/bin/bash
                  # Update system
                  apt-get update
                  
                  # Install Python and pip
                  apt-get install -y python3 python3-pip
                  
                  # Create simple API service on port 9000
                  cat > /opt/backend_api.py << 'PYTHON_SCRIPT'
import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs

class APIHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"status": "healthy", "service": "backend-api"})
            self.wfile.write(response.encode())
        elif self.path == '/api/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"status": "running", "port": 9000})
            self.wfile.write(response.encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        response = json.dumps({"message": "Request received", "data": post_data.decode()})
        self.wfile.write(response.encode())

if __name__ == "__main__":
    PORT = 9000
    with socketserver.TCPServer(("", PORT), APIHandler) as httpd:
        print(f"Backend API server running on port {PORT}")
        httpd.serve_forever()
PYTHON_SCRIPT
                  
                  # Make script executable
                  chmod +x /opt/backend_api.py
                  
                  # Create systemd service
                  cat > /etc/systemd/system/backend-api.service << 'SERVICE_SCRIPT'
[Unit]
Description=Backend API Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 /opt/backend_api.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICE_SCRIPT
                  
                  # Enable and start service
                  systemctl daemon-reload
                  systemctl enable backend-api.service
                  systemctl start backend-api.service
                  EOF

    tags = {
        Name = "hy_backend"
        Service = "backend-api"
    }
}

