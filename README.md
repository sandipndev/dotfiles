## Sandipan's NixOS / Nix Darwin Setup

1. Determinate Systens Nix Installer:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Download this repo as a ZIP
3. Copy the id_ed25519s from the Pendrive
4. Run:
```
nix run .#build-switch
```
5. Reboot
