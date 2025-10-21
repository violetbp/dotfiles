


{ pkgs, ... }:
let
  nix-inspect = pkgs.writeShellScriptBin "nix-inspect" ''
    read -ra EXCLUDED <<< "$@"
    EXCLUDED+=(''${NIX_INSPECT_EXCLUDE[@]:-})

    IFS=":" read -ra PATHS <<< "$PATH"

    read -ra PROGRAMS <<< \
      "$(printf "%s\n" "''${PATHS[@]}" | ${pkgs.gnugrep}/bin/grep "\/nix\/store" | ${pkgs.gnugrep}/bin/grep -v "\-man" | ${pkgs.perl}/bin/perl -pe 's/^\/nix\/store\/\w{32}-([^\/]*)\/bin$/\1/' | ${pkgs.findutils}/bin/xargs)"

    for to_remove in "''${EXCLUDED[@]}"; do
        to_remove_full="$(printf "%s\n" "''${PROGRAMS[@]}" | grep "$to_remove" )"
        PROGRAMS=("''${PROGRAMS[@]/$to_remove_full}")
    done

    read -ra PROGRAMS <<< "''${PROGRAMS[@]}"
    echo "''${PROGRAMS[@]}"
  '';
in
{
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "robbyrussell";
    };
  };


  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "[░▒▓](#a3aed2)[  ](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$nodejs$rust$golang$php[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)\n$character\n";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      directory = {
        format = "[ $path ]($style)([$read_only ]($read_only_style))";
        
        style = "fg:#e3e5e5 bg:#769ff0";
        read_only_style = "fg:#e3e5e5 bg:#769ff0";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        "Documents" = "󰈙";
        "Downloads" = "";
        "Music" = "";
        "Pictures" = "";
      };
      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };
      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
      };
      nodejs = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      golang = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      php = {
        symbol = "";
        style = "bg:#212736";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };

  # programs.starship.settings = {
  #     format =
  #       let
  #         git = "$git_branch$git_commit$git_state$git_status";
  #         cloud = "$aws$gcloud$openstack";
  #       in
  #       ''
  #         $username$hostname($shlvl)($cmd_duration) $fill ($nix_shell)$custom
  #         $directory(${git})(- ${cloud}) $fill $time
  #         $jobs$character
  #       '';


  #     # Core
  #     username = {
  #       format = "[$user]($style)";
  #       show_always = true;
  #     };
  #     hostname = {
  #       format = "[@$hostname]($style) ";
  #       ssh_only = false;
  #       style = "bold green";
  #     };
  #     shlvl = {
  #       format = "[$shlvl]($style) ";
  #       style = "bold cyan";
  #       threshold = 2;
  #       repeat = true;
  #       disabled = false;
  #     };
  #     cmd_duration = {
  #       format = "took [$duration]($style) ";
  #     };

     
  #     nix_shell = {
  #       format = "[($name \\(develop\\) <- )$symbol]($style) ";
  #       impure_msg = "";
  #       symbol = " ";
  #       style = "bold red";
  #     };
  #     custom = {
  #       nix_inspect = {
  #         disabled = false;
  #         when = "test -z $IN_NIX_SHELL";
  #         command = "${nix-inspect}/bin/nix-inspect kitty imagemagick ncurses user-environment";
  #         format = "[($output <- )$symbol]($style) ";
  #         symbol = " ";
  #         style = "bold blue";
  #       };
  #     };

  #     character = {
  #       error_symbol = "[~~>](bold red)";
  #       success_symbol = "[->>](bold green)";
  #       vimcmd_symbol = "[<<-](bold yellow)";
  #       vimcmd_visual_symbol = "[<<-](bold cyan)";
  #       vimcmd_replace_symbol = "[<<-](bold purple)";
  #       vimcmd_replace_one_symbol = "[<<-](bold purple)";
  #     };

  #     time = {
  #       format = "\\\[[$time]($style)\\\]";
  #       disabled = false;
  #     };

  #     # Cloud
  #     gcloud = {
  #       format = "on [$symbol$active(/$project)(\\($region\\))]($style)";
  #     };
  #     aws = {
  #       format = "on [$symbol$profile(\\($region\\))]($style)";
  #     };

  #     # Icon changes only \/
  #     aws.symbol = "  ";
  #     conda.symbol = " ";
  #     dart.symbol = " ";
  #     directory.read_only = " ";
  #     docker_context.symbol = " ";
  #     elixir.symbol = " ";
  #     elm.symbol = " ";
  #     gcloud.symbol = " ";
  #     git_branch.symbol = " ";
  #     golang.symbol = " ";
  #     hg_branch.symbol = " ";
  #     java.symbol = " ";
  #     julia.symbol = " ";
  #     memory_usage.symbol = " ";
  #     nim.symbol = " ";
  #     nodejs.symbol = " ";
  #     package.symbol = " ";
  #     perl.symbol = " ";
  #     php.symbol = " ";
  #     python.symbol = " ";
  #     ruby.symbol = " ";
  #     rust.symbol = " ";
  #     scala.symbol = " ";
  #     shlvl.symbol = "";
  #     swift.symbol = "ﯣ ";
  #     terraform.symbol = "行";
  #   };
  # };
}





/*
 { config, pkgs, ... }: {

programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      zsh_indicator = "[ZSH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

}
*/