#!/usr/bin/env bash
set -e

echo "=== [1/6] Update system ==="
sudo pacman -Syu --noconfirm

echo "=== [2/6] Install Hyprland minimal ==="
sudo pacman -S --needed --noconfirm \
  hyprland \
  xdg-desktop-portal \
  xdg-desktop-portal-hyprland \
  wlroots \
  foot \
  wofi \
  swaybg \
  pipewire wireplumber pipewire-pulse \
  polkit-kde-agent \
  grim slurp wl-clipboard

echo "=== [3/6] Install Hyprland config ==="
mkdir -p ~/.config/hypr
cp ../config/hyprland.conf ~/.config/hypr/hyprland.conf

echo "=== [4/6] Install greetd ==="
sudo pacman -S --noconfirm greetd greetd-tuigreet

sudo tee /etc/greetd/config.toml > /dev/null <<EOF
[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
EOF

sudo systemctl disable sddm || true
sudo systemctl enable greetd --force

echo "=== [5/6] Uninstall KDE Plasma ==="
sudo pacman -Rns --noconfirm \
  plasma-meta \
  kde-applications \
  plasma-workspace \
  sddm \
  kdeconnect || true

echo "=== [6/6] Remove KDE leftovers ==="
sudo pacman -Rns --noconfirm \
  kwin \
  kscreen \
  kwayland \
  plasma-framework \
  libkscreen \
  libkdecorations || true

echo "=================================="
echo "DONE. PLEASE REBOOT NOW."
