{
    description = "NixOS flake for yours truly";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-unstable";

        flake-utils.url = "github:numtide/flake-utils";
        flake-utils.inputs.systems.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, flake-utils, ... }: 
            let
                system = "x86_64-linux";
                pkgs = import nixpkgs {
                    inherit system;
                    config.allowUnfree = true;
                };
                bitwig-studio' = with pkgs; (bitwig-studio.overrideAttrs({
                    version = "5.0.11";
                    src = fetchurl {
                        url = "https://www.bitwig.com/dl/Bitwig%20Studio/5.0.11/installer_linux/";
                        hash = "sha256-c9bRWVWCC9hLxmko6EHgxgmghrxskJP4PQf3ld2BHoY=";
                    };
                }));
                vscode' = with pkgs; (vscode-with-extensions.override {
                    vscodeExtensions = with vscode-extensions; [
                        astro-build.astro-vscode
                        bbenoist.nix
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
                });
                nixos = {
                    users.users.waynevanson.extraGroups = [
                        "networkmanager"
                        "wheel"
                        "docker"
                    ];

                    virtualisation.docker.enable = true;

                    programs.steam = {
                        enable = true;
                        remotePlay.openFirewall = true;
                        dedicatedServer.openFirewall = true;
                        localNetworkGameTransfers.openFirewall = true;
                    };

                    environment.systemPackages = with pkgs; [
                        alacritty
                        alejandra
                        bitwig-studio'
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
                        vscode'
                        zip
                        zoom-us
                    ];
                };
            in
                {
                    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
                        inherit system;
                        modules = [
                            "/etc/nixos/configuration.nix"
                            nixos
                        ];
                    };
                };
            
}