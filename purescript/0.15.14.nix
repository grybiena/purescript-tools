{ pkgs }:

let
  inherit (pkgs) system;
  version = "0.15.14";

  urls = {
    "x86_64-linux" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/linux64.tar.gz";
      hash = "sha256:0i717gb4d21m0pi1k90g5diq3yja1pwlw6ripv0d70jdnd9gsdl9";
    };
    "x86_64-darwin" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/macos.tar.gz";
      hash = "sha256:01973wiybblfbgjbqrhr8435y6jk6c94i667nr3zxkxy4np3lv3q";
    };
    "aarch64-linux" = {
      url = "https://github.com/purescript/purescript/releases/download/v${version}/linux-arm64.tar.gz";
      hash = "sha256-mO4X1A4bq/MzlC8tSTlZWA/FaWWFd/L7StUQb+0XMGY=";
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
