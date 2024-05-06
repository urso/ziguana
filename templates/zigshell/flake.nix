{
  description = "Zig development shell";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.557957.tar.gz";

    parts.url = "github:hercules-ci/flake-parts";

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig-overlay.follows = "zig-overlay";
    };
  };

  outputs = inputs: let
    zig-overlay = inputs.zig-overlay.overlays.default;
    zls-overlay = _final: prev: {
      zls = inputs.zls.packages.${prev.system}.zls;
    };
    utils-overlay = _final: prev: {
      mkScripts = scripts:
        prev.lib.mapAttrsToList (name: script: prev.writeShellScriptBin name script)
        scripts;
    };
  in
    inputs.parts.lib.mkFlake { inherit inputs; } {
      debug = true;

      # Supported system for which we want to be able to build the project on.
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        config,
        lib,
        pkgs,
        system,
        ...
      }:
      {
        # Ensure that 'pkgs' has the dependencies from the pgzx flake available.
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [zig-overlay zls-overlay utils-overlay];
          config = {
            # extra configurations
            #allowBroken = true;
            #allowUnfree = true;
          };
        };

        devShells.default = pkgs.mkShell ((import ./devshell.nix) {
          inherit lib;
          inherit pkgs;
          inherit system;
        });
      };
    };
}
