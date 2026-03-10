# AMD GPU hardware profile
# For machines with AMD Radeon GPUs (RDNA, RDNA2, RDNA3, etc.)

{ pkgs, ... }:

{
  # AMD GPU kernel modules
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Load amdgpu driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "amdgpu" ];

  # OpenGL / GPU acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk            # AMD Vulkan driver
      rocmPackages.clr   # OpenCL support
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # Use RADV (Mesa) Vulkan driver by default (generally better than amdvlk)
  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
  };
}
