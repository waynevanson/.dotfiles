{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    greetd.tuigreet
    seatd
    waybar
    alacritty
    rofi-wayland
    firefox
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;

  users.users.greeter = {
    isSystemUser = true;
    description = "Greetd login user";
    extraGroups = ["video" "audio" "seat"];
    shell = pkgs.bash;
  };

  users.users.waynevanson = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio" "input"];
  };

  services.dbus.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
