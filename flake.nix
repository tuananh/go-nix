{
  description = "go-nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in with pkgs; rec {
        # make shell
        devShell = mkShell {
          name = "go-nix";
          nativeBuildInputs = [ go ];
        };

        # build https://nixos.wiki/wiki/Go
        packages.app = buildGoModule {
            name = "go-nix-app";
            src = ./.;
            # TODO (tuananh) figure out how to calculate this
            # How do I know? I just fill in a dummy one like `000000000000000`
            # got the error message and fill the expected sha here =)))
            vendorSha256 = "pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };

        # default package when not specified
        defaultPackage = packages.app;
      }
    );
}
