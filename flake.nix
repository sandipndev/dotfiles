{
  description = "Sandipan's Configuration for MacOS and NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    secrets.url = "git+ssh://git@github.com/sandipndev/nix-secrets.git";
    secrets.flake = false;
  };
  outputs = {
    self,
    darwin,
    home-manager,
    nixpkgs,
    disko,
    agenix,
    secrets,
  } @ inputs: let
    user = "sandipndev";
    linuxSystems = ["x86_64-linux" "aarch64-linux"];
    darwinSystems = ["aarch64-darwin" "x86_64-darwin"];
    forAllSystems = f: nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;
    nixWithOverlays = {
      nixpkgs.overlays = [
        (import ./overlays/fly-versions.nix)
      ];
    };
    devShell = system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = with pkgs;
        mkShell {
          nativeBuildInputs = with pkgs; [bashInteractive git age age-plugin-yubikey];
          shellHook = with pkgs; ''
            export EDITOR=vim
          '';
        };
    };
    mkApp = scriptName: system: {
      type = "app";
      program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
        #!/usr/bin/env bash
        PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
        echo "Running ${scriptName} for ${system}"
        exec ${self}/apps/${system}/${scriptName}
      '')}/bin/${scriptName}";
    };
    mkLinuxApps = system: {
      "apply" = mkApp "apply" system;
      "build-switch" = mkApp "build-switch" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "install" = mkApp "install" system;
      "install-with-secrets" = mkApp "install-with-secrets" system;
    };
    mkDarwinApps = system: {
      "apply" = mkApp "apply" system;
      "build" = mkApp "build" system;
      "build-switch" = mkApp "build-switch" system;
      "copy-keys" = mkApp "copy-keys" system;
      "create-keys" = mkApp "create-keys" system;
      "check-keys" = mkApp "check-keys" system;
      "rollback" = mkApp "rollback" system;
    };
  in {
    devShells = forAllSystems devShell;
    apps = nixpkgs.lib.genAttrs linuxSystems mkLinuxApps // nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

    darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (
      system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            nixWithOverlays
            home-manager.darwinModules.home-manager
            ./hosts/darwin
          ];
        }
    );

    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;

    nixosConfigurations = nixpkgs.lib.genAttrs linuxSystems (system:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [
          nixWithOverlays
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos
        ];
      });
  };
}
