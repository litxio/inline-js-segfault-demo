{
  description = "Demo of segfault with inline-js";
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system overlays; };
      overlays = [ haskellNix.overlay
        (final: prev: {
          # This overlay adds our project to pkgs
          segfault-demo =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc8107";
              shell.tools = {
                cabal = {};
                hlint = {};
                haskell-language-server = {};
              };
              shell.nativeBuildInputs = [pkgs.nodejs];
            };
        })
      ];
      flake = pkgs.segfault-demo.flake {
      };
    in builtins.trace flake (flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."segfault-demo:exe:segfault-demo-exe";
    }));
}
