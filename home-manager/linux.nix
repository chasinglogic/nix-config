{
  ...
}: {
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:nocaps" "lv3:ralt_alt"];
    };
  };
}
