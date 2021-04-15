resource "aws_vpc_peering_connection" "peering_pri" {
  vpc_id      = var.vpc_id     # vpc from primary site
  peer_vpc_id = var.vpc_id_sec # vpc from secondary site
  peer_region = "us-east-2"
  auto_accept = false
  tags        = var.tags
}

resource "aws_vpc_peering_connection_accepter" "peering_acepter_sec" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_pri.id
  auto_accept               = true
  tags                      = var.tags
}
data "aws_route_table" "selected_pri" {
  subnet_id = var.subnet_ids[0]
}

data "aws_route_table" "selected_sec" {
  provider  = aws.secondary
  subnet_id = var.subnet_ids_sec[0]
}

resource "aws_route" "route_to_sec" {
  route_table_id            = data.aws_route_table.selected_pri.id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_pri.id
}

resource "aws_route" "route_to_pri" {
  provider                  = aws.secondary
  route_table_id            = data.aws_route_table.selected_sec.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_pri.id
}
