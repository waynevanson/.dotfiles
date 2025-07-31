{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    home-manager,
    nixpkgs,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystemPassThrough (system: let
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        specialArgs = inputs;

        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          home-manager.nixosModules.home-manager
          ({
            pkgs,
            config,
            ...
          }: {
            home-manager = {
              users.waynevanson = ./home.nix;
              useGlobalPkgs = true;
              useUserPackages = true;
            };

            users.users.waynevanson.isNormalUser = true;
          })

          # podman
          ({
            pkgs,
            lib,
            ...
          }: {
            environment.systemPackages = lib.mkBefore (with pkgs; [
              podman-tui
              podman-compose
            ]);

            virtualisation = {
              containers.enable = true;
              podman = {
                enable = true;
                dockerCompat = true;
                defaultNetwork.settings.dns_enabled = true;
              };
            };
          })

          # greeter
          ({pkgs, ...}: {
            services.greetd = {
              enable = true;
              settings = {
                default_session = {
                  command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
                  user = "greeter";
                };
              };
            };
          })
          #./hyprland.nix
          #./nvim.nix
          #./packages.nix
          #./podman.nix
          #./rust.nix
          #./vscode.nix
          #./waybar.nix
          #./zsh.nix
        ];
      };
    });
}
