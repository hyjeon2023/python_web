resource "aws_subnet" "hy_subnet" {
    vpc_id = aws_vpc.hy_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    map_public_ip_on_launch = true
    tags = {
        name = "hy_subnet"
    }
}