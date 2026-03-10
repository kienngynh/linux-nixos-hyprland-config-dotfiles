$env.config = {
  show_banner: false
}

# Load Starship prompt
try {
  source ~/.cache/starship/init.nu
}

# Auto-start Zellij
if ($env.ZELLIJ? == null) {
  # If inside a terminal that isn't already Zellij, run Zellij
  # "attach -c" attaches to default session or creates one
  zellij attach -c
}
