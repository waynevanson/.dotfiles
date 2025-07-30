{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    dive
    podman-tui
    podman-compose
  ];
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
