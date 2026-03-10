# Full profile: Everything including security hardening, AI/LLM, Rust, dev tools.
# Imports minimal + all additional modules.

{ ... }:

{
  imports = [
    ./minimal.nix

    # Security
    ../security-services.nix
    ../usb.nix

    # Networking extras
    ../dns.nix
    ../vpn.nix
    ../mosh.nix
    # ../open-ssh.nix
    # ../mac-randomize.nix

    # Power & hardware
    ../power.nix
    ../keyboard.nix
    ../swap.nix
    # ../fingerprint-scanner.nix
    # ../clamav-scanner.nix
    # ../location.nix

    # Desktop extras
    # ../gnome.nix
    # ../printing.nix

    # Development
    ../programming-languages.nix
    ../lsp.nix
    ../rust.nix
    ../wasm.nix
    ../dev-tools.nix
    ../terminal.nix
    ../info-fetchers.nix
    ../radicle.nix

    # AI / LLM
    ../llm.nix

    # Virtualisation
    ../virtualisation.nix

    # Work
    ../work.nix

    # Yubikey
    ../yubikey.nix

    # Auto-upgrade (disabled by default)
    # ../auto-upgrade.nix
  ];
}
