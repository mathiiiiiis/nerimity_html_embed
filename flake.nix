{
  description = "dev env for nerimity_html_embed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/fe13242281a67641c0102cdb1087f0ebe586c7df";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.flutter347
          pkgs.fish
        ];

        shellHook = ''
          export FLUTTER_ROOT="$(dirname "$(dirname "$(readlink -f "$(command -v flutter)")")")"
          flutter config --no-analytics >/dev/null 2>&1 || true

          if [[ $- == *i* && -z ''${IN_NERIMITY_HTML_EMBED_SHELL:-} ]]; then
            export IN_NERIMITY_HTML_EMBED_SHELL=1
            export SHELL="$(command -v fish)"
            exec fish
          fi
        '';
      };
    };
}
