# Languages and lsp, on main mac these come from homebrew (see hosts/macbook-air)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dotnet-sdk_10
    csharp-ls

    nodejs
    typescript-language-server

    python3
    pyright

    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    gcc
    gnumake
    gdb

    vscode-langservers-extracted

    shellcheck
  ];
}
