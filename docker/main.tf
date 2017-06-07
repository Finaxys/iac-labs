provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "dockerrm" {
    name = "dockerrm"
    location = "${var.location}"
}

resource "azurerm_virtual_network" "dockervn" {
    name = "dockervn"
    address_space = ["10.0.0.0/16"]
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
}

resource "azurerm_subnet" "dockersub" {
    name = "dockersub"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    virtual_network_name = "${azurerm_virtual_network.dockervn.name}"
    address_prefix = "10.0.0.0/24"
    network_security_group_id = "${azurerm_network_security_group.dockersg.id}"
}

resource "azurerm_network_interface" "swarmni" {
    name = "swarmni"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    network_security_group_id = "${azurerm_network_security_group.dockersg.id}"
    
    ip_configuration {
        name = "dockerconfig"
        subnet_id = "${azurerm_subnet.dockersub.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.dockerpip.id}"
    }
}

resource "azurerm_public_ip" "dockerpip" {
    name = "dockerpip"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    public_ip_address_allocation = "static"
    domain_name_label = "finaxlabs"
    
    tags {
        environment = "${var.environment}"
    }
}

resource "azurerm_storage_account" "dockersa" {
    name = "dockersa"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    location = "${var.location}"
    account_type = "Standard_LRS"
    
    tags {
        environment = "${var.environment}"
    }
}

resource "azurerm_storage_container" "dockersc" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    storage_account_name = "${azurerm_storage_account.dockersa.name}"
    container_access_type = "private"
}