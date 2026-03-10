mkdir ~/.cache/starship
try {
  starship init nu | save -f ~/.cache/starship/init.nu
}
