{ pkgs, ... }:
{
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    quickshell.package = pkgs.quickshell;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };
}
