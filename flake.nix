{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    musnix  = { url = "github:musnix/musnix";};
  };

  outputs = {nixpkgs, musnix, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;


      modules = [
        musnix.nixosModules.musnix
        ({...}: { musnix.enable = true;})
        ./modules/docker.nix
        ./modules/gnome.nix
        ./modules/packages.nix
        ./modules/steam.nix
        # ./modules/sway.nix
        ./modules/system.nix

        # Purely system related
        /etc/nixos/configuration.nix
      ];

      specialArgs = { inherit nixpkgs; };
    };
  };
}
