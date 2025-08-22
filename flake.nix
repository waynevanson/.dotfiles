{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    hyprland.url = "github:hyprwm/hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprcursor.url = "github:hyprwm/hyprcursor";
    hyprcursor.inputs.nixpkgs.follows = "nixpkgs";
    eew.url = "github:elkowar/eww";
    eew.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  } @ inputs: let
    bootable' = {
      imports = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };

    # user level packages
    waynevanson' = {pkgs, ...}: let
      dotfiles' = pkgs.writeShellScriptBin "dotfiles" (builtins.readFile ./dotfiles.sh);
      packages = with pkgs; [
        alacritty
        alejandra
        direnv
        discord
        dotfiles'
        git
        gnutar
        nerd-fonts.jetbrains-mono
        neofetch
        nil
        podman
        podman-desktop
        podman-compose
        podman-tui
        prusa-slicer
        tuckr
        unzip
        volta
        vscode.fhs
        xz
        zip
      ];
    in {
      programs.firefox.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.waynevanson = {
        isNormalUser = true;
        description = "Wayne Van Son";
        extraGroups = ["audio" "video" "networkmanager" "wheel"];
        inherit packages;
      };
    };

    podman' = {pkgs, ...}: {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };

    desktop' = {
      imports = [./desktop.nix];
      services.wayland.desktop'.enable = true;
    };

    neovim' = {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
      };
    };

    rust' = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        #clang
        llvmPackages.bintools
        probe-rs-tools
        rustup
      ];

      environment.sessionVariables = {
        BINDGEN_EXTRA_CLANG_ARGS =
          lib.concatStringsSep " "
          (builtins.map builtins.toString (
            (builtins.map (a: ''-I"${a}/include"'') [
              pkgs.glibc.dev
            ])
            ++ [
              ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
              ''-I"${pkgs.glib.dev}/include/glib-2.0"''
              ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
            ]
          ));
        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [pkgs.llvmPackages_latest.libclang.lib];
      };

      environment.shellInit = ''
        export PATH="$PATH:~/.volta/bin"
      '';
    };
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        specialArgs = {inherit inputs;};

        modules = [
          ./configuration/workstation.nix
          ./hardware-configuration/${"ThinkPad P16v Gen 1"}/hardware-configuration.nix
          desktop'
          podman'
          waynevanson'
          rust'
          neovim'
        ];
      };
    });
}
