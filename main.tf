terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_pool" "vmpool" {
  name = "cloud-pool"
  type = "dir"
  path = "${path.module}/volume"
}

resource "libvirt_volume" "distro-qcow2" {
  count  = var.hosts
  name   = "${var.distros[count.index]}.qcow2"
  pool   = libvirt_pool.vmpool.name
  source = "${path.module}/sources/${var.distros[count.index]}.qcow2"
  format = "qcow2"
}

# ssh private key for debug purpose
resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
}

resource "local_file" "ssh_private_key" {
    sensitive_content = tls_private_key.id_rsa.private_key_pem
    filename          = "${path.module}/id_rsa"
}

resource "local_file" "ssh_public_key" {
    sensitive_content = tls_private_key.id_rsa.public_key_openssh
    filename          = "${path.module}/id_rsa.pub"
}


resource "libvirt_cloudinit_disk" "commoninit" { 
  count     = var.hosts
  name      = "commoninit-${var.vm_names[count.index]}.iso"
  pool      = libvirt_pool.vmpool.name
  user_data = templatefile("${path.module}/templates/user_data.tpl", {
      host_name = var.distros[count.index]
      host_key  = file("${path.module}/ssh/id_rsa.pub")
      vm_public_key = chomp(tls_private_key.id_rsa.public_key_openssh)
  })  
  
  network_config =   templatefile("${path.module}/templates/network_config.tpl", {
     interface = var.interface
     ip_addr   = var.ips[count.index]
     mac_addr = var.macs[count.index]
  })
}

resource "libvirt_domain" "cloud-domain" {
  count  = var.hosts
  name   = var.distros[count.index]
  memory = var.memory
  vcpu   = var.vcpu  
  
  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)
  
  network_interface {
      network_name = "default"
      addresses    = [var.ips[count.index]]
      mac          = var.macs[count.index]
  }  
  
  console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
  }  
  
  console {
      type        = "pty"
      target_port = "1"
      target_type = "virtio"
  } 
  
  disk {
      volume_id = element(libvirt_volume.distro-qcow2.*.id, count.index)
  }
}


resource "null_resource" "local_execution" {
  provisioner "remote-exec" {
       connection {
           user = "vmadmin"
           host = var.ips[0]
           type     = "ssh"
           private_key = file("~/.ssh/id_rsa")
       }

       inline = [
           "echo '${tls_private_key.id_rsa.private_key_pem}' > /home/vmadmin/.ssh/id.rsa",
           "chmod 600 /home/vmadmin/.ssh/id.rsa",
           "sudo pacman -Syy --noconfirm",
           "sudo pacman -S ansible --noconfirm" 
       ]
   }
}
