# CachyOS Hyprland Clean Setup

Clean removal of KDE Plasma and rebuild with Hyprland minimal.
Optimized for:
- MSI Cyborg 15 A13V
- Intel iGPU + NVIDIA RTX
- Backend coding & gaming

## Usage

### 1. Before reboot (from KDE)
```bash
cd scripts
chmod +x 01-before-reboot.sh
./01-before-reboot.sh
reboot
```
### 1. After reboot (Hyprland)
```bash
cd scripts
chmod +x 02-after-reboot.sh
./02-after-reboot.sh
reboot
```
