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
    substituteInPlace cmake/FindLibM.cmake --replace "PATHS" "TEST_PATHS ${pkgs.libm}"
  '';

  nativeBuildInputs = [ 
    pkgs.buildPackages.cmake
    pkgs.openssl
    pkgs.pkg-config
    pkgs.libossp_uuid
    pkgs.buildPackages.libm
  ];

  LIBM_ROOT = pkgs.libm;
  LIBM_INCLUDE_DIRS= pkgs.libm;

  cmakeFlags = [
    "-DCMAKE_LIBM=${libm.out}"
    "-DCMAKE_C_FLAGS=-Wno-int-conversion"
    "-DCMAKE_LIBM_INCLUDE_DIRS=${libm.out}"
  ];
}
