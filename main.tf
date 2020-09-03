provider "aws" {
  region  = var.region
}

#VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = var.vpc_assign_generated_ipv6_cidr_block
  tags = {
    Name = var.vpc_name
    Terraform = "True"
  }
}

#Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_subnet_public_cidr
  availability_zone = var.availability_zones_public
  map_public_ip_on_launch = "true"
  tags = {
    Name = var.vpc_subnet_public
    Terraform = "True"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_subnet_private_cidr
  availability_zone = var.availability_zones_private
  tags = {
    Name = var.vpc_subnet_private
    Terraform = "True"
  }
}


#Internet GW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.vpc_igw
    Terraform = "True"
  }
}

#Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.vpc_route_public
    Terraform = "True"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.vpc_destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#Security Group
resource "aws_security_group" "sg1" {
  name        = var.vpc_security_group
  description = var.vpc_security_group
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "True"
  }
}

resource "aws_security_group" "sg2" {
  name        = var.vpc_security_group2
  description = var.vpc_security_group2
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "All ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
    ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
    ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
    ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ "10.0.1.0/24" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "True"
  }
}

#KeyPair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

#EC2
#how to manage name??
resource "aws_instance" "WebServer01" {
  ami           = var.amis
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.id
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [ aws_security_group.sg1.id ]
  tags = {
    Terraform = "True"
  }
}

# resource "aws_ec2_tag" "example1" {
#   resource_id = aws_instance.example1.id
#   key         = "Name"
#   value       = "WebServer01"
# }

resource "aws_instance" "MyDBServer" {
  ami           = var.amis
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.id
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids = [ aws_security_group.sg2.id ]
  tags = {
    Terraform = "True"
  }
}

# resource "aws_ec2_tag" "example2" {
#   resource_id = aws_instance.example2.id
#   key         = "Name"
#   value       = "MyDBServer"
# }


#ASG
resource "aws_launch_configuration" "worker" {
  name_prefix = "worker-"

  image_id                    = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "${var.worker_instance_type}"
  security_groups             = ["${aws_security_group.worker.id}"]

  user_data = "${data.template_cloudinit_config.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker" {
  # Force a redeployment when launch configuration changes.
  # This will reset the desired capacity if it was changed due to
  # autoscaling events.
  name = "${aws_launch_configuration.worker.name}-asg"

  min_size             = 10
  desired_capacity     = 15
  max_size             = 25
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.worker.name}"
  vpc_zone_identifier  = ["${aws_subnet.public.*.id}"]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
}