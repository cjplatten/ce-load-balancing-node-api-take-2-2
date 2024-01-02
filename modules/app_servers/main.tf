# Provision two EC2 instances. They should be t2.micro in size  √
# Use the previously created security group √
# Place that instance within the VPC that you created with Terraform 
# Be associated with the key pair you created earlier in the programme √
# Have the name app_server_001 and app_server_002 respectively √
# Use the Ubuntu Server 22.04 AMI ID (ami-0505148b3591e4c07) √
# Ensure the instance is given a public IP address √ 


resource "aws_instance" "ec2" {
  count                  = 2
  ami                    = "ami-0505148b3591e4c07"
  instance_type          = "t2.micro"
  key_name               = "ProjectKeyPair"
  vpc_security_group_ids = [var.security_group]
  associate_public_ip_address = true
  subnet_id = var.subnet_ids[0]

  tags = {
    Name = "app_server_00${count.index}"
  }
}
