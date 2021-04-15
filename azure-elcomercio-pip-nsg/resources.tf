# Creacion de IPs publicas
resource "azurerm_public_ip" "PIP-DRP-preapp02-1" {
    name                = "PIP-DRP-preapp02-1"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_public_ip" "PIP-DRP-preweb02" {
    name                = "PIP-DRP-preweb02"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_public_ip" "PIP-DRP-devapp01" {
    name                = "PIP-DRP-devapp01"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_public_ip" "PIP-DRP-PREWEB03" {
    name                = "PIP-DRP-PREWEB03"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_public_ip" "PIP-DRP-TFSProd" {
    name                = "PIP-DRP-TFSProd"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_public_ip" "PIP-DRP-fsazure" {
    name                = "PIP-DRP-fsazure"
    location            = "${var.AZURE_LOCATION}"
    resource_group_name = "${var.AZURE_RG}"
    allocation_method   = "Static"
    tags {
      comments = "Created by Terraform"
    }
}

# Creacion de Network Security Group
resource "azurerm_network_security_group" "DRP-fsazure" {
  name                = "DRP-fsazure"
  location            = "${var.AZURE_LOCATION}"
  resource_group_name = "${var.AZURE_RG}"
    tags {
      comments = "Created by Terraform"
    }
}

resource "azurerm_network_security_rule" "SR-HTTPS-01" {
  name = "HTTPS-01"
  priority = "100"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "200.4.199.12/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-02" {
  name = "HTTPS-02"
  priority = "110"
  direction = "Inbound"
  access = "Allow"
  protocol = "TCP"
  source_port_ranges = ["443","80"]
  source_address_prefix = "190.8.135.30/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-03" {
  name = "HTTPS-03"
  priority = "120"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "201.234.125.253/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-04" {
  name = "HTTPS-04"
  priority = "130"
  direction = "Inbound"
  access = "Allow"
  protocol = "TCP"
  source_port_ranges = ["443","80"]
  source_address_prefix = "201.234.62.62/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-05" {
  name = "HTTPS-05"
  priority = "140"
  direction = "Inbound"
  access = "Allow"
  protocol = "TCP"
  source_port_ranges = ["443","80"]
  source_address_prefix = "200.48.88.221/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-06" {
  name = "HTTPS-06"
  priority = "150"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "201.234.125.245/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-07" {
  name = "HTTPS-07"
  priority = "160"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "179.7.219.219/32"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-08" {
  name = "HTTPS-08"
  priority = "170"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "200.4.199.0/24"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-09" {
  name = "HTTPS-09"
  priority = "180"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "201.234.125.224/27"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-10" {
  name = "HTTPS-10"
  priority = "190"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "200.48.88.192/27"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-HTTPS-11" {
  name = "HTTPS-11"
  priority = "200"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_ranges = ["443","80"]
  source_address_prefix = "201.234.62.32/27"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-PowerShell" {
  name = "PowerShell"
  priority = "210"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "5986"
  source_address_prefix = "*"
  destination_port_range = "5986"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-RDP-01" {
  name = "RDP-01"
  priority = "220"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "3389"
  source_address_prefix = "*"
  destination_port_range = "3389"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-RDp-02" {
  name = "RDp-02"
  priority = "230"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "65458"
  source_address_prefix = "*"
  destination_port_range = "65458"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-REQ1" {
  name = "REQ1"
  priority = "240"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "5030"
  source_address_prefix = "*"
  destination_port_range = "5030"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-AnyToAny-Temp" {
  name = "AnyToAny-Temp"
  priority = "100"
  direction = "Outbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_port_range = "*"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

resource "azurerm_network_security_rule" "SR-Port_443" {
  name = "Port_443"
  priority = "101"
  direction = "Inbound"
  access = "Allow"
  protocol = "*"
  source_port_range = "*"
  source_address_prefix = "*"
  destination_port_range = "443"
  destination_address_prefix = "*"
  resource_group_name = "${var.AZURE_RG}"
  network_security_group_name = "${azurerm_network_security_group.DRP-fsazure.name}"
}

