
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



 fonts.fonts = with pkgs; [
    # Serif fonts
    #roboto ttf_bitstream_vera
    #liberation_ttf dejavu_fonts

    # Mono fonts
    #(nerdfonts.override { fonts = [ 
    #  "FantasqueSansMono" 
    #]; })

    # Emoji
    noto-fonts-emoji
    #openmoji-color
  ];

  fonts.fontconfig = {
    defaultFonts = {
      #emoji = [ "Noto Emoji" ];
      #emoji = [ "OpenMoji Color" ];
    };
  };
