{pkgs, ...}: {
  environment.pathsToLink = ["/share/zsh"];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };
  system.environment = with pkgs; [
    zsh-completions
    zsh-vi-mode
    zsh-nix-shell
    zsh-clipboard
    zsh-command-time
    zsh-autocomplete
    zsh-you-should-use
    zsh-fzf
  ];
}
