/* Security group */

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet_eu_west_1a_id" {
  value = "${aws_subnet.public_subnet_eu_west_1a.id}"
}

output "private_1_subnet_eu_west_1a_id" {
  value = "${aws_subnet.private_1_subnet_eu_west_1a.id}"
}

output "private_2_subnet_eu_west_1b_id" {
  value = "${aws_subnet.private_2_subnet_eu_west_1b.id}"
}