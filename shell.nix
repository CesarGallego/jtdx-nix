{pkgs ? import <nixpkgs> {}}:
let
  jtdx = pkgs.qt5.callPackage ./default.nix {};
in
pkgs.mkShell {
  name = "mi_jtdx";

  buildInputs = [ jtdx ];
}

