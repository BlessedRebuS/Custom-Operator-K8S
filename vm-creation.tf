terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.1.22:8006/api2/json"
}

resource "proxmox_vm_qemu" "pxe-example" {
    name                      = "<NAME>"
    desc                      = "<DESCRIPTION>"
    pxe                       = true
    agent                     = 0
    automatic_reboot          = true
    balloon                   = 0
    bios                      = "seabios"
    boot                      = "order=scsi0;net0"
    cores                     = 4
    cpu                       = "host"
    define_connection_info    = true
    force_create              = false
    hotplug                   = "network,disk,usb"
    kvm                       = true
    memory                    = 4096
    numa                      = false
    onboot                    = true
    os_type                   = "Linux 5.x - 2.6 Kernel"
    qemu_os                   = "l26"
    scsihw                    = "virtio-scsi-pci"
    sockets                   = 1
    tablet                    = true
    target_node               = "pve1"
    vcpus                     = 0
    disk {
        backup       = false
        cache        = "none"
        discard      = "on"
        iothread     = 1
        mbps         = 0
        mbps_rd      = 0
        mbps_rd_max  = 0
        mbps_wr      = 0
        mbps_wr_max  = 0
        replicate    = 0
        size         = "100G"
        ssd          = 1
        storage      = "local-lvm"
        type         = "scsi"
    }

    network {
        bridge    = "vmbr0"
        firewall  = true
        link_down = false
        model     = "virtio"
    }

}
