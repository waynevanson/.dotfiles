{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Basics
    ({
      pkgs,
      lib,
      ...
    }: {
      home = {
        packages = with pkgs; [
          neofetch
          zip
          xz
          unzip
          git
          stow
          volta
          discord
          vscode.fhs
          alacritty
        ];
      };

      home.stateVersion = "25.05";
    })

    ({pkgs, ...}: {
      home.packages = with pkgs; [
        gnutar
        vim
      ];
    })

    # hyprland
    ({lib, ...}: {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        extraConfig = lib.readFile ./hyprland.conf;
      };
    })

    # waybar
    ({pkgs, ...}: let
      style = ./waybar.css;
      config = ./waybar.jsonc;
    in {
      programs.waybar = {
        inherit style;
        enable = true;
      };
      xdg.configFile."waybar/config.jsonc".source = config;
    })

    # git
    {
      programs.git = {
        enable = true;
        userName = "Wayne Van Son";
        userEmail = "waynevanson@gmail.com";
      };
    }

    # zsh
    ({pkgs, ...}: {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
      home.packages = with pkgs; [
        zsh-completions
        zsh-vi-mode
        zsh-nix-shell
        zsh-clipboard
        zsh-command-time
        zsh-autocomplete
        zsh-you-should-use
      ];
    })

    # neovim
    ({
      lib,
      pkgs,
      ...
    }: {
      home.sessionVariables.EDITOR = "nvim";
      programs.neovim = {
        enable = true;
        extraConfig = lib.fileContents ./init.vim;
        viAlias = true;
        vimAlias = true;
        plugins = with pkgs.vimPlugins; [nvim-treesitter.withAllGrammars];
      };
    })

    # rust
    ({
      pkgs,
      lib,
      ...
    }: {
      home.packages = with pkgs; [
        #clang
        llvmPackages.bintools
        rustup
      ];
      programs.zsh = {
        enable = true;
        initContent = ''
          export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
        '';
      };
      home.sessionVariables = {
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
    })
  ];
}
