# Minimal profile: A working Hyprland desktop with essentials only.
# This is the fastest path to a usable system.

{ ... }:

{
  imports = [
    ../hardware-configuration.nix
    ../bootloader.nix
    ../networking.nix
    ../users.nix
    ../time.nix
    ../internationalisation.nix
    ../nix-settings.nix
    ../nixpkgs.nix
    ../gc.nix
    ../linux-kernel.nix
    ../screen.nix
    ../display-manager.nix
    ../hyprland.nix
    ../sound.nix
    ../fonts.nix
    ../theme.nix
    ../environment-variables.nix
    ../bluetooth.nix
    ../firewall.nix
    ../services.nix
  ];
}
