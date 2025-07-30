{pkgs, ...}: {
  buildInputs = with pkgs; [
    clang
    llvmPackages.bintools
    rustup
  ];
  shellHook = ''
    export PATH=$PATH:''${CARGO_HOME:-~/.cargo}/bin
  '';
  BINDGEN_EXTRA_CLANG_ARGS =
    (builtins.map (a: ''-I"${a}/include"'') [
      pkgs.glibc.dev
    ])
    ++ [
      ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
      ''-I"${pkgs.glib.dev}/include/glib-2.0"''
      ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
    ];
  LIBCLANG_PATH = pkgs.lib.makeLibraryPath [pkgs.llvmPackages_latest.libclang.lib];
}
