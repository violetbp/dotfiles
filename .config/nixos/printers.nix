
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
  services.printing.drivers = with pkgs; [ hplip canon-cups-ufr2 cnijfilter2 ];
  
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon-TS3100-nixconfig";
        location = "Home";
        deviceUri = "http://10.0.0.233/wsd/pnpx-metadata.cgi";
        model = "canonts3100.ppd"; #drv:///sample.drv/generic.ppd 
        ppdOptions = {
          PageSize = "Letter";
        };
      }
    ];
    ensureDefaultPrinter = "Canon-TS3100-nixconfig";
  };

}