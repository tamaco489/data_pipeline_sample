resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = { Name = "${var.env}-${var.project}-internet-gw" }
}

# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat_gw.id
#   subnet_id     = aws_subnet.public_subnet["a"].id

#   tags = { Name = "${var.env}-${var.project}-nat-gw" }
# }
