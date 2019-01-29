# CREATION OF APPLICATION GROUPS FOR ROUTE
resource "aws_security_group" "http" {
  count       = "${var.create_routable_app_sg ? 1 : 0}"
  name        = "Route-HTTPfromOut"
  description = "Allow all HTTP traffic"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }

  tags = {
    Name = "Route-HTTPfromOut"
  }
}

resource "aws_security_group" "app" {
  count       = "${var.create_routable_app_sg ? 1 : 0}"
  name        = "AppfromOut"
  description = "Allow all App traffic"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }

  tags = {
    Name = "Route-AppfromOut"
  }
}

resource "aws_security_group" "ssh" {
  count       = "${var.create_routable_app_sg ? 1 : 0}"
  name        = "SSHfromOut"
  description = "Allow all SSH traffic"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}", "${var.urvpc_cidr_block}", "${var.internal_private}"]
  }

  tags = {
    Name = "Route-SSHfromOut"
  }
}
