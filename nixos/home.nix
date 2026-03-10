# Home Manager configuration
# Symlinks dotfiles from the repo to ~/.config/ for hot-reload editing.
# Changes to these files take effect immediately without nixos-rebuild.

{ config, pkgs, userConfig, ... }:

let
  rawConfigDir = "/etc/nixos/home/.config";
in
{
  home.stateVersion = userConfig.stateVersion;
  home.username = userConfig.username;

  # Symlink app configs — edits take effect immediately (hot-reload)
  # Hyprland auto-reloads on config change
  # Kitty: Ctrl+Shift+F5 to reload
  # Fish: instant on new shell
  # Waybar: auto-reloads by default
  # Helper to symlink directly from the cloned repo instead of copying to Nix store
  # This enables instant hot-reloading for apps that support it
  xdg.configFile = {
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/hypr";
    "kitty".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/kitty";
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/waybar";
    "fish".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/fish";
    "rofi".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/rofi";
    "dunst".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/dunst";
    "avizo".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/avizo";
    "wlogout".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/wlogout";
    "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/starship.toml";
    "btop".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/btop";
    "bottom".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/bottom";
    "bat".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/bat";
    "cava".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/cava";
    "fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/fastfetch";
    "helix".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/helix";
    "yazi".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/yazi";
    "zathura".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/zathura";
    "mpv".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/mpv";
    "htop".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/htop";
    "lazygit".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/lazygit";
    "delta".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/delta";
    "swappy".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/swappy";
    "pypr".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/pypr";
    "qutebrowser".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/qutebrowser";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/wezterm";
    "zellij".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/zellij";
    "nushell".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/nushell";
    "aichat".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/aichat";
    "opencode".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/opencode";
    "posting".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/posting";
    "bacon".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/bacon";
    "tealdeer".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/tealdeer";

    # GTK / Theming
    "gtk-3.0".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/gtk-3.0";
    "gtk-4.0".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/gtk-4.0";
    "Kvantum".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/Kvantum";
    "xfce4".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/xfce4";
    "xsettingsd".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/xsettingsd";

    # MIME types
    "mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/mimeapps.list";
    "user-dirs.dirs".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/user-dirs.dirs";
    "user-dirs.locale".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/user-dirs.locale";

    # Misc config files
    "topgrade.toml".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/topgrade.toml";
    "pavucontrol.ini".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/pavucontrol.ini";
    "nixpkgs".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/nixpkgs";

    # Environment files
    ".env.searxng".source = config.lib.file.mkOutOfStoreSymlink "${rawConfigDir}/.env.searxng";
  };

  # Symlink home-level dotfiles
  home.file = {
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.gitconfig";
    ".gtkrc-2.0".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.gtkrc-2.0";
  };
}
