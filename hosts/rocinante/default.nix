{outputs, ...}: {
  imports = [
    ./hardware-configuration.nix
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

  networking = {
    hostName = "rocinante";

    defaultGateway = "192.168.1.1";
    nameservers = [
      "1.1.1.1"
      "1.1.1.2"
    ];

    interfaces.enp1s0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
