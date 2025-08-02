{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flake-utils,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    bootable = {
      imports = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };

    waynevanson = {pkgs, ...}: {
      imports = [
        home-manager.nixosModules.home-manager
      ];

      home-manager = {
        users.waynevanson = ./home.nix;
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.waynevanson = {
        isNormalUser = true;
        description = "Wayne Van Son";
        extraGroups = ["networkmanager" "wheel"];
      };
    };

    podman = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        podman-tui
        podman-compose
      ];

      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        specialArgs = inputs;

        modules = [
          ./configuration.nix
          #bootable
          waynevanson
          podman
        ];
      };
    });
}
