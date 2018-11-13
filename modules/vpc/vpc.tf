## Create a VPC

resource "aws_vpc" "main" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags {
        Name = "${var.name_prefix} vpc"
    }
}

/*
  Create VPC public subnet
*/
resource "aws_subnet" "public_subnet_eu_west_1a" {
    vpc_id = "${aws_vpc.main.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.public_subnet_az}"

    tags {
        Name = "${var.name_prefix} public subnet az ${var.public_subnet_az}"
    }
}

/*
  Create VPC private subnets
*/
resource "aws_subnet" "private_1_subnet_eu_west_1a" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.private_1_subnet_cidr}"
    availability_zone = "${var.private_subnet_az_1}"

    tags {
        Name = "${var.name_prefix} Subnet private 1 az ${var.private_subnet_az_1}"
    }
}

resource "aws_subnet" "private_2_subnet_eu_west_1b" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.private_2_subnet_cidr}"
    availability_zone = "${var.private_subnet_az_2}"

    tags {
        Name = "${var.name_prefix} Subnet private 1 az ${var.private_subnet_az_2}"
    }
}


/*
  Create Internet Gateway
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
        Name = "${var.name_prefix} Internet Gateway"
    }
}


/*
  Create route to the internet 
*/

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}


/*
Create Elastic IP (EIP)
The IP to assign it the NAT Gateway
*/

resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.igw"] 
  // Conditional variable which say in this case the EIP resource should be created after the Internet Gateway is already created
}


/*
Create NAT Gateway
Make sure to create the nat in a internet-facing subnet (public subnet)
*/

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public_subnet_eu_west_1a.id}"
    depends_on = ["aws_internet_gateway.igw"]
}



/*
Create private route table and the route to the internet 
This will allow all traffics from the private subnets to the internet through the NAT Gateway (Network Address Translation) 
*/


resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "${var.name_prefix} Private route table"
    }
}

resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


/*
Create Route Table Associations 
we will now associate our subnets to the different route tables 
*/

# Associate subnet public_subnet_eu_west_1a to public route table
resource "aws_route_table_association" "public_subnet_eu_west_1a_association" {
    subnet_id = "${aws_subnet.public_subnet_eu_west_1a.id}"
    route_table_id = "${aws_vpc.main.main_route_table_id}"
}

# Associate subnet private_1_subnet_eu_west_1a to private route table
resource "aws_route_table_association" "private_1_subnet_eu_west_1a_association" {
    subnet_id = "${aws_subnet.private_1_subnet_eu_west_1a.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

# Associate subnet private_2_subnet_eu_west_1b to private route table
resource "aws_route_table_association" "private_2_subnet_eu_west_1b_association" {
    subnet_id = "${aws_subnet.private_2_subnet_eu_west_1b.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}





/*
  NAT Instance
resource "aws_instance" "nat" {
    ami = "ami-30913f47" # this is a special ami preconfigured to do NAT
    availability_zone = "eu-west-1a"
    instance_type = "t2.micro"
    key_name = "${var.name_prefix} nat"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.eu-west-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags {
        Name = "NAT instance"
    }
}
*/



// resource "aws_vpc_dhcp_options" "dns_resolver" {
//     domain_name_servers = ["AmazonProvidedDNS"]

//     tags {
//         Name = "${var.name_prefix}-service"
//     }
// }

// resource "aws_vpc_dhcp_options_association" "a" {
//     vpc_id = "${aws_vpc.main.id}"
//     dhcp_options_id = "${aws_vpc_dhcp_options.dns_resolver.id}"
// }

/* For better availability, we will create our VPC in 2 different availability zones */
// resource "aws_subnet" "subnet" {
//     count = 2
//     vpc_id = "${aws_vpc.main.id}"
//     cidr_block = "10.0.${count.index}.0/24"
//     map_public_ip_on_launch = true
//     availability_zone = "${var.aws_region}${element(split(",", var.subnet_azs), count.index)}"

//     tags {
//         Name = "${var.name_prefix}-service"
//     }
// }




# Add a domain name, so that as infra changes, and if you rebuild the ALB, 
# the name of the application doesn't vary.
# Route53 will adjust as terraform changes are applied.

// resource "aws_route53_zone" "main" {
//   name = "abahet.com"
// }

// resource "aws_route53_record" "www-record" {
//     zone_id = "${aws_route53_zone.main.zone_id}"
//     name = "www.abahet.com"
//     type = "A"
//     ttl = "300"
// }

// resource "aws_route53_record" "myapp" {
//     zone_id = "${aws_route53_zone.main.zone_id}"
//     name = "myapp.abahet.com"
//     type = "CNAME"
//     ttl = "60"
// }


// output "ns-servers" {
//     value = "${aws_route53_zone.main.name_servers}"
// }