# Plugins that don't fit into any specific group.
({
  pkgs,
  lib,
  ...
}: let
  bitwig-studio' = pkgs.bitwig-studio.overrideAttrs rec {
    version = "5.0.11";
    src = pkgs.fetchurl {
      url = "https://www.bitwig.com/dl/Bitwig%20Studio/${version}/installer_linux/";
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
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode-remote.remote-containers
        pkief.material-icon-theme
        pkief.material-product-icons
        redhat.vscode-yaml
        arrterian.nix-env-selector
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        vscodevim.vim
        denoland.vscode-deno
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          publisher = "leathong";
          name = "openscad-language-support";
          version = "1.2.5";
          sha256 = "sha256-/CLxBXXdUfYlT0RaGox1epHnyAUlDihX1LfT5wGd2J8=";
        }
        {
          publisher = "fooxly";
          name = "themeswitch";
          version = "1.0.5";
          sha256 = "sha256-0skuTO2vJ//z7Lvo80/CxFKD2J/6uvJ1y3MdHAwN+Gk=";
        }
      ];
  });
in {
  environment.systemPackages = with pkgs; [
    alacritty
    alejandra
    bitwig-studio'
    brave
    ungoogled-chromium
    deno
    direnv
    discord
    ffmpeg
    firefox
    git
    gnutar
    kdePackages.kdenlive
    libreoffice-qt
    lmms
    neovim
    gnumake
    unzip
    gcc
    ripgrep
    fd
    obsidian
    parallel
    prusa-slicer
    rar
    rclone
    solvespace
    stow
    unzip
    vim
    vscode'
    xz
    zip
    zoom-us
  ];
})
