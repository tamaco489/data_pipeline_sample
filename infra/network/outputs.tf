output "vpc" {
  value = {
    arn               = aws_vpc.main.arn
    id                = aws_vpc.main.id
    cidr_block        = aws_vpc.main.cidr_block
    public_subnet_ids = [for s in aws_subnet.public_subnet : s.id]
    # private_subnet_ids = [for s in aws_subnet.private_subnet : s.id]
  }
}
