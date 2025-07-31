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
        username = lib.mkForce "waynevanson";
        homeDirectory = lib.mkForce "/home/waynevanson";
        packages = with pkgs; [
          neofetch
          zip
          xz
          unzip
          git
          stow
          volta
          discord
        ];
      };

      home.stateVersion = "25.05";
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
  ];
}
