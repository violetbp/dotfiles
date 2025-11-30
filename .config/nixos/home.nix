{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "vboysepe";
  home.homeDirectory = "/home/vboysepe";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and (not) dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 22;
    # "Xft.dpi" = 172;
  };
  xdg.portal = {
    # example with hyprland
    configPackages = [ pkgs.niri ];
    # has a file with /nix/store/...-hyprland-.../share/xdg-desktop-portal/hyprland-portals.conf
    # 1 │ [preferred]
    # 2 │ default=hyprland;gtk
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    # hugo # static site generator
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  xdg.mimeApps = {
    enable = true;
    
    defaultApplications = {
      "text/html"                       = "app.zen_browser.zen.desktop";
      "x-scheme-handler/http"           = "app.zen_browser.zen.desktop";
      "x-scheme-handler/https"          = "app.zen_browser.zen.desktop";
      "x-scheme-handler/about"          = "app.zen_browser.zen.desktop";
      "x-scheme-handler/unknown"        = "app.zen_browser.zen.desktop";
      "x-scheme-handler/chrome"         = "app.zen_browser.zen.desktop";
      "application/x-extension-htm"     = "app.zen_browser.zen.desktop";
      "application/x-extension-html"    = "app.zen_browser.zen.desktop";
      "application/x-extension-shtml"   = "app.zen_browser.zen.desktop";
      "application/xhtml+xml"           = "app.zen_browser.zen.desktop";
      "application/x-extension-xhtml"   = "app.zen_browser.zen.desktop";
      "application/x-extension-xht"     = "app.zen_browser.zen.desktop";
      "x-scheme-handler/webcal"         = "app.zen_browser.zen.desktop";
      "x-scheme-handler/mailto"         = "app.zen_browser.zen.desktop";


      "text/plain"                      = "org.kde.kwrite.desktop";
      "x-scheme-handler/tg"             = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite"        = "org.telegram.desktop.desktop";
      "x-scheme-handler/sgnl"           = "signal.desktop";
      "x-scheme-handler/signalcaptcha"  = "signal.desktop";
      "image/jpeg"                      = "feh.desktop";
      "image/png"                       = "feh.desktop";
      "image/gif"                       = "feh.desktop";
      "image/svg+xml"                   = "feh.desktop";
      "image/tiff"                      = "feh.desktop";
      "image/avif"                      = "feh.desktop";
      "image/webp"                      = "feh.desktop";
      "image/jp2"                       = "feh.desktop";
            
      "video/1d-interleaved-parityfec" 		= "vlc.desktop";					
      "video/3gpp" 						            = "vlc.desktop";
      "video/3gpp2" 					            = "vlc.desktop";
      "video/3gpp-tt" 				            = "vlc.desktop";
      "video/AV1" 						            = "vlc.desktop";
      "video/BMPEG" 					            = "vlc.desktop";
      "video/BT656" 					            = "vlc.desktop";
      "video/CelB" 						            = "vlc.desktop";
      "video/DV" 						              = "vlc.desktop";
      "video/encaprtp" 				            = "vlc.desktop";
      "video/evc" 						            = "vlc.desktop";
      "video/example" 				            = "vlc.desktop";
      "video/FFV1" 						            = "vlc.desktop";
      "video/flexfec" 				            = "vlc.desktop";
      "video/H261" 						            = "vlc.desktop";
      "video/H263" 						            = "vlc.desktop";
      "video/H263-1998" 			            = "vlc.desktop";
      "video/H263-2000" 			            = "vlc.desktop";
      "video/H264" 						            = "vlc.desktop";
      "video/H264-RCDO" 			            = "vlc.desktop";
      "video/H264-SVC" 				            = "vlc.desktop";
      "video/H265" 						            = "vlc.desktop";
      "video/H266" 						            = "vlc.desktop";
      "video/iso.segment" 		            = "vlc.desktop";
      "video/JPEG" 						            = "vlc.desktop";
      "video/jpeg2000" 				            = "vlc.desktop";
      "video/jpeg2000-scl" 		            = "vlc.desktop";
      "video/jxsv" 						            = "vlc.desktop";
      "video/lottie+json" 		            = "vlc.desktop";
      "video/matroska" 				            = "vlc.desktop";
      "video/matroska-3d" 		            = "vlc.desktop";
      "video/mj2" 						            = "vlc.desktop";
      "video/MP1S" 						            = "vlc.desktop";
      "video/MP2P" 					              = "vlc.desktop";
      "video/MP2T" 						            = "vlc.desktop";
      "video/mp4" 						            = "vlc.desktop";
      "video/MP4V-ES" 				            = "vlc.desktop";
      "video/MPV" 						            = "vlc.desktop";
      "video/mpeg" 						            = "vlc.desktop";
      "video/mpeg4-generic" 	            = "vlc.desktop";
      "video/nv" 						              = "vlc.desktop";
      "video/ogg" 						            = "vlc.desktop";
      "video/parityfec" 			            = "vlc.desktop";
      "video/pointer" 				            = "vlc.desktop";
      "video/quicktime" 			            = "vlc.desktop";
      "video/raptorfec" 			            = "vlc.desktop";
      "video/raw" 						            = "vlc.desktop";
      "video/rtp-enc-aescm128"            = "vlc.desktop";
      "video/rtploopback" 		            = "vlc.desktop";
      "video/rtx" 						            = "vlc.desktop";
      "video/scip" 						            = "vlc.desktop";
      "video/smpte291" 				            = "vlc.desktop";
      "video/SMPTE292M" 			            = "vlc.desktop";
      "video/ulpfec" 					            = "vlc.desktop";
      "video/vc1" 						            = "vlc.desktop";
      "video/vc2" 						            = "vlc.desktop";
      "video/vnd.blockfact.factv" 				= "vlc.desktop";			
      "video/vnd.CCTV" 							      = "vlc.desktop";
      "video/vnd.dece.hd" 					  		= "vlc.desktop";
      "video/vnd.dece.mobile" 			  		= "vlc.desktop";
      "video/vnd.dece.mp4" 						  	= "vlc.desktop";
      "video/vnd.dece.pd" 						  	= "vlc.desktop";
      "video/vnd.dece.sd" 							  = "vlc.desktop";
      "video/vnd.dece.video" 							= "vlc.desktop";
      "video/vnd.directv.mpeg" 						= "vlc.desktop";
      "video/vnd.directv.mpeg-tts" 				= "vlc.desktop";
      "video/vnd.dlna.mpeg-tts" 					= "vlc.desktop";
      "video/vnd.dvb.file" 					  		= "vlc.desktop";
      "video/vnd.fvt" 							      = "vlc.desktop";
      "video/vnd.hns.video" 							= "vlc.desktop";
      "video/vnd.iptvforum.1dparityfec-1010" 	 = "vlc.desktop";
      "video/vnd.iptvforum.1dparityfec-2005" 	 = "vlc.desktop";
      "video/vnd.iptvforum.2dparityfec-1010" 	 = "vlc.desktop";
      "video/vnd.iptvforum.2dparityfec-2005" 	 = "vlc.desktop";
      "video/vnd.iptvforum.ttsavc"             = "vlc.desktop";
      "video/vnd.iptvforum.ttsmpeg2"           = "vlc.desktop";
      "video/vnd.motorola.video"               = "vlc.desktop";
      "video/vnd.motorola.videop"              = "vlc.desktop";
      "video/vnd.mpegurl"                      = "vlc.desktop";
      "video/vnd.ms-playready.media.pyv"       = "vlc.desktop";
      "video/vnd.nokia.interleaved-multimedia" = "vlc.desktop";
      "video/vnd.nokia.mp4vr"                  = "vlc.desktop";
      "video/vnd.nokia.videovoip"              = "vlc.desktop";
      "video/vnd.objectvideo"                  = "vlc.desktop";
      "video/vnd.planar"                       = "vlc.desktop";
      "video/vnd.radgamettools.bink"           = "vlc.desktop";
      "video/vnd.radgamettools.smacker"        = "vlc.desktop";
      "video/vnd.sealed.mpeg1"                 = "vlc.desktop";
      "video/vnd.sealed.mpeg4"                 = "vlc.desktop";
      "video/vnd.sealed.swf"                   = "vlc.desktop";
      "video/vnd.sealedmedia.softseal.mov"     = "vlc.desktop";
      "video/vnd.uvvu.mp4"                     = "vlc.desktop";
      "video/vnd.youtube.yt"                   = "vlc.desktop";
      "video/vnd.vivo"                         = "vlc.desktop";
      "video/VP8"                              = "vlc.desktop";
      "video/VP9"                              = "vlc.desktop";
      

    };
  };

  # niri notifications
  services.swaync = {
      enable = true;
      settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
      };

      style = ''
        .notification-row {
          outline: none;
        }
        
        .notification-row:focus,
        .notification-row:hover {
          background: @noti-bg-focus;
        }
        
        .notification {
          border-radius: 12px;
          margin: 6px 12px;
          box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
            0 2px 6px 2px rgba(0, 0, 0, 0.3);
          padding: 0;
        }
      '';
    };

  xdg.desktopEntries = {
    feh = {
      name="Feh";
      genericName="Image viewer";
      comment="Image viewer and cataloguer";
      exec="feh -F.Z --start-at %u";
      terminal=false;
      type="Application";
      icon="feh";
      categories= [ "Graphics" "2DGraphics" "Viewer" ];
      mimeType=["image/bmp" "image/gif" "image/jpeg" "image/jpg" "image/pjpeg" "image/png" "image/tiff" "image/webp" "image/x-bmp" "image/x-pcx" "image/x-png" "image/x-portable-anymap" "image/x-portable-bitmap" "image/x-portable-graymap" "image/x-portable-pixmap" "image/x-tga" "image/x-xbitmap" "image/heic" ];
      noDisplay=true;
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
      userName = "Vivian Boyse-Peacor";
      userEmail = "mookbot@gmail.com";
    
  };

  # starship - an customizable prompt for any shell
  # programs.starship = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     add_newline = false;
  #     aws.disabled = true;
  #     gcloud.disabled = true;
  #     line_break.disabled = true;
  #   };
  # };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  # programs.alacritty = {
  #   enable = true;
  #   # custom settings
  #   settings = {
  #     env.TERM = "xterm-256color";
  #     font = {
  #       size = 12;
  #       draw_bold_text_with_bright_colors = true;
  #     };
  #     scrolling.multiplier = 5;
  #     selection.save_to_clipboard = true;
  #   };
  # };

#  programs.bash = {
#    enable = true;
#    enableCompletion = true;
#    # TODO add your custom bashrc here
#    # bashrcExtra = ''
#    #   export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
#    # '';
#
#    # set some aliases, feel free to add more or remove some
#    shellAliases = {
#      ffxiv = "lutris lutris:rungameid/1";
#      bloons = "lutris lutris:rungameid/2";
#      # k = "kubectl";
#      # urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#      # urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
#    };
#  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}