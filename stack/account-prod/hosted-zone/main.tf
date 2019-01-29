# CREATION OF THE PRIVATE AND PUBLIC HZones
resource "aws_route53_zone" "public" {
  count = "${var.create_publiczone ? 1 : 0}"
  name = "${var.publichostedzone}"
}


resource "aws_route53_zone" "private" {
  count = "${var.create_privatezone ? 1 : 0}"
  name = "${var.privatehostedzone}"

  vpc {
    vpc_id = "${var.vpc_id}"
  }

  lifecycle {
    ignore_changes = ["vpc"]
  }

}

resource "aws_route53_zone_association" "unroute" {
  count = "${var.create_privatezone ? 1 : 0}"
  zone_id = "${aws_route53_zone.private.zone_id}"
  vpc_id  = "${var.urvpc_id}"
}
