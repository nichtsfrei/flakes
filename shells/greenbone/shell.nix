let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

# TODO: create self containing flake
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    file
    libpcap
    hiredis
    cmake
    libnet
    curl
    redis
    pkg-config
    zlib
    cmake
    glib
    json-glib
    gnutls
  ];
}

