provider "aws" {
  region = var.region
  shared_credentials_file = var.credential_file
  profile = "default"
}

resource "aws_security_group" "http-instance-ec2" {
name = "http-instance-ec2"
vpc_id = var.vpc_name
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 80
    to_port = 80
    protocol = "tcp"
  }


  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "http-alb" {
name = "http-alb"
vpc_id = var.vpc_name
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "nginx" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = ["http-instance-ec2"]
  user_data = <<-EOF
		          #!/bin/bash
              sudo apt update -y
		          sudo apt install nginx -y
		          sudo systemctl start nginx
		          sudo systemctl enable nginx
		          echo "<h1>nginx instance</  h1>" | sudo tee index.nginx-debian.html
              EOF
  tags = {
    Name = var.instance_name1
  }
}
 
resource "aws_instance" "apache" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = ["http-instance-ec2"]
  user_data = <<-EOF
		          #!/bin/bash
              sudo apt update -y
		          sudo apt install apache2 -y
		          sudo systemctl start apache2
		          sudo systemctl enable apache2
		          echo "<h1>apache instance</  h1>" | sudo tee /var/www/html/index.html
              EOF
  tags = {
    Name = var.instance_name2
  }
}

resource "aws_lb" "labjonas" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.http-alb.id}"]
  subnets            = var.subnets
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "labjonas" {
  name        = var.project_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_name
    health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = 80  
  }
}

resource "aws_lb_listener" "labjonas" {  
  load_balancer_arn = "${aws_lb.labjonas.arn}"
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.labjonas.arn}"
    type             = "forward"  
  }
}

resource "aws_lb_target_group_attachment" "labjonas-nginx" {
  target_group_arn = "${aws_lb_target_group.labjonas.arn}"
  target_id        =  "${aws_instance.nginx.id}"
  port             = 80
}
resource "aws_lb_target_group_attachment" "labjonas-apache" {
  target_group_arn = "${aws_lb_target_group.labjonas.arn}"
  target_id        =  "${aws_instance.apache.id}"
  port             = 80
}