{createDefaultExports, ...}: {
  imports = [(createDefaultExports ./.)];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true;
    };
    clipboard.register = "unnamedplus";

    plugins.gitsigns.enable = true;
    plugins.vimux.enable = true;
    plugins.direnv.enable = true;
    plugins.treesitter.enable = true;
    plugins.tmux-navigator.enable = true;

    lsp.servers.nil.enable = true;
    lsp.servers.ts_ls.enable = true;
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
