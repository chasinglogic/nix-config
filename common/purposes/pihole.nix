{...}: {
  services.pihole-ftl = {
    enable = true;
  };

  services.pihole-web = {
    enable = true;
    ports = ["8080"];
  };

  networking.firewall.allowedTCPPorts = [8080 53];
  networking.firewall.allowedUDPPorts = [8080 53];
}
