{...}: {
  services.pihole-ftl = {
    enable = true;
    settings = {
      dns.upstreams = ["1.1.1.1#53"  "8.8.8.8#53"];
    };
  };

  services.pihole-web = {
    enable = true;
    ports = ["8080"];
  };

  networking.firewall.allowedTCPPorts = [8080 53];
  networking.firewall.allowedUDPPorts = [8080 53];
}
