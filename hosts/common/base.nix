# Base config for all systems
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Trying out the podman lifestyle for now.
  # virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  environment.systemPackages = with pkgs; [
    unzip
    neovim
    zenith
  ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      trusted-users = ["root" "chasinglogic"];
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "raza.beefalo-drum.ts.net";
        system = "x86_64-linux";
        protocol = "ssh";
        speedFactor = 5;
        supportedFeatures = ["kvm"];
      }
      {
        hostName = "rocinante.beefalo-drum.ts.net";
        system = "x86_64-linux";
        protocol = "ssh";
        speedFactor = 5;
        supportedFeatures = ["kvm"];
      }
    ];
  };
}
