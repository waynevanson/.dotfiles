{inputs, ...}: let
  js = {
    programs.nixvim = {
      lsp.servers.ts_ls = {
        enable = true;
        #filetypes = [
        #  "javascript"
        #  "javascriptreact"
        #  "typescript"
        #  "typescriptreact"
        #];
      };

      plugins.conform-nvim = {
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
  };
in {
  imports = [
    inputs.nixvim.nixosModules.nixvim
    js
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      number = true;
      relativenumber = true;
      ruler = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
        integrations = {
          gitsigns = true;
          treesitter = true;
          notify = true;
        };
      };
    };

    plugins.gitsigns = {
      enable = true;
    };

    plugins.telescope.enable = true;
    plugins.vimux.enable = true;
    plugins.treesitter.enable = true;
    plugins.tmux-navigator = {
      enable = true;
    };

    plugins.conform-nvim = {
      enable = true;
      settings = {
        lsp_format = "fallback";
        formatters_by_ft.nix = ["alejandra"];
      };
    };

    autoCmd = [
      # format on save
      {
        event = "BufWritePre";
        callback = {__raw = "function() require('conform').format({}) end";};
      }
    ];

    lsp.servers.rust_analyzer.enable = true;
    lsp.servers.postgres_lsp.enable = true;
    lsp.servers.html.enable = true;
    lsp.servers.jsonls.enable = true;
    lsp.servers.emmet_language_server.enable = true;
    lsp.servers.docker_langauge_server.enable = true;
    lsp.servers.docker_compose_langauge_server.enable = true;
    lsp.servers.cssls.enable = true;
    lsp.servers.yamlls.enable = true;

    lsp.servers.elixirls.enable = false;
    lsp.servers.lua_ls.enable = false;
    lsp.servers.nginx_language_server.enable = false;
    lsp.servers.metals.enable = false;
    lsp.servers.kotlin_language_server.enable = false;
    lsp.servers.java_language_server.enable = false;
    lsp.servers.nil_ls.enable = false;
  };
}
