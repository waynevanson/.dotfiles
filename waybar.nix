{pkgs, ...}: let
  style = ./waybar.css;
  config = ./waybar.jsonc;
in {
  programs.waybar = {
    inherit style;
    enable = true;
  };
  xdg.configFile."waybar/config.jsonc".source = config;
}
