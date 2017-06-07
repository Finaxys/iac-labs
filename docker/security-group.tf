resource "azurerm_network_security_group" "dockersg" {
    name = "swarmnsg"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    
    security_rule {
        name = "dockersri"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    
    security_rule {
        name = "dockersro"
        priority = 100
        direction = "Outbound"
        access = "Allow"
        protocol = "*"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    
    tags {
        environment = "${var.environment}"
    }
}