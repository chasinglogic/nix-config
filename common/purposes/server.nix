# Base server config for any headless systems.
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Use lts kernel.
  boot.kernelPackages = pkgs.linuxKernel.packageAliases.linux_default;

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };
}
