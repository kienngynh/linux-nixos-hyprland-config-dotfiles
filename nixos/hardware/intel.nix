# Intel iGPU-only hardware profile
# For machines with Intel integrated graphics (UHD, Iris, etc.)

{ pkgs, ... }:

{
  # Intel GPU kernel modules for early KMS
  boot.initrd.availableKernelModules = [ "i915" ];
  boot.initrd.kernelModules          = [ "i915" ];

  # OpenGL / GPU acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver    # LIBVA_DRIVER_NAME=iHD (newer Intel)
      vaapiIntel            # LIBVA_DRIVER_NAME=i965 (older Intel)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Intel-specific environment variable for VA-API
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
