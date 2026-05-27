resource "aws_security_group" "web_sg" {

  name = "docker-web-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_server" {

  ami           = var.ami
  instance_type = var.instance_type

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash

              apt update -y
              apt install docker.io -y

              systemctl start docker
              systemctl enable docker

              docker pull harinath641/cloud-native-devops:v1

              docker run -d -p 80:80 harinath641/cloud-native-devops:v1

              EOF

  tags = {
    Name = "Cloud-Native-DevOps-Server"
  }
}