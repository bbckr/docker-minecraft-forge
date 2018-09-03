variable "DOCKERHUB_USERNAME" {}
variable "DOCKERHUB_PASSWORD" {}
variable "IMAGE_TAG" {
  default = "latest"
  }

provider "digitalocean" {}

resource "digitalocean_droplet" "minecraft" {
  image       = "docker-16-04"
  name        = "minecraft-server"
  region      = "nyc1"
  size        = "s-1vcpu-1gb"
  ssh_keys    = ["${digitalocean_ssh_key.ssh.id}"] 

  connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("~/.ssh/digitalocean_key")}"
      timeout     = "1m"
    }

  provisioner "file" {
    source      = "./resources/minecraft.service"
    destination = "/lib/systemd/system/minecraft.service"
  }

  provisioner "remote-exec" {
    inline = [      
      "export PATH=$PATH:/usr/bin",
      "mkdir /etc/systemd/system/minecraft.service.d",
      "echo IMAGE_TAG=${var.IMAGE_TAG} > /etc/systemd/system/minecraft.service.d/image-tag.conf",
      "sudo apt-get update",
      "sudo apt-get install -y systemd-docker",
      "docker login --username=${var.DOCKERHUB_USERNAME} --password=${var.DOCKERHUB_PASSWORD}",
      "sudo systemctl start minecraft.service",
      "sudo systemctl enable minecraft.service",
      "docker logout",
    ]
  }
}

resource "digitalocean_ssh_key" "ssh" {
    name = "Terraform Key"
    public_key = "${file("~/.ssh/digitalocean_key.pub")}"
}

resource "digitalocean_firewall" "minecraft" {
  name = "only-ssh-minecraft-rcon"

  droplet_ids = ["${digitalocean_droplet.minecraft.id}"]

  inbound_rule = [
    {
      protocol            = "tcp"
      port_range          = "22"
      source_addresses    = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol            = "tcp"
      port_range          = "25565"
      source_addresses    = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol            = "tcp"
      port_range          = "25575"
      source_addresses    = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol            = "icmp"
      source_addresses    = ["0.0.0.0/0", "::/0"]
    },
  ]

   outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "all"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
  ]
}
