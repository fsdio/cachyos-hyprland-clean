#!/usr/bin/env bash
set -e

echo "=== [1/7] Remove orphan packages ==="
orphans=$(pacman -Qtdq || true)
if [ -n "$orphans" ]; then
  sudo pacman -Rns --noconfirm $orphans
fi

echo "=== [2/7] Clean KDE config ==="
rm -rf ~/.config/plasma* ~/.config/kde*
rm -rf ~/.cache/plasma* ~/.cache/kde*
rm -rf ~/.local/share/plasma* ~/.local/share/kde*

echo "=== [3/7] Install NVIDIA drivers ==="
sudo pacman -S --needed --noconfirm \
  nvidia \
  nvidia-utils \
  lib32-nvidia-utils \
  nvidia-settings \
  egl-wayland

echo "=== [4/7] Enable NVIDIA DRM ==="
sudo tee /etc/modprobe.d/nvidia.conf > /dev/null <<EOF
options nvidia_drm modeset=1
EOF

sudo mkinitcpio -P

echo "=== [5/7] Environment variables ==="
grep -q "NV_PRIME" ~/.profile || cat <<'EOF' >> ~/.profile

# --- Wayland ---
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland

# --- NVIDIA PRIME ---
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
EOF

echo "=== [6/7] Gaming tools ==="
sudo pacman -S --noconfirm \
  steam \
  gamemode \
  lib32-gamemode \
  mangohud

systemctl --user enable gamemoded || true

echo "=== [7/7] Final check ==="
pacman -Qs plasma || echo "Plasma clean"
ps aux | grep -E "plasma|kwin" | grep -v grep || echo "No KDE process"
free -h

echo "DONE. REBOOT RECOMMENDED."
