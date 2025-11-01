{
  inputs,
  pkgs,
  ...
}: let
  settings = {};
  theme = builtins.fromTOML (builtins.readFile ./catppuccin-mocha.toml);
  alacritty' =
    (inputs.wrappers.wrapperModules.alacritty.apply
      {
        inherit pkgs;
        env = {
          TERM = "xterm-256color";
        };

        settings = pkgs.lib.recursiveUpdate settings theme;
      }).wrapper;
in {
  environment.systemPackages = [
    alacritty'
  ];
}
