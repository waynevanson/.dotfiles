{pkgs, ...}: {
  users.extraGroups.docker.members = ["waynevanson"];

  virtualisation.docker = {
    autoPrune.enable = true;
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
