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
        settings = pkgs.lib.recursiveUpdate settings theme;
      }).wrapper;
in {
  environment.systemPackages = [
    alacritty'
  ];
}
