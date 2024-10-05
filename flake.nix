{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
        ./modules/docker.nix
        ./modules/gnome.nix
        ./modules/nnn.nix
        ./modules/packages.nix
        ./modules/rofi.nix
        ./modules/steam.nix
        # ./modules/sway.nix
        ./modules/system.nix

        # Purely system related
        /etc/nixos/configuration.nix
      ];
    };
  };
}
