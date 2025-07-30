{pkgs, ...}: {
  # hyprland
  home.file."~/.config/hypr/hyprland.conf".source = ./hyprland.conf;
  wayland.windowManager.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
