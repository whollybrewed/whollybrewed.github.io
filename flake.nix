{
  description = "Ruby dev environment for Jekyll";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        ruby = pkgs.ruby_3_3;

      in {
        devShells.default = pkgs.mkShell {
          packages = [
            ruby
            pkgs.nodejs
          ];

          shellHook = ''
            export GEM_HOME=$PWD/.gems
            export GEM_PATH=$GEM_HOME
            export PATH=$GEM_HOME/bin:$PATH
            export RUBYOPT="-W0"
            export PS1="(nix) $PS1"
            echo "Installed nix packages:"
              for p in $buildInputs $nativeBuildInputs; do
                echo "  - $(basename $p | sed 's/^[a-z0-9]*-//')"
              done
            echo -e "\e[1;33mWelcome to nix shell\e[0m"
          '';
        };
      });
}
