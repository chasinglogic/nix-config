{
  pkgs,
  config,
  lib,
  ...
}: {
  # TODO: set this up when I get sops in here
  # users.mutableUsers = false;

  users.users.chasinglogic = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # TODO: read these from file
    ];
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
      "wireshark"
      "podman"
      "git"
    ];
    packages = [pkgs.home-manager];
  };
}
