{
  lib,
  pkgs,
  ...
}: {
  environment.variables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ./init.vim;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [nvim-treesitter.withAllGrammars];
  };
}
