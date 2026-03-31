let pkgs = import (builtins.fetchTarball {
  # Descriptive name to make the store path easier to identify
  name = "nixpkgs-25.05-darwin";
  url = "https://github.com/nixos/nixpkgs/archive/12c702c6157fbd004a7745055153162297a3d2ce.tar.gz"; # 10/10/25
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1qh818yx01w2x06ahf60p95b5xxd7r8d3q53384f3mrcnwmcb5yy";
}){ config.allowUnfree = true ;};
fs_drv = (pkgs.callPackage ./default.nix {});
in
pkgs.mkShell {
  inputsFrom = [ fs_drv ];
  buildInputs = [
    #pkgs.ccls 
    #pkgs.jq
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
