resource "azurerm_virtual_machine" "master" {
    name = "dockermaster"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.dockerrm.name}"
    network_interface_ids = ["${azurerm_network_interface.dockerni.id}"]
    vm_size = "Standard_A0"
    
    storage_image_reference {
        publisher = "docker"
        offer = "docker-ee"
        sku = "docker-ee"
        version = "latest"
    }
    
    storage_os_disk {
        name = "osdisk"
        vhd_uri = "${azurerm_storage_account.finaxsa.primary_blob_endpoint}${azurerm_storage_container.finaxsc.name}/osdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }
    
    os_profile {
        computer_name = "dockermaster"
        admin_username = "ubuntu"
        admin_password = "Password1234!"
    }
    
    os_profile_linux_config {
        disable_password_authentication = false
        ssh_keys {
            path = "/home/ubuntu/.ssh/authorized_keys"
            key_data = "${file("${path.module}/laurentgrangeau.pub")}"
        }
    }

    plan {
        name = "docker-ee"
        publisher = "docker"
        product = "docker-ee"
    }

    tags {
        environment = "${var.environment}"
    }
}