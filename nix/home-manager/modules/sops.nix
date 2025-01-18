{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.modules.sops = {
    enable = lib.mkEnableOption "sops configuration";
  };

  config = lib.mkIf config.modules.sops.enable {
    home = {
      packages = with pkgs; [ sops ];
    };
    sops = {
      age.keyFile = "${config._module.args.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = config._module.args.defaultSopsFile;
      defaultSopsFormat = "yaml";

      secrets = {
        email = { };
        username = { };
        codestats_api_key = { };
        github_token = { };
      };
    };
  };
}
