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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILtZidsnYj0vktdP1sPKqCno/mFNV6L5aSPxQiskITLT chasinglogic@galactica"
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
