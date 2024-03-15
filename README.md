## Sandipan's NixOS / Nix Darwin Setup
0. Install Homebrew:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

1. Determinate Systens Nix Installer:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

2. Download this repo as a ZIP
3. Copy the id_ed25519s from the Pendrive or iCloud Drive
4. Run:
```
./apply
```
5. Reboot
