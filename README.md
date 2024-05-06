# Ziguana (Zig learning material)

## Getting started

Zig is still in development and the language, compiler, build system, and standard library are still changing. For this reason we use Nix to provide a development shell. This allows us to pin the Zig compiler to a specific version allowing us to restore a projects environment in the future.

We also allow you to create a docker container with the development shell if you don't want to install Nix on your system. The docker container uses Nix to setup the project dependencies.

Dependencies:
Nix (optional): https://github.com/DeterminateSystems/nix-installer
Docker (optional): https://www.docker.com/

We first want to initialize a new project. A project template is available in the `./templates/zigshell' folder. If you don't have Nix installed locally copy the files from the `zigshell` folder into your project folder:

```bash
$ mkdir <new-project>
$ cd <new-project>
$ nix flake init -t github:urso/ziguana # alternatively copy the files from the templates/zigshell folder
$ git init
$ git add *
```

NOTE: We must initialize and add the nix files to the git repository, such that the Nix Flakes can find them.

(Optional build docker container):

```bash
$ chmod 700 ./dev/docker/*.sh # fix permissions
$ ./dev/docker/build.sh
```

### Start the development shell

Choose between Nix, Nix with direnv, Docker:
- Nix: `$ nix develop`
- Nix with direnv: `$ direnv allow`
- Docker: `$ ./dev/docker/run.sh nix develop`

KNOWN ISSUE (Docker on Desktop): When running Docker on Desktop the owner of
the workdir might be the root user, which can lead to problems when running
`nix develop`. In that case use `dev/docker/run.sh` and manually change the
ownership via `chmod dev ../workdir`. Now `nix develop` will start the
development shell.

### Initialize a zig project

To create a project in the current folder run:

```bash
$ zig init
```

Optionally update the project name in the `build.zig.zon` and `build.zig` files.

Build the project

```bash
$ zig build -freference-trace
```

Zig uses the `zig-cache` folder to store project dependencies like generated source files or object files. Next it installs all artifacts into the `zig-out` folder (use `-p <prefix>` to change the install prefix path):

```
$ find zig-out
```

Run the sample application:

```
$ ./zig-out/bin/workdir
All your codebase are belong to us.
Run `zig build test` to run the tests.
```

Run testsuite:

```
$ zig build test
```

## Zig references

- Home: https://ziglang.org/

- Community:
  - News: https://zig.news/
  - Discord: https://discord.com/invite/zig
  - Official Forum: https://ziggit.dev/

- Documentation:
  - Language Reference: https://ziglang.org/documentation/master/
  - Standard Library: https://ziglang.org/documentation/master/std/

- Learning:
  - https://www.openmymind.net/learning_zig/
  - https://zig.guide/
  - [Compiler and build system internals](https://mitchellh.com/zig) by Mitchel Hashimoto. A little dated, but still good introduction into the Compiler and how comptime is actually evaluated.

- Projects:
  - [awesome zig](https://github.com/C-BJ/awesome-zig): List or projects/libraries using Zig.
  - [Zig compiler](https://github.com/ziglang/zig)
  - [Tigerbeetle](https://tigerbeetle.com/): Financial transactions database
  - [Pydust](https://github.com/fulcrum-so/ziggy-pydust): Write Python extensions in Zig. Some nice comptime usage.
  - [Mach](https://machengine.org/): Game engine

## Nix references

- [Nix language basics](https://nix.dev/tutorials/nix-language)

- References:
  - [Builtin functions](https://nixos.org/manual/nix/stable/language/builtins.html)
  - [Nixpgks library functions](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library)

- Nix Flakes: We use Nix flakes to declare dependencies and create the development environment
  - [Zero to Nix](https://zero-to-nix.com/concepts/flakes)
  - [Nix Flakes book](https://nixos-and-flakes.thiscute.world/)

- [Flake parts](https://flake.parts/): Dependency used to structure the `flake.nix` file.

- Nix concepts (language patterns):
  - Package authoring:
    - Derivations: Nix packaging is based on derivations. Nix also provides a set of packaging environments (with build tools being available of the box)
      - https://nixos.org/manual/nix/stable/language/derivations.html
      - https://nixos.org/guides/nix-pills/06-our-first-derivation
      - https://nixos.org/guides/nix-pills/07-working-derivation
    - [callPackage](https://nixos-and-flakes.thiscute.world/nixpkgs/callpackage)
  - overrides: common pattern to modify a derivation/package (e.g. change build flags)
    - https://nixos-and-flakes.thiscute.world/nixpkgs/overriding
    - https://ryantm.github.io/nixpkgs/using/overrides/
  - overlays: mechanism to add or replace packages or utility functions to a nixpkgs instance. Often used in Flakes to introduce packages from other repositories. Flakes can export overlays, allowing dependents to reuse package definitions from other repositories (e.g. zig-overlay).
    - https://nixos.wiki/wiki/Overlays
