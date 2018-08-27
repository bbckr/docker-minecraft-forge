variable "DOCKERHUB_USERNAME" {}
variable "DOCKERHUB_PASSWORD" {}

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
      "sudo apt-get update",
      "sudo apt-get install -y systemd-docker",
      "docker login --username=${var.DOCKERHUB_USERNAME} --password=${var.DOCKERHUB_PASSWORD}",
      "sudo systemctl start minecraft.service",
      "docker logout"
    ]
  }
}

resource "digitalocean_ssh_key" "ssh" {
    name = "Terraform Key"
    public_key = "${file("~/.ssh/digitalocean_key.pub")}"
}
