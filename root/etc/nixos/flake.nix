# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled

{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            alacritty
            cron
            chromium
            firefox
            nixfmt
            openscad-unstable
            prusa-slicer
            zoom-us
            nixfmt-classic
            (vscode-with-extensions.override {
              vscodeExtensions = with vscode-extensions;
                [
                  bbenoist.nix
                  # # overrides
                  # b4dm4n.nixpkgs-fmt
                  dbaeumer.vscode-eslint
                  eamodio.gitlens
                  esbenp.prettier-vscode
                  github.github-vscode-theme
                  pkief.material-icon-theme
                  pkief.material-product-icons
                  redhat.vscode-yaml
                  tamasfe.even-better-toml
                  vscodevim.vim
                ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
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
