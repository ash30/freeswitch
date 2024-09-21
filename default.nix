{ pkgs ? import <nixpkgs> {} }:
let 
isDarwin = pkgs.stdenv.isDarwin;
in
pkgs.stdenv.mkDerivation rec { 
  name = "freeswitch";
  version = "1.10.12";

  src = ./.;
  #dontUnpack = true;

  buildInputs = [ 
    pkgs.pkg-config
    pkgs.libtool
    pkgs.autoconf 
    pkgs.automake 
    pkgs.util-linux 

    # core
    pkgs.pcre
    pkgs.libedit
    pkgs.nasm
    pkgs.yasm
    pkgs.libossp_uuid

    # private 
    (pkgs.callPackage ./nix/spandsp { })
    (pkgs.callPackage ./nix/libks { })
    (pkgs.callPackage ./nix/sofia-sip { })
    (pkgs.callPackage ./nix/signalwire-c{ })

    # general
    pkgs.openssl
    pkgs.zlib

    # core codecs
    pkgs.libogg
    pkgs.speex
    pkgs.speexdsp
    pkgs.libvpx

    # 
    pkgs.libsndfile
    pkgs.libpcap
    pkgs.libopus
    pkgs.libjpeg
    pkgs.libtiff
    pkgs.sqlite
    pkgs.curl
    pkgs.ldns
    pkgs.python3
    pkgs.perl

  ] ++ pkgs.lib.optionals isDarwin [
    pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  configureFlags = [
    "--disable-libvpx"
  ];

  #CFLAGS="-g -ggdb --with-pic";

  patchPhase = ''
    substituteInPlace Makefile.am --replace "/usr" ""
  '';
}
