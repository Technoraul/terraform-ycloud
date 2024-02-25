terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = "ru-central1-a"
  folder_id = "b1gqu16erhmhrv564sic"
}


resource "yandex_compute_instance" "vm-1" {
  name = "nginx-server"
  hostname = "nginx-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8bt3r9v1tq5fq7jcna"
      size     = "6"
    }
  }

  network_interface {
    subnet_id = "e9bv6mtpfo9ol4qrud8p"
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("/home/user/cloud-terraform/meta.txt")}"
  }


}

#resource "yandex_compute_instance" "vm-2" {
#  name = "tf-2"
#  platform_id = "standard-v1"
#  zone = "ru-central1-a"
# 
#  resources {
#    cores  = 2
#    memory = 2
#  }
# 
#  boot_disk {
#    initialize_params {
#      image_id = "fd8bt3r9v1tq5fq7jcna"
#    }
#  }
# 
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-1.id
#    nat       = true
#  }
# 
#}



#resource "yandex_vpc_network" "network-1" {
#  name = "tr-nw"
#}

#resource "yandex_vpc_subnet" "subnet-1" {
#  name           = "tr-nw-subnet"
#  zone           = "ru-central1-a"
#  network_id     = "${yandex_vpc_network.network-1.id}"
#  v4_cidr_blocks = ["172.18.10.0/24"]
#}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}
