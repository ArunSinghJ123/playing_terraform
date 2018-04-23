
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_security_group" "elb" {
  name        = "arun_test_elb"
  description = "Used in the terraform"
  vpc_id      = "${var.aws_vpc}"

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

resource "aws_elb" "web" {
  name = "arun-example-elb"

  subnets         = ["${var.aws_subnet}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


resource "aws_instance" "web" {
  connection {
    user = "ec2-user"
    type = "ssh"
    private_key = "${file("/Users/path/to/pem file")}"
    host = "${self.public_ip}"
  }

  associate_public_ip_address = true

  instance_type = "t2.micro"

  ami = "${lookup(var.aws_ami, var.aws_region)}"

  key_name = "${var.key_name}"

  vpc_security_group_ids = ["${var.aws_security_group}"]

  subnet_id = "${var.aws_subnet}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install nginx",
      "sudo service nginx start",
    ]
  }
}
