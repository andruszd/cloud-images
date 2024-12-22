# AlmaLinux OS 9 Packer template for Azure VM images

source "qemu" "almalinux-9-azure-x86_64" {
  iso_url            = local.iso_url_9_x86_64
  iso_checksum       = local.iso_checksum_9_x86_64
  http_directory     = var.http_directory
  shutdown_command   = var.root_shutdown_command
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  boot_command       = var.azure_boot_command_9_x86_64
  boot_wait          = var.boot_wait
  accelerator        = "kvm"
  disk_interface     = "virtio-scsi"
  disk_size          = var.azure_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  format             = "raw"
  headless           = var.headless
  machine_type       = "q35"
  memory             = var.memory_x86_64
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "AlmaLinux-9-Azure-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.x86_64.raw"
  cpu_model          = "host"
  cpus               = var.cpus
  efi_boot           = true
  efi_firmware_code  = var.ovmf_code
  efi_firmware_vars  = var.ovmf_vars
  efi_drop_efivars   = true
}

source "qemu" "almalinux-9-azure-aarch64" {
  iso_url            = local.iso_url_9_aarch64
  iso_checksum       = local.iso_checksum_9_aarch64
  http_directory     = var.http_directory
  shutdown_command   = var.root_shutdown_command
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  boot_command       = var.azure_boot_command_9_aarch64
  boot_wait          = var.boot_wait
  accelerator        = "kvm"
  firmware           = var.aavmf_code
  use_pflash         = false
  disk_interface     = "virtio-scsi"
  disk_size          = var.azure_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  format             = "raw"
  headless           = var.headless
  machine_type       = "virt,gic-version=max"
  memory             = var.memory_aarch64
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "AlmaLinux-9-Azure-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}0.aarch64.raw"
  cpu_model          = "host"
  cpus               = var.cpus
  qemuargs = [
    ["-boot", "strict=on"],
    ["-monitor", "none"]
  ]
}

source "qemu" "almalinux_9_azure_aarch64_64k" {
  iso_url            = local.iso_url_9_aarch64
  iso_checksum       = local.iso_checksum_9_aarch64
  http_directory     = var.http_directory
  shutdown_command   = var.root_shutdown_command
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  boot_command       = var.azure_boot_command_9_64k_aarch64
  boot_wait          = var.boot_wait
  accelerator        = "kvm"
  firmware           = var.aavmf_code
  use_pflash         = false
  disk_interface     = "virtio-scsi"
  disk_size          = var.azure_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  format             = "raw"
  headless           = var.headless
  machine_type       = "virt,gic-version=max"
  memory             = var.memory_aarch64
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "AlmaLinux-Azure-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}0-64k.aarch64.raw"
  cpu_model          = "host"
  cpus               = var.cpus
  qemuargs = [
    ["-boot", "strict=on"],
    ["-monitor", "none"]
  ]
}

build {
  sources = [
    "source.qemu.almalinux-9-azure-x86_64",
    "source.qemu.almalinux-9-azure-aarch64",
    "source.qemu.almalinux_9_azure_aarch64_64k",
  ]

  provisioner "ansible" {
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    collections_path     = "./ansible/collections"
    roles_path           = "./ansible/roles"
    playbook_file        = "./ansible/azure.yml"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
    ]
  }
}
