{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    stow
    volta
    discord
  ];
}
