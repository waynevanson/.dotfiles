# docker
({
  pkgs,
  lib,
  config,
  ...
}: {
  users.users.waynevanson.extraGroups =
    lib.mkMerge [["docker"]];

  # Actually turn it on.
  virtualisation.docker.enable = true;

  # Add the packages.
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
})
