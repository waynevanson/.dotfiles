# steam
({
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks
  ];
})
