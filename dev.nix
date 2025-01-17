let pkgs = import (builtins.fetchTarball {
  name = "nixpkgs-unstable";
  url = "https://github.com/nixos/nixpkgs/archive/68c9ed8bbed9dfce253cc91560bf9043297ef2fe.tar.gz";
  # Hash obtained using `nix-prefetch-url --unpack <url>`
  sha256 = "1zwwji3nhn9zdmck2bllqjbswsr7r30q8fbggw8y1j2ymsvz29jg";
}) { config.allowUnfree = true; };
fs_drv = (pkgs.callPackage ./default.nix { inherit pkgs; });
in
pkgs.mkShell {
  inputsFrom = [ fs_drv ];
  buildInputs = [
    pkgs.ccls 
    pkgs.jq
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
