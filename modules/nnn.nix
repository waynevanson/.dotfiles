{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs;
    lib.mkMerge [[nnn]];
}
