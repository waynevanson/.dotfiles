{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "./modules/docker.nix"
        "./modules/gnome.nix"
        "./modules/nnn.nix"
        "./modules/packages.nix"
        "./modules/steam.nix"
        # "./modules/sway.nix"
        "./modules/system.nix"

        # Purely system related
        "/etc/nixos/configuration.nix"
      ];
    };
  };
}
