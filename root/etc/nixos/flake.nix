# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled

{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Rust overlay with sensible defaults
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix }:

  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({ ... }: {
          programs.steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
          };
        })

        ({ pkgs, ... }: {
          users.users.waynevanson.extraGroups = ["docker"];
          virtualisation.docker.enable = true;
          users.users.waynevanson.packages = with pkgs; [
            alacritty
            (bitwig-studio.overrideAttrs({
               version = "5.0.11";
               src = fetchurl {
                  url = "https://www.bitwig.com/dl/Bitwig%20Studio/5.0.11/installer_linux/";
                  hash = "sha256-c9bRWVWCC9hLxmko6EHgxgmghrxskJP4PQf3ld2BHoY=";
              };
            }))
            cron
            chromium
            chromedriver
            corepack
            direnv
            discord
	    docker
            docker-compose
            firefox
            git
            inkscape-with-extensions
            lutris
            nixfmt-classic
            nodejs
            obsidian
            openscad-unstable
            prusa-slicer
            pixelorama
            rar
            signal-desktop
            steam
            stow
            unzip
            zip
            zoom-us
            (vscode-with-extensions.override {
              vscodeExtensions = with vscode-extensions;
                [
                  astro-build.astro-vscode
                  bbenoist.nix
                  # # overrides
                  # b4dm4n.nixpkgs-fmt
                  dbaeumer.vscode-eslint
                  eamodio.gitlens
                  esbenp.prettier-vscode
                  github.github-vscode-theme
                  mkhl.direnv
		  ms-vscode-remote.remote-containers
                  pkief.material-icon-theme
                  pkief.material-product-icons
                  redhat.vscode-yaml
                  arrterian.nix-env-selector
                  rust-lang.rust-analyzer
                  tamasfe.even-better-toml
                  vscodevim.vim
                ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                  {
                    publisher = "leathong";
                    name = "openscad-language-support";
                    version = "1.2.5";
                    sha256 = "sha256-/CLxBXXdUfYlT0RaGox1epHnyAUlDihX1LfT5wGd2J8="; 
                  }
                ];
            })
          ];
        })

        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        /etc/nixos/configuration.nix
      ];
    };
  };
}
