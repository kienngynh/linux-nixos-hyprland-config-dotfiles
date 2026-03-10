# Home Manager configuration
# Symlinks dotfiles from the repo to ~/.config/ for hot-reload editing.
# Changes to these files take effect immediately without nixos-rebuild.

{ config, pkgs, userConfig, ... }:

{
  home.stateVersion = userConfig.stateVersion;
  home.username = userConfig.username;

  # Symlink app configs — edits take effect immediately (hot-reload)
  # Hyprland auto-reloads on config change
  # Kitty: Ctrl+Shift+F5 to reload
  # Fish: instant on new shell
  # Waybar: auto-reloads by default
  xdg.configFile = {
    "hypr".source = ../home/.config/hypr;
    "kitty".source = ../home/.config/kitty;
    "waybar".source = ../home/.config/waybar;
    "fish".source = ../home/.config/fish;
    "rofi".source = ../home/.config/rofi;
    "dunst".source = ../home/.config/dunst;
    "avizo".source = ../home/.config/avizo;
    "wlogout".source = ../home/.config/wlogout;
    "starship.toml".source = ../home/.config/starship.toml;
    "btop".source = ../home/.config/btop;
    "bottom".source = ../home/.config/bottom;
    "bat".source = ../home/.config/bat;
    "cava".source = ../home/.config/cava;
    "fastfetch".source = ../home/.config/fastfetch;
    "helix".source = ../home/.config/helix;
    "yazi".source = ../home/.config/yazi;
    "zathura".source = ../home/.config/zathura;
    "mpv".source = ../home/.config/mpv;
    "htop".source = ../home/.config/htop;
    "lazygit".source = ../home/.config/lazygit;
    "delta".source = ../home/.config/delta;
    "swappy".source = ../home/.config/swappy;
    "pypr".source = ../home/.config/pypr;
    "qutebrowser".source = ../home/.config/qutebrowser;
    "wezterm".source = ../home/.config/wezterm;
    "zellij".source = ../home/.config/zellij;
    "nushell".source = ../home/.config/nushell;
    "aichat".source = ../home/.config/aichat;
    "opencode".source = ../home/.config/opencode;
    "posting".source = ../home/.config/posting;
    "bacon".source = ../home/.config/bacon;
    "tealdeer".source = ../home/.config/tealdeer;

    # GTK / Theming
    "gtk-3.0".source = ../home/.config/gtk-3.0;
    "gtk-4.0".source = ../home/.config/gtk-4.0;
    "Kvantum".source = ../home/.config/Kvantum;
    "xfce4".source = ../home/.config/xfce4;
    "xsettingsd".source = ../home/.config/xsettingsd;

    # MIME types
    "mimeapps.list".source = ../home/.config/mimeapps.list;
    "user-dirs.dirs".source = ../home/.config/user-dirs.dirs;
    "user-dirs.locale".source = ../home/.config/user-dirs.locale;

    # Misc config files
    "topgrade.toml".source = ../home/.config/topgrade.toml;
    "pavucontrol.ini".source = ../home/.config/pavucontrol.ini;
    "nixpkgs".source = ../home/.config/nixpkgs;

    # Environment files
    ".env.searxng".source = ../home/.config/.env.searxng;
  };

  # Symlink home-level dotfiles
  home.file = {
    ".gitconfig".source = ../home/.gitconfig;
    ".gtkrc-2.0".source = ../home/.gtkrc-2.0;
    ".npmrc".source = ../home/.npmrc;
  };
}
