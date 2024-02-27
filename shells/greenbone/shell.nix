let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

# TODO: create self containing flake
pkgs.mkShellNoCC {
  packages = with pkgs; [
    file
    libpcap
    hiredis
    cmake
    libnet
    curl
    redis
    pkg-config
    zlib
  ];
}

