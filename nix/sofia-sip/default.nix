{ pkgs ? import <nixpkgs> {} }:
let
isDarwin = pkgs.stdenv.isDarwin;
in
pkgs.stdenv.mkDerivation rec { 
  name = "sofia-sip";
  version = "1.13.17";

  src = pkgs.fetchFromGitHub {
    owner  = "freeswitch";
    repo   = "sofia-sip";
    rev    = "0106ad0e34a13485a4de79496589abf6949772dd";
    sha256 = "sha256-rFgCXKKH8p67PaI6IXm2PyhZcM2mlyT+oeqTspvR5hc=";
  };

  patchPhase = ''
    substituteInPlace Makefile.am --replace "/usr" ""
    substituteInPlace autogen.sh --replace "glibtoolize" "libtoolize"
  '';

  buildInputs = [ 
    pkgs.autoconf 
    pkgs.automake 
    pkgs.util-linux 
    pkgs.libtool 
    pkgs.libtiff
    pkgs.openssl
  ] ++ pkgs.lib.optionals isDarwin [
  ];

  configureFlags = [
     "--with-pic"
     " --with-glib=no"
     " --without-doxygen"
     " --disable-stun"
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  #CFLAGS="-g -ggdb --with-pic";
}
