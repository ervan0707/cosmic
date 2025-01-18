{ pkgs }:
let
  inherit (import ./lib/shell.nix { inherit pkgs; }) mkShellConfig;

  # Custom luarocks packages if needed
  customLuaPackages = with pkgs.luaPackages; [
    # luacheck # Linting
    # luaformatter # Formatting
    # luasocket # Networking
    # luasec # SSL/TLS support
    # penlight # Common algorithms and data structures
    # inspect # Human-readable table serialization
    # busted # Unit testing
  ];
in
mkShellConfig {
  name = "lua-dev";

  packages =
    with pkgs;
    [
      # Lua interpreter and package manager
      lua
      luajit # LuaJIT for better performance
      luarocks

    ]
    ++ customLuaPackages;

  # Environment variables
  env = {
    LUA_PATH = "./?.lua;./?/init.lua";
    LUA_CPATH = "./?.so;./?/init.so";
  };

  shellHook = ''
    echo "🌙 Welcome to Lua development environment!"
    echo "Available tools:"
    echo "  - lua: $(lua -v)"
    echo "  - luajit: $(luajit -v)"
    echo "  - luarocks: $(luarocks --version)"
    echo "  - stylua: $(stylua --version)"
    echo ""
    echo "LSP server is available via lua-language-server"
    echo "Formatter available via stylua"
    echo "Linting available via selene and luacheck"
  '';

}
