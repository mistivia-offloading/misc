{
  description = "Haskell project with cabal2nix and hoogle";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
        project = haskellPackages.callCabal2nix "mistivia" ./. {};
        devTools = with haskellPackages; [
          ghc
          cabal-install
          hoogle
        ];

      in
      {
        packages.default = project;

        devShells.default = pkgs.mkShell {
          buildInputs = devTools;
          
          shellHook = ''
            echo "Available commands:"
            echo "  cabal build     - Build the project"
            echo "  cabal test      - Run tests"
            echo "  hoogle          - Lookup Hoogle docs"
          '';
        };
      });
}
