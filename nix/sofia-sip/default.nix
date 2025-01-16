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
    rev    = "0a50b8402fa5b6190a6c91c2e04dfe44a40de02c";
    sha256 = "1scx413d0qsipbrf4m86vl4v76p87yg9srarp5g8r9ihh78f84kk";
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
    pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
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
