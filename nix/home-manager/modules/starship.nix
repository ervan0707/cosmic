{ ... }:
{

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = true;
      scan_timeout = 10;

      format = "[╭─](color_white)$os$username$shell$hostname[](color_white)$directory$git_branch$git_status$azure$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nix_shell$nim$rust$scala$lua$php$python$ruby$dart$deno$kotlin$bun$swift$kubernetes$docker_context$line_break[╰─](color_white)$character";

      palette = "Gruvbox";

      palettes.Gruvbox = {
        color_bg = "#282828";
        color_fg = "#d5c4a1";
        color_black = "#928374";
        color_red = "#fb4934";
        color_green = "#b8bb26";
        color_yellow = "#fabd2f";
        color_blue = "#83a598";
        color_magenta = "#d3869b";
        color_cyan = "#8ec07c";
        color_white = "#ebdbb2";
      };

      os = {
        style = "bold italic fg:color_bg bg:color_white";
        disabled = false;
        format = "[ $symbol]($style)";
        symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      };

      shell = {
        disabled = false;
        fish_indicator = "󰈺 ";
        zsh_indicator = "zsh";
        bash_indicator = "";
        powershell_indicator = "";
        cmd_indicator = "";
        unknown_indicator = "mystery shell";
        style = "bold italic fg:color_bg bg:color_white";
        format = "[$indicator ]($style)";
      };

      username = {
        style_user = "bold italic fg:color_bg bg:color_white";
        style_root = "bold italic fg:color_bg bg:color_white";
        format = "[$user ]($style)";
        disabled = false;
        show_always = true;
        aliases.ss = "ervan";
      };

      hostname = {
        disabled = true;
        ssh_only = false;
        style = "bold italic fg:color_bg bg:color_white";
        format = "[$hostname ]($style)";
      };

      directory = {
        style = "fg:color_red bg:color_bg";
        truncation_length = 3;
        truncation_symbol = "…/";
        home_symbol = " ";
        read_only = "🔒";
        format = "[ $path ]($style)";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
        };
      };

      git_branch = {
        symbol = "";
        style = "fg:color_yellow bg:color_bg";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        disabled = false;
        style = "fg:color_yellow bg:color_bg";
        format = "([$all_status]($style))";
        conflicted = "([⚠️ $count](bold $color_red) )";
        ahead = "([⟫$count])";
        behind = "([⟪$count])";
        stashed = "([↪ $count](bold red) )";
        modified = "([ $count](bold yellow) )";
        staged = "([ $count](bold green) )";
        renamed = "([⇆ $count](bold blue) )";
        deleted = "([ $count](bold red) )";
        untracked = "([ $count](dimmed red) )";
      };

      azure = {
        disabled = true;
        symbol = "󰠅 ";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol($subscription) ]($style)";
      };

      c = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      elixir = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      elm = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      golang = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      gradle = {
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      haskell = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      java = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      julia = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      nodejs = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol$state( \\($name\\))]($style) ";
      };

      nim = {
        symbol = "󰆥";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      scala = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      lua = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      php = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      ruby = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      dart = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      deno = {
        symbol = "🦕";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      kotlin = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      bun = {
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol($version) ]($style)";
      };

      swift = {
        symbol = "";
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = "";
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "Dockerfile"
        ];
        style = "fg:color_cyan bg:color_bg";
        format = "[ $symbol $context ]($style)";
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾";
        style = "fg:color_cyan bg:color_bg";
        format = "[$symbol $context ($namespace)]($style)";
        contexts = [
          {
            context_pattern = ".*kind.*";
            style = "green";
          }
          {
            context_pattern = ".*lab.*";
            style = "green";
          }
          {
            context_pattern = ".*production.*";
            style = "(red)";
            context_alias = "production 🚨";
          }
        ];
        detect_folders = [ "umbrella" ];
      };

      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[ 󱝁](bold fg:color_cyan bg:color_bg)";
        error_symbol = "[ ](bold fg:color_red bg:color_bg)";
        vicmd_symbol = "[ ](bold fg:color_red bg:color_cyan)";
      };
    };
  };
}
