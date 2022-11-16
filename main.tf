provider "aws" {
  access_key = "AKIAVO4MBEHOZJO6FMPN"
  secret_key = "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"
  region     = "us-west-1"
}



resource "aws_vpc" "domain" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "domain_subnet" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-1a"
}
resource "aws_subnet" "domain_pu_subnet" {
  vpc_id            = aws_vpc.domain.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-1b"
}
resource "aws_internet_gateway" "domain_iwg" {
  vpc_id = aws_vpc.domain.id
}
resource "aws_eip" "domainip" {
  vpc = "true"
}
resource "aws_route_table" "domin_route" {
  vpc_id = aws_vpc.domain.id
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.domain_iwg.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.domain_iwg.id
  }
}
resource "aws_nat_gateway" "domain_nat" {
  allocation_id = aws_eip.domainip.id
  subnet_id     = aws_subnet.domain_subnet.id
}
resource "aws_route_table" "domin_route-private" {
  vpc_id = aws_vpc.domain.id
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.domain_iwg.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.domain_nat.id
  }
}
resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.domain_pu_subnet.id
  route_table_id = aws_route_table.domin_route.id
}
resource "aws_route_table_association" "private_route" {
  subnet_id      = aws_subnet.domain_subnet.id
  route_table_id = aws_route_table.domin_route-private.id
}
resource "aws_security_group" "es" {
  name        = "elasticsearch-var.domain"
  description = "Managed by Terraform"
  vpc_id      = aws_vpc.domain.id
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      aws_vpc.domain.cidr_block,
    ]
  }
}
resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = "chandra"
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type          = "m3.medium.search"
    instance_count         = "1"
    zone_awareness_enabled = "true"
  }
  ebs_options {
    ebs_enabled = "true"
    volume_size = "45"
    volume_type = "gp2"
  }
   node_to_node_encryption {
    enabled = true
  }
  vpc_options {
    subnet_ids = [
      aws_subnet.domain_subnet.id
    ]
    security_group_ids = [aws_security_group.es.id]

  }
 domain_endpoint_options {
    enforce_https = "true"
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:domain/*"
        }
    ]
}
CONFIG
  depends_on      = [aws_iam_service_linked_role.es]

}

