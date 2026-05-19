-- Tema GTK / Qt — Dark Mode
-- Aplica configurações de tema via gsettings

hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface icon-theme Tela-dracula-dark'")
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface gtk-theme Catppuccin-Macchiato'")
  hl.exec_cmd("uwsm app -- sh -c 'gsettings set org.gnome.desktop.interface color-scheme prefer-dark'")
end)
