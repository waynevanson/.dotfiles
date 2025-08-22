{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  options.services.wayland.desktop' = {
    enable = lib.mkEnableOption "Hyprland Customized Desktop environment";
  };

  config = lib.mkIf config.services.wayland.desktop'.enable {
    # messaging on a session
    services.dbus.enable = true;

    services.seatd.enable = true;

    # allow system to store passwords and credentials for programs like git
    security.pam.services.greetd.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
      # can't get to terminal without this?
      alacritty

      # can't accces programs without this
      wofi

      pkgs.tuigreet

      inputs.hyprland.packages.${pkgs.system}.hyprland
      inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
    ];

    # allow unpriv programs to talk to priv ones
    security.polkit.enable = true;

    services.greetd = {
      enable = true;
      settings = rec {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --time --cmd Hyprland";
          user = "greeter";
        };
        initial_session = default_session;
      };
    };

    users.users.greeter = {
      isSystemUser = true;
      description = "Greetd login user";
      extraGroups = ["video" "audio" "seat"];
      shell = pkgs.zsh;
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    # https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/nixos/modules/programs/zsh/zsh.nix
    # System wide and doesn't interfere with dotfiles.
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      enableLsColors = true;
    };
  };
}
