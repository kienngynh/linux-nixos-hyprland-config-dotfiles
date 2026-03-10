{ pkgs, userConfig, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.username;
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" ];
    shell = pkgs.nushell;
    packages = with pkgs; [
      discord
      telegram-desktop
      vscodium
    ];
  };

  # Change runtime directory size
  services.logind.settings.Login = {
    RuntimeDirectorySize="8G";
  };
}
