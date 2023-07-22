{
  description = "kdesvn flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: 
    let pkgs = import nixpkgs {
        inherit system;

      };
      kdesvn = (with pkgs; stdenv.mkDerivation {
        pname = "kdesvn";
        version = "2.0.0";
        src = fetchgit {
          url = "https://invent.kde.org/sdk/kdesvn.git";
          rev = "v2.0.0";
          sha256 = "rLVstXXHj5kx57kiDD9RWUV0cJ7TXCPO6ByuJRh1KFs=";
        };
        patches = [
          ./import.patch
        ];
        buildInputs = [
          subversionClient
          subversionClient.dev

          apr
          aprutil

          libsForQt5.kdbusaddons
          libsForQt5.kdoctools
          libsForQt5.ki18n
          libsForQt5.kiconthemes
          libsForQt5.kitemviews
          libsForQt5.kjobwidgets
          libsForQt5.kio
          libsForQt5.knotifications
          libsForQt5.kparts
          libsForQt5.kservice
          libsForQt5.ktexteditor
          libsForQt5.kwallet
          libsForQt5.kwidgetsaddons
        ];
        nativeBuildInputs = [
          clang
          cmake
          extra-cmake-modules
          qt5.wrapQtAppsHook
        ];
        cmakeFlags = [
          # svn includes are not found otherwise...
          "-DSUBVERSION_INCLUDE_DIR=${subversionClient.dev}/include/subversion-1"
        ];
        buildPhase = "make -j $NIX_BUILD_CORES";
      });
    in rec {
      packages.kdesvn = kdesvn;
      packages.default = packages.kdesvn;
      apps.kdesvn = flake-utils.lib.mkApp {
        drv = packages.default;
      };
      app.default = apps.kdesvn;
      devShells.default = pkgs.mkShell {
        buildInputs = [
          kdesvn
        ];
      };
    }
  );
}
