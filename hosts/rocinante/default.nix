{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/base.nix

    ../common/purposes/virt-host.nix
    ../common/purposes/tailnet.nix
    ../common/purposes/server.nix

    ../common/users/chasinglogic.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
    ];

    config = {
      allowUnfree = false;
    };
  };

  networking.hostName = "rocinante";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
