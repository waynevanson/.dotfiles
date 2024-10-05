# Wayland & Sway
({
  pkgs,
  lib,
  ...
}: let
  config = ''
    # Brightness
    bindsym XF86MonBrightnessDown exec light -U 10
    bindsym XF86MonBrightnessUp exec light -A 10

    # Volume
    bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
    bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
    bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

    # give sway a little time to startup before starting kanshi.
    exec sleep 5; systemctl --user start kanshi.service
  '';
in {
  # foundation
  environment.systemPackages = with pkgs;
    lib.mkMerge [
      [
        # screenshot functionality
        grim
        # screenshot functionality
        slurp
        # wl-copy & wl-paste for copy paste from stdin/stdout
        wl-clipboard
        # notification system
        mako
      ]
    ];

  # brightness & volume
  users.users.waynevanson.extraGroups = lib.mkMerge [
    ["video"]
  ];

  # dbus and secrets
  services.gnome.gnome-keyring.enable = true;

  # enable sway wm
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  # allow passwords to work
  security.pam.services.swaylock = {};

  security.pam.loginLimits = [
    {
      domain = "@waynevanson";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
})
