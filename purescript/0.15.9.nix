{ pkgs }:

let
  inherit (pkgs) system;
  version = "0.15.9";

  urls = {
    "x86_64-linux" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/linux64.tar.gz";
      hash = "sha256-A8v0N75PGMT4fP9v3gUnm4ZmZDz7D+BM0As1TaeNS2U=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/macos.tar.gz";
      hash = "sha256-0000000000000000000000000000000000000000000=";
    };
    "aarch64-linux" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/linux-arm64.tar.gz";
      hash = "sha256-4erC9rG4CRPHg9Os9fLYOfLbE/elkXaXaKXYD5J8EsE=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/macos-arm64.tar.gz";
      hash = "sha256-0000000000000000000000000000000000000000000=";
    };
  };

  src =
    if builtins.hasAttr system urls then
      (pkgs.fetchurl urls.${system})
    else if system == "aarch64-darwin" then
      let
        useArch = "x86_64-darwin";
        msg = "Using the non-native ${useArch} binary. While this binary may run under Rosetta 2 translation, no guarantees can be made about stability or performance.";
      in
      pkgs.lib.warn msg (pkgs.fetchurl urls.${useArch})
    else
      throw "Architecture not supported: ${system}";
in
import ./mkPursDerivation.nix {
  inherit pkgs version src;
}
