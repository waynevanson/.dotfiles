{inputs, ...}: {
  imports = [inputs.nixvim.nixosModules.nixvim];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      number = true;
      relativenumber = true;
      ruler = true;
    };
    plugins.telescope.enable = true;
    plugins.vimux.enable = true;
    plugins.treesitter.enable = true;

    plugins.conform-nvim = {
      enable = true;
      settings = {
        lsp_format = "fallback";
        formatters_by_ft = {
          nix = ["alejandra"];
        };
      };
    };

    autoCmd = [
      {
        event = "BufWritePre";
        callback = {
          __raw = "function() require('conform').format({}) end";
        };
      }
    ];

    lsp.servers.ts_ls.enable = true;
    lsp.servers.kotlin_language_server.enable = true;
    lsp.servers.java_language_server.enable = true;
    lsp.servers.nil_ls.enable = true;
    lsp.servers.rust_analyzer.enable = true;
    lsp.servers.postgres_lsp.enable = true;
    lsp.servers.lua_ls.enable = true;
    lsp.servers.nginx_language_server.enable = true;
    lsp.servers.metals.enable = true;
    lsp.servers.html.enable = true;
    lsp.servers.jsonls.enable = true;
    lsp.servers.emmet_language_server.enable = true;
    lsp.servers.elixirls.enable = true;
    lsp.servers.docker_langauge_server.enable = true;
    lsp.servers.docker_compose_langauge_server.enable = true;
    lsp.servers.cssls.enable = true;
    lsp.servers.yamlls.enable = true;
  };
}
