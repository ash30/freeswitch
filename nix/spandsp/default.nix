{ pkgs ? import <nixpkgs> {} }:
let
isDarwin = pkgs.stdenv.isDarwin;
in
pkgs.stdenv.mkDerivation rec { 
  name = "spandsp";
  version = "3.0.9";

  src = pkgs.fetchFromGitHub {
    owner  = "freeswitch";
    repo   = "spandsp";
    rev    = "39cd63db350927b08a340f4c6394c58bb4a28a9d";
    sha256 = "0wmpi6gvznkrnvkpa3s1h44hcky09p38g27bdaipwgbb5svl9d1i";
  };

  nativeBuildInputs = [ 
    pkgs.keepBuildTree
    pkgs.autoconf 
    pkgs.automake 
    pkgs.util-linux 
    pkgs.libtool 
    pkgs.libtiff
    pkgs.libjpeg
    pkgs.which
  ];

  preConfigure = ''
    #./bootstrap.sh
    ls
    ./autogen.sh
  '';

  #CFLAGS="-g -ggdb --with-pic";

  patchPhase = ''
  '' + pkgs.lib.optionalString isDarwin ''
    substituteInPlace autogen.sh --replace "glibtoolize" "libtoolize"
  '';
}
