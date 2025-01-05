{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    nixos-wsl,
    ...
  }: let
    system = builtins.currentSystem;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    common = {
      inherit system pkgs;
      specialArgs = {inherit nixpkgs;};
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem (common
      // {
        modules = [
          ./modules/docker.nix
          ./modules/gnome.nix
          ./modules/packages.nix
          ./modules/steam.nix
          ./modules/system.nix

          # Purely system related
          /etc/nixos/configuration.nix
        ];
      });

    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem (common
      // {
        modules = [
          nixos-wsl.nixosModules.default

          ({pkgs, ...}: {
            system.stateVersion = "24.05";
            wsl.enable = true;
            wsl.defaultUser = "waynevanson";

            programs.nix-ld = {
              enable = true;
              package = pkgs.nix-ld-rs; # only for NixOS 24.05
            };

            environment.systemPackages = with pkgs; [
              corepack
              curl
              direnv
              git
              nodejs
              vim
              wget
            ];
          })
        ];
      });
  };
}
