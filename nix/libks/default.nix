{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  name = "libks";
  version = "2.0.6";

  src = pkgs.fetchFromGitHub {
    owner  = "freeswitch";
    repo   = "libks";
    rev    = "3bc8dd0524a865becdd98c3806735eb306fe0a73";
    sha256 = "0g9nahw5gq8pn72n0a8xlanwbrm5v4cycy88wf120ahx82xgx8nc";
  };

  patchPhase = ''
    substituteInPlace cmake/FindLibM.cmake --replace "NO_DEFAULT_PATH" ""
  '';

  nativeBuildInputs = [ 
    pkgs.cmake
    pkgs.openssl
    pkgs.pkg-config

  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libossp_uuid
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    pkgs.libuuid
  ];

  buildInputs = [
  ];

  cmakeFlags = [
    "-DCMAKE_C_FLAGS=-Wno-int-conversion"
    #"-DCMAKE_C_FLAGS=-I${pkgs.libossp_uuid.out}/include"
    "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
  ];
}
