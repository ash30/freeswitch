let pkgs = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz)
 { config.allowUnfree = true; };
fs_drv = (pkgs.callPackage ./default.nix {});
in
pkgs.mkShell {
  inputsFrom = [ fs_drv ];
  buildInputs = [
    pkgs.ccls 
    pkgs.jq
    pkgs.pjsip
  ];

  preConfigure = fs_drv.preConfigure;
  configureFlags = fs_drv.configureFlags;

  shellHook = ''
  export prefix=$(pwd)/inst
  configureFlags+=" --prefix=$prefix"
  PKG_CONFIG_PATH=$prefix/lib/pkgconfig:$PKG_CONFIG_PATH
  PATH=$prefix/bin:$PATH

  out=$(mktemp -d)
  '';
}
