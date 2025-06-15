resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.public_subnet
  cidr_block              = each.value["cidr"]
  availability_zone       = "${var.region}${each.value["az"]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-${var.project}-public-subnet-${each.value["az"]}"
    AZ   = "${each.value["az"]}"
  }
}

# resource "aws_subnet" "private_subnet" {
#   vpc_id                  = aws_vpc.main.id
#   for_each                = var.private_subnet
#   cidr_block              = each.value["cidr"]
#   availability_zone       = "${var.region}${each.value["az"]}"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "${var.env}-${var.project}-private-subnet-${each.value["az"]}"
#     AZ   = "${each.value["az"]}"
#   }
# }
