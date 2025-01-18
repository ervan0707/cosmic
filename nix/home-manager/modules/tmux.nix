{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  gruvbox_theme = pkgs.tmuxPlugins.gruvbox.overrideAttrs (_: {
    src = inputs.tmux-gruvbox;
  });
in
{
  options.modules.tmux = {
    enable = lib.mkEnableOption "tmux configuration";
  };

  config = lib.mkIf config.modules.tmux.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      terminal = "tmux-256color";
      shell = "${pkgs.fish}/bin/fish";
      prefix = "C-x";

      extraConfig = ''
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Start window indexing at 1
        set -g base-index 1

        # Start pane indexing at 1
        setw -g pane-base-index 1

        # Mouse works as expected
        set-option -g mouse on
        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        set-option -g status on
        set-option -g status-position top

        run ${gruvbox_theme}/share/tmux-plugins/gruvbox/gruvbox-tpm.tmux
        set -g @tmux-gruvbox 'dark256'
      '';
    };
  };
}
