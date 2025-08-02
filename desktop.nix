# hyprland + waybar + files + terminal + greeter
{
  pkgs,
  nixpkgs,
  config,
  lib,
  ...
}: {
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
    extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
  };

  programs = {
    firefox.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    greetd.tuigreet
    seatd
    waybar
    alacritty
    rofi-wayland
    wofi
    firefox
    zsh
    ranger
    xorg.xcursorthemes
  ];

  security.polkit.enable = true;
}
