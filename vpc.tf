resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "wsi-vpc"
  }
}

// --- subnet
resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "wsi-subnet-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-subnet-public-b"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-subnet-private-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "wsi-subnet-private-b"
  }
}

// --- igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wsi-igw"
  }
}

// --- elastic ip
resource "aws_eip" "a" {
  
}

resource "aws_eip" "b" {

}

// --- ngw
resource "aws_nat_gateway" "private_a" {
  depends_on = [aws_internet_gateway.igw]

  allocation_id = aws_eip.a.id
  subnet_id = aws_subnet.public_a.id

  tags = {
    Name = "wsi-ngw-a"
  }
}

resource "aws_nat_gateway" "private_b" {
  allocation_id = aws_eip.b.id
  subnet_id = aws_subnet.public_b.id

  tags = {
    Name = "wsi-ngw-b"
  }
}

// --- route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wsi-rt-public"
  }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wsi-rt-private-a"
  }
}

resource "aws_route" "private_a" {
  route_table_id = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_a.id
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "wsi-rt-private-b"
  }
}

resource "aws_route" "private_b" {
  route_table_id = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.private_b.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}