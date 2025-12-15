resource "aws_instance" "bastion" {
    
    ami = "ami-0aec5ae807cea9ce0"
    instance_type = "t3.micro"
    associate_public_ip_address = true
    key_name = aws_key_pair.bastion_key.key_name
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]
    subnet_id = aws_subnet.hy_subnet.id

    tags = {
        name = "hy_bastion"
    }
}

resource "aws_key_pair" "bastion_key" {
    key_name = "my_aws_key"
    public_key = file(pathexpand("~/.ssh/hykey.pub"))
}