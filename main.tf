provider "aws"{
    region = "ca-central-1"

}

/*variable "subnet_cidr_block" {
    description = "subnet cidr block"
}*/

variable "cidr_blocks" {
  description = "cidr blocks and name tags for vpc and subnets"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

variable "environment" {
  description = "deployment environment"
}

resource "aws_vpc" "development-vpc"{
    cidr_block = var.cidr_blocks[0].cidr_block
    tags = {
      name: var.cidr_blocks[0].name
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "ca-central-1a"
    tags = {
      name: var.cidr_blocks[1].name
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = "ca-central-1a"
}
 output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
 }

  output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
 }