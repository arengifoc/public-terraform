tags = {
  owner     = "angel-rengifo"
  tfproject = "azure-vms"
}
vm-linux-name = "vault"
public_sshkey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAymNMTOWQUIDm/LK0oIUQv0iTqUA/gwUWqWcA4CCu7PDa7vkAb3E2cGVwc3eBmTKT+v02rDU4fTqfhzGNzCPnCg7QIJqvQk+YsueaCLcUwww0zBQvBP0gJmhUSxT5aYyYgCPn0IH/OzhN5y3CpTfmODokjcKs5oWHruluIfyIrbcJC7rd+avJtD9HdGlHtVtz0cbQ3+clcpOAxIhK1LcXzoZKEBuG20lX1I27jSpVmXxzW3IEB0e1itPiaCMWeGyg+CwelKZIs3MsDTy3RPBqt1tWRZtHC4fR9G9s4/f0AGeX8jTgXviU8SsabH2Lvg4e4hdYImuibjA9YOeioy8U+w=="
location      = "eastus2"
rg_name       = "demo"
vnet_name     = "vnet-demo"
vnet_cidr     = "172.19.23.0/24"
subnet_names  = ["subnet-1"]
subnet_cidrs  = ["172.19.23.0/24"]
