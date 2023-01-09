with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    ghc
    cabal-install
    haskell-language-server
    zlib # required for servant server
    postgresql
  ];
}
