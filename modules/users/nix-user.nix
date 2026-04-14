{ ... }:
{
  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "1121";
  };
}
