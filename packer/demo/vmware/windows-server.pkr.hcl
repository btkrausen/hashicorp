source "vsphere-iso" "windows_2019" {
  vcenter_server      = "192.168.169.11"
  username            = "administrator@vsphere.local"
  password            = "RPT.pass123"
  cluster             = "DC1_cluster"
  datacenter          = "Datacenter"
  folder              = "lab/templates"
  datastore           = "datastore1"
  host                = "192.168.169.10"
  insecure_connection = "true"

  vm_name              = "Win2019_Packer"
  winrm_password       = "S3cret!"
  winrm_username       = "Administrator"
  CPUs                 = "4"
  RAM                  = "8192"
  RAM_reserve_all      = true
  communicator         = "winrm"
  disk_controller_type = ["lsilogic-sas"]
  firmware             = "bios"
  floppy_files         = ["setup/w2k19/autounattend.xml", "setup/setup.ps1", "setup/winrmConfig.bat", "setup/vmtools.cmd"]
  guest_os_type        = "windows9Server64Guest"
  iso_paths            = ["[datastore1] ISO/SW_DVD9_Win_Server_STD_CORE_2019_1809.2_64Bit_English_DC_STD_MLF_X22-18452.ISO", "[datastore1] ISO/windows.iso"]
  network_adapters {
    network      = "VM Network"
    network_card = "vmxnet3"
  }

  storage {
    disk_size             = "32768"
    disk_thin_provisioned = true
  }

  convert_to_template = "true"
}

build {
  sources = ["source.vsphere-iso.windows_2019"]

  provisioner "windows-shell" {
    inline = ["dir c:\\"]
  }
}
