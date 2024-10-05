# Plugins that don't fit into any specific group.
({
  pkgs,
  lib,
  ...
}: let
  bitwig-studio' = pkgs.bitwig-studio.overrideAttrs {
    version = "5.0.11";
    src = pkgs.fetchurl {
      url = "https://www.bitwig.com/dl/Bitwig%20Studio/5.0.11/installer_linux/";
      hash = "sha256-c9bRWVWCC9hLxmko6EHgxgmghrxskJP4PQf3ld2BHoY=";
    };
  };
  vscode' = with pkgs; (vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [
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
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "leathong";
          name = "openscad-language-support";
          version = "1.2.5";
          sha256 = "sha256-/CLxBXXdUfYlT0RaGox1epHnyAUlDihX1LfT5wGd2J8=";
        }
      ];
  });
in {
  environment.systemPackages = with pkgs; [
    alacritty
    alejandra
    bitwig-studio'
    chromium
    chromedriver
    corepack
    direnv
    discord
    firefox
    git
    inkscape-with-extensions
    nodejs
    obsidian
    openscad-unstable
    prusa-slicer
    pixelorama
    ranger
    rar
    signal-desktop
    stow
    unzip
    vscode'
    zip
    zoom-us
  ];
})
