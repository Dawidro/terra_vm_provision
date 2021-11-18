#cloud-config
# vim: syntax=yaml
hostname: ${host_name}
manage_etc_hosts: true
users:
  - name: vmadmin
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      -  ${host_key}
      -  ${vm_public_key}
    shell: /bin/bash
ssh_pwauth: true
disable_root: false
chpasswd:
  list: |
    vmadmin: linux
  expire: false
growpart:
  mode: auto
  devices: ['/']
