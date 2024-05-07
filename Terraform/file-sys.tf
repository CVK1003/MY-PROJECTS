provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "centos_volume" {
  name = "centos7.qcow2"
  pool = "default"
  source = "http://mirror.centos.org/centos/7/cloud/x86_64/images/CentOS-7-x86_64-GenericCloud-1907.qcow2"
}

resource "libvirt_domain" "centos_vm" {
  name   = "centos7-vm"
  memory = 1024
  vcpu   = 1

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.centos_volume.id
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y parted",
      "sudo parted /dev/vda --script mklabel gpt mkpart primary 0% 100%",
      "sudo mkfs.ext4 /dev/vda1",
      "sudo mkdir /data",
      "sudo mount /dev/vda1 /data",
      "sudo echo '/dev/vda1 /data ext4 defaults 0 0' | sudo tee -a /etc/fstab",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = file("~/.ssh/id_rsa")
      host        = self.network_interface.0.addresses[0]
    }
  }
}
