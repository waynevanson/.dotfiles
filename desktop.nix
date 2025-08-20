{
  pkgs,
  nixpkgs,
  config,
  lib,
  inputs,
  ...
}: {
  options.services.desktop' = {
    enable = lib.mkEnableOption "Hyprland Customized Desktop environment";
  };

  config = lib.mkIf config.services.desktop'.enable {
    services.dbus.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
    users.users.greeter = {
      isSystemUser = true;
      description = "Greetd login user";
      extraGroups = ["video" "audio" "seat"];
      shell = pkgs.zsh;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      #extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
    };

    programs = {
      firefox.enable = true;
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
      waybar.enable = true;
      zsh.enable = true;
    };

    environment.systemPackages = with pkgs; [
      alacritty
      firefox
      hyprland
      gnome-icon-theme
      greetd.tuigreet
      ranger
      rofi-wayland
      seatd
      waybar
      wofi
      xdg-desktop-portal-gtk
      zsh
    ];

    security.polkit.enable = true;
  };
}
