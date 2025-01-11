{
  description = "mMinimalist Configurable Homelab Start Page";

  inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs =
    { self
    , nixpkgs
    ,
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      version = "0.0.3";
      pname = "lkb";
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          ${pname} = pkgs.stdenv.mkDerivation {
            inherit pname;
            inherit version;
            src = ./.;
            buildInputs = [ pkgs.gcc ];
            buildPhase = "gcc -O3 -Wall -o lkbd daemon.c";
            propagatedBuildInputs = [ pkgs.netcat ];
            installPhase = ''
              mkdir -p $out/bin
              mv lkbd $out/bin/lkbd
              cp lkb  $out/bin/lkb
            '';
          };
        });
      devShell = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        with pkgs;
        mkShell {
          buildInputs = [ gcc clang-tools netcat ];
        });
  };
}
