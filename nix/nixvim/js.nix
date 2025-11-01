{
  programs.nixvim = {
    lsp.servers.ts_ls.enable = true;

    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          javascript = ["prettier"];
          typescript = ["prettier"];
          typescriptreact = ["prettier"];
          javascriptreact = ["prettier"];
        };
      };
    };
  };
}
