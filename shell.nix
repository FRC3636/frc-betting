{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    julia-bin
    sqlite
    nushell
  ];
}
