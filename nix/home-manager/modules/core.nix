{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.modules.core = {
    enable = lib.mkEnableOption "core configuration";
  };

  config = lib.mkIf config.modules.core.enable {
    programs.home-manager.enable = true;

    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };

    home = {
      stateVersion = "24.11";
      file.".hushlogin".text = "";
    };

    home.activation.installGhostty = lib.mkIf pkgs.stdenv.isDarwin (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [[ ! -d ~/Applications/Ghostty.app ]]; then
          export GH_TOKEN=$(cat ${config.sops.secrets.github_token.path})
          ( cd /tmp && \
            ${lib.getExe pkgs.gh} release download -R mitchellh/ghostty tip -p 'ghostty-macos-universal.zip' --clobber && \
            rm -rf ~/Applications/Ghostty.app && \
            ${lib.getExe pkgs.unzip} -d ~/Applications ghostty-macos-universal.zip && \
            rm -f ghostty-macos-universal.zip ) || true
        fi
      ''
    );

  };
}
