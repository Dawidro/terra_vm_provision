variable "hosts" {
  type = number
  default = 4
}

variable "interface" {
  type = string
  default = "ens01"
}

variable "memory" {
  type = string
  default = "4096"
}

variable "vcpu" {
  type = number
  default = 2
}

variable "distros" {
  type = list
  default = ["arch", "debian1", "debian2", "debian3"]
}

variable "vm_names" {
  type = list
  default = ["arch", "debian1", "debian2", "debian3"]
}

variable "ips" {
  type = list
  default = ["192.168.122.101", "192.168.122.102", "192.168.122.103", "192.168.122.104"]
}
variable "macs" {
  type = list
  default = ["52:54:00:50:99:c5", "52:54:00:0e:87:be", "52:54:00:9d:90:38", "52:54:00:a1:67:c4"]
}
