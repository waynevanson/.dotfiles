{pkgs, ...}: {
  programs.nixvim.plugins = {
    telescope.enable = true;
    web-devicons.enable = true;
  };
  environment.systemPackages = with pkgs; [ripgrep];
}
