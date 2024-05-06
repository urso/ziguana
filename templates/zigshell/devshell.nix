{
  pkgs,
  ...
}: let
  menu = ''
  Zig development shell
  =====================

  menu: Print this message.
  root: Change directory to project root.

  Initialize Zig project
  $ zig init

  Build Zig program:
  $ zig build -freference-trace

  Run Zig tests:
  $ zig test -freference-trace

  Format all Zig code:
  $ zig fmt .

  Clean build cache:
  $ rm -fR zig-cache
  '';

  scripts = pkgs.mkScripts {
    menu = ''
      cat <<EOF
      ${menu}
      EOF
    '';
  };
in {
  packages =
    scripts
    ++ [
      pkgs.zigpkgs.master
      pkgs.zls
    ];

    shellHook = ''
      export PRJ_ROOT=$PWD
      alias root='cd $PRJ_ROOT'
    '';
}
