# Project Title

Terraform libvirt multiple cloud vm's

## Description

Using Terraform and Libvirt provisioner to deploy one Arch and three Debian virtual machines.

## Getting Started

### Dependencies

* Qemu with KVM Hypervisor Host


### Installing

* Root program directory  
    |-volume #Storage Pool directory  
    |-ssh  
    | |-id_rsa.pub #Public ssh key  
    |-sources #qcow2 cloud-images folder  
    |-tamplets #cloud-init files  
    | |-network_config.tpl  
    | |-user_data.tpl  
    |-variables.tf #Terraform variables  
    |-main.tf #Main Terraform file  
* terraform init
* terraform plan
* terraform apply -auto-approve

### Executing program

* ssh vmadmin@192.168.122.101 arch
* ssh vmadmin@192.168.122.102 debian1
* ssh vmadmin@192.168.122.103 debian2
* ssh vmadmin@192.168.122.104 debian3

```
sudo no password
```

## Help

Runs as intended.
```
terraform state
```

## Authors

Contributors names and contact info

ex. Dawid Olesinski 
ex. [@twitter_user](https://twitter.com/)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the GNU License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [terrafor-libvirt-provider](https://github.com/dmacvicar/terraform-provider-libvirt)
