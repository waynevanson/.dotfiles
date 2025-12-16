{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;
    };

    # fix this
    keymaps = [
      {
        mode = ["n"];
        key = "<space>fd";
        action.__raw = "require('telescope.builtin').find_files";
      }
      {
        key = "<space>fg";
        mode = ["n"];
        action.__raw = "require('telescope.builtin').live_grep";
      }
      {
        key = "<space>fh";
        mode = ["n"];
        action.__raw = "require('telescope.builtin').help_tags";
      }
    ];
  };
  environment.systemPackages = with pkgs; [ripgrep fzf fd];
}
