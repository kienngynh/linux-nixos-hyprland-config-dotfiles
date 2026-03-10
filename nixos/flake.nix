{
  description = "My NixOS Configuration";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      rust-overlay.url = "github:oxalica/rust-overlay";
      wezterm.url = "github:wez/wezterm?dir=nix";
      nix-ai-tools.url = "github:numtide/nix-ai-tools";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
  let
    # ===== EDIT THESE FOR YOUR MACHINE =====
    userConfig = {
      username = "tulipbk";
      hostname = "nixos";
      stateVersion = "24.11";  # Set to the release version of your initial NixOS install
    };
    # =======================================

    mkHost = { profile, extraModules ? [] }: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs userConfig; };
      modules = [
        ./configuration.nix
        ./profiles/${profile}.nix

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${userConfig.username} = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit userConfig; };
        }
      ] ++ extraModules;
    };
  in
  {
    # Minimal: just desktop + essentials (fast first deploy)
    nixosConfigurations.${userConfig.hostname} = mkHost {
      profile = "minimal";
    };

    # Full: everything including AI, Rust, security hardening
    nixosConfigurations."${userConfig.hostname}-full" = mkHost {
      profile = "full";
    };
  };
}
