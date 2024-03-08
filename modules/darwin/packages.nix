{pkgs}:
with pkgs; let
  shared-packages = import ../shared/packages.nix {inherit pkgs;};
in
  shared-packages
  ++ [
    pkgs.alejandra
    pkgs.tree
    pkgs.jq
    pkgs.fly91
  ]
