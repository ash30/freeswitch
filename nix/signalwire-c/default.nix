{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "signalwire-c";
  version = "c432105788424d1ddb7c59aacd49e9bfa3c5e917";

  src = pkgs.fetchurl {
    url = "https://github.com/signalwire/signalwire-c/archive/refs/tags/v2.0.0.tar.gz";
    sha256 = "0yggz83658lb9pvsd01bc3wb6wa7i52g16yi2vv5ziy2n9vas5kr";
  };

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-Wno-int-conversion"
  ];

  buildInputs = [ 
    pkgs.cmake
    pkgs.pkg-config
    pkgs.openssl
    (pkgs.callPackage ../libks/default.nix { })
  ];

  postBuild = '' 
    echo "" > copyright
  ''; 
}
