
{
  config,
  lib,
  pkgs,
  ...
}:

{
  ###### Printers ######
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip pkgs.canon-cups-ufr2 ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon-TS3100";
        location = "Home";
        deviceUri = "http://10.0.3.113/";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "Letter";
        };
      }
    ];
    ensureDefaultPrinter = "Canon-TS3100";
  };

}