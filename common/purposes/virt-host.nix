{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  # Enable TPM emulation
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
    ovmf.packages = [pkgs.OVMFFull.fd];
  };
  # Enable USB redirection
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    # Required to use the default virsh network
    dnsmasq
  ];
}
