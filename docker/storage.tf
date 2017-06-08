resource "azurerm_storage_account" "finaxsa" {
    name = "finaxsa"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    location = "${var.location}"
    account_type = "Standard_LRS"
    
    tags {
        environment = "${var.environment}"
    }
}

resource "azurerm_storage_container" "finaxsc" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    storage_account_name = "${azurerm_storage_account.finaxsa.name}"
    container_access_type = "private"
}