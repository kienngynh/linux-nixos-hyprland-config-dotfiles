# Virtual Machine hardware profile
# For VMs (QEMU/KVM, VirtualBox, VMware, etc.)

{ pkgs, ... }:

{
  # VM-specific kernel modules
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" "virtio_net" "9p" "9pnet_virtio" ];

  # Basic graphics for VMs
  hardware.graphics.enable = true;

  # Guest additions
  services.spice-vdagentd.enable = true;

  environment.systemPackages = with pkgs; [
    spice-vdagent
  ];
}
