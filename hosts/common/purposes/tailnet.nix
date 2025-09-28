{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.tailscale];

  services.tailscale.enable = true;
  services.tailscale.port = 41641;

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = ["tailscale0"];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [config.services.tailscale.port];

    # allow ssh
    allowedTCPPorts = [22];
  };
}
